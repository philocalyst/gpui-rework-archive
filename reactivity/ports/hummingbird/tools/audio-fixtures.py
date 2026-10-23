#!/usr/bin/env python3
"""Generate the deterministic nonzero stereo corpus; FFmpeg is only a fixture tool."""
import math
from pathlib import Path
import struct
import subprocess
import sys
import wave

out = Path(__file__).resolve().parent.parent / 'assets' / 'audio'
with wave.open(str(out / 'stereo.wav'), 'wb') as audio:
    audio.setparams((2, 2, 44100, 17239, 'NONE', 'not compressed'))
    audio.writeframes(b''.join(struct.pack('<hh',
        round(11000 * math.sin(2 * math.pi * 220 * i / 44100) + 2000 * ((i % 251) / 250 - .5)),
        round(5500 * math.sin(2 * math.pi * 733 * i / 44100))) for i in range(17239)))
ffmpeg = sys.argv[1]
subprocess.run([ffmpeg, '-version'], check=True)
for extension, codec in [('flac', ['-c:a', 'flac', '-compression_level', '8']),
                          ('mp3', ['-c:a', 'libmp3lame', '-b:a', '192k'])]:
    subprocess.run([ffmpeg, '-hide_banner', '-loglevel', 'error', '-y', '-i', str(out / 'stereo.wav'),
                    '-map_metadata', '-1', '-fflags', '+bitexact', '-flags:a', '+bitexact',
                    *codec, str(out / ('stereo.' + extension))], check=True)
