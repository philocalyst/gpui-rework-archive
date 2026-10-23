//! Symphonia owner. Conversion/remainder handling derives from Hummingbird
//! e15e8ba, media/builtin/symphonia.rs; metadata/provider registries are omitted.
use super::{AudioError, Format, MediaInfo, block::AudioBlock};
use std::{fs::File, path::Path};
use symphonia::core::{
    audio::{Audio, GenericAudioBufferRef},
    codecs::audio::{AudioDecoder, AudioDecoderOptions},
    errors::Error,
    formats::{FormatOptions, FormatReader, SeekMode, SeekTo, TrackType, probe::Hint},
    io::MediaSourceStream,
    meta::MetadataOptions,
    units::{Time, TimeBase},
};
const MAX_PACKET_FRAMES: usize = 1_048_576;

pub(super) struct Decoder {
    format: Box<dyn FormatReader>,
    codec: Box<dyn AudioDecoder>,
    track: u32,
    time_base: Option<TimeBase>,
    pub info: MediaInfo,
    packet: Vec<Vec<f64>>,
    packet_offset: usize,
    packet_position: f64,
    position: f64,
    seek_to: Option<f64>,
    eof: bool,
}
fn failure(error: Error) -> AudioError {
    match error {
        Error::IoError(error) => AudioError::Io(error.kind()),
        Error::Unsupported(_) => AudioError::Unsupported("audio container or codec"),
        other => AudioError::Decode(other.to_string()),
    }
}
impl Decoder {
    pub fn open(path: &Path) -> Result<Self, AudioError> {
        let file = File::open(path).map_err(|error| AudioError::Io(error.kind()))?;
        let stream = MediaSourceStream::new(Box::new(file), Default::default());
        let mut hint = Hint::new();
        if let Some(extension) = path.extension().and_then(|extension| extension.to_str()) {
            hint.with_extension(extension);
        }
        let format = symphonia::default::get_probe()
            .probe(
                &hint,
                stream,
                FormatOptions::default(),
                MetadataOptions::default(),
            )
            .map_err(failure)?;
        let track = format
            .first_track_known_codec(TrackType::Audio)
            .ok_or(AudioError::Unsupported("audio track"))?;
        let parameters = track
            .codec_params
            .as_ref()
            .and_then(|params| params.audio())
            .ok_or(AudioError::Unsupported("audio parameters"))?;
        let config = Format {
            rate: parameters.sample_rate.unwrap_or(44_100),
            channels: parameters
                .channels
                .as_ref()
                .map_or(2, |channels| channels.count() as u16),
        }
        .checked()?;
        let capacity = parameters.max_frames_per_packet.unwrap_or(8192) as usize;
        if capacity > MAX_PACKET_FRAMES {
            return Err(AudioError::Unsupported("oversized codec packet"));
        }
        let codec = symphonia::default::get_codecs()
            .make_audio_decoder(parameters, &AudioDecoderOptions::default())
            .map_err(failure)?;
        let time_base = track.time_base;
        let duration_ms = track
            .num_frames
            .zip(time_base)
            .and_then(|(frames, base)| {
                base.calc_time(symphonia::core::units::Timestamp::new(frames as i64))
            })
            .map(|time| (time.as_secs_f64() * 1000.) as u64);
        let id = track.id;
        Ok(Self {
            format,
            codec,
            track: id,
            time_base,
            info: MediaInfo {
                format: config,
                duration_ms,
            },
            packet: (0..config.channels)
                .map(|_| Vec::with_capacity(capacity))
                .collect(),
            packet_offset: 0,
            packet_position: 0.,
            position: 0.,
            seek_to: None,
            eof: false,
        })
    }
    pub fn seek(&mut self, milliseconds: u64) -> Result<(), AudioError> {
        let seconds = milliseconds as f64 / 1000.;
        self.format
            .seek(
                SeekMode::Accurate,
                SeekTo::Time {
                    time: Time::try_from_secs_f64(seconds)
                        .ok_or(AudioError::Unsupported("seek time"))?,
                    track_id: Some(self.track),
                },
            )
            .map_err(failure)?;
        self.codec.reset();
        for plane in &mut self.packet {
            plane.clear();
        }
        self.packet_offset = 0;
        self.seek_to = Some(seconds);
        self.position = seconds;
        self.eof = false;
        Ok(())
    }
    /// False means exhausted; a final partial block is always returned first.
    pub fn decode(&mut self, block: &mut AudioBlock) -> Result<bool, AudioError> {
        block.clear();
        block.position_ms = (self.position * 1000.) as u64;
        while block.frames < block.capacity() {
            let available = self
                .packet
                .first()
                .map_or(0, Vec::len)
                .saturating_sub(self.packet_offset);
            if available > 0 {
                let take = available.min(block.capacity() - block.frames);
                if block.frames == 0 {
                    block.position_ms = ((self.packet_position
                        + self.packet_offset as f64 / f64::from(block.format.rate))
                        * 1000.) as u64;
                }
                for (output, input) in block.planes.iter_mut().zip(&self.packet) {
                    output.extend_from_slice(&input[self.packet_offset..self.packet_offset + take]);
                }
                self.packet_offset += take;
                block.frames += take;
                self.position =
                    self.packet_position + self.packet_offset as f64 / f64::from(block.format.rate);
                continue;
            }
            if self.eof {
                break;
            }
            let packet = match self.format.next_packet() {
                Ok(Some(packet)) => packet,
                Ok(None) => {
                    self.eof = true;
                    continue;
                }
                Err(Error::IoError(error)) if error.kind() == std::io::ErrorKind::UnexpectedEof => {
                    self.eof = true;
                    continue;
                }
                Err(error) => return Err(failure(error)),
            };
            if packet.track_id != self.track {
                continue;
            }
            self.format.metadata().skip_to_latest();
            let decoded = self.codec.decode(&packet).map_err(failure)?;
            let spec = decoded.spec();
            let actual = Format {
                rate: spec.rate(),
                channels: spec.channels().count() as u16,
            }
            .checked()?;
            if actual != block.format {
                return Err(AudioError::Unsupported("mid-stream format change"));
            }
            if decoded.frames() > MAX_PACKET_FRAMES {
                return Err(AudioError::Unsupported("oversized decoded packet"));
            }
            self.packet_position = self
                .time_base
                .and_then(|base| base.calc_time(packet.pts))
                .map_or(self.position, |time| time.as_secs_f64());
            let skip = self
                .seek_to
                .map_or(0, |target| {
                    ((target - self.packet_position).max(0.) * f64::from(actual.rate)).ceil()
                        as usize
                })
                .min(decoded.frames());
            if self.packet_position + decoded.frames() as f64 / f64::from(actual.rate)
                >= self.seek_to.unwrap_or(0.)
            {
                self.seek_to = None;
            }
            for plane in &mut self.packet {
                plane.clear();
            }
            convert(decoded, &mut self.packet);
            self.packet_offset = skip;
        }
        Ok(block.frames > 0)
    }
}
fn convert(decoded: GenericAudioBufferRef<'_>, output: &mut [Vec<f64>]) {
    macro_rules! planes {
        ($buffer:ident, $sample:expr) => {{
            for (channel, output) in output.iter_mut().enumerate() {
                if let Some(input) = $buffer.plane(channel) {
                    output.extend(input.iter().map($sample));
                }
            }
        }};
    }
    match decoded {
        GenericAudioBufferRef::U8(v) => planes!(v, |&s| (i16::from(s) - 128) as f64 / 128.),
        GenericAudioBufferRef::U16(v) => planes!(v, |&s| (i32::from(s) - 32768) as f64 / 32768.),
        GenericAudioBufferRef::U24(v) => {
            planes!(v, |s| (i64::from(s.0.min(0xff_ffff)) - 0x80_0000) as f64
                / 8_388_608.)
        }
        GenericAudioBufferRef::U32(v) => planes!(v, |&s| (i64::from(s) - 2_147_483_648) as f64
            / 2_147_483_648.),
        GenericAudioBufferRef::S8(v) => planes!(v, |&s| f64::from(s) / 128.),
        GenericAudioBufferRef::S16(v) => planes!(v, |&s| f64::from(s) / 32768.),
        GenericAudioBufferRef::S24(v) => {
            planes!(v, |s| f64::from(s.0.clamp(-0x80_0000, 0x7f_ffff))
                / 8_388_608.)
        }
        GenericAudioBufferRef::S32(v) => planes!(v, |&s| f64::from(s) / 2_147_483_648.),
        GenericAudioBufferRef::F32(v) => planes!(v, |&s| f64::from(s)),
        GenericAudioBufferRef::F64(v) => planes!(v, |&s| s),
    }
}
