//! Frozen byte/x records. The common map infers affinity only when every source
//! group was exactly [both] or [upstream, downstream]; otherwise retain masks.
use super::{Carets, CommonStop, Stop, Stops};
use std::ops::Range;

impl Carets {
    pub(in crate::text) fn freeze(stops: Vec<Stop>) -> Self {
        if stops
            .chunk_by(|a, b| a.byte == b.byte)
            .all(|group| match group {
                [only] => only.affinities == 3,
                [up, down] => up.affinities == 1 && down.affinities == 2,
                _ => false,
            })
        {
            Self::Common(
                stops
                    .into_iter()
                    .map(|stop| CommonStop {
                        byte: stop.byte,
                        x: stop.x,
                    })
                    .collect(),
            )
        } else {
            Self::General(stops.into_boxed_slice())
        }
    }
    pub(in crate::text) fn stops(&self) -> Stops<'_> {
        match self {
            Self::Common(stops) => Stops::Common(stops),
            Self::General(stops) => Stops::General(stops),
        }
    }
    #[cfg(test)]
    pub(in crate::text) fn payload_bytes(&self) -> usize {
        match self {
            Self::Common(stops) => std::mem::size_of_val(&**stops),
            Self::General(stops) => std::mem::size_of_val(&**stops),
        }
    }
}
impl<'a> Stops<'a> {
    pub(in crate::text) fn empty() -> Self {
        Self::Common(&[])
    }
    pub(in crate::text) fn len(self) -> usize {
        match self {
            Self::Common(stops) => stops.len(),
            Self::General(stops) => stops.len(),
        }
    }
    pub(in crate::text) fn get(self, index: usize) -> Option<Stop> {
        match self {
            Self::General(stops) => stops.get(index).copied(),
            Self::Common(stops) => {
                let stop = stops.get(index)?;
                let affinities = if stops
                    .get(index + 1)
                    .is_some_and(|next| next.byte == stop.byte)
                {
                    1
                } else if index != 0 && stops[index - 1].byte == stop.byte {
                    2
                } else {
                    3
                };
                Some(Stop {
                    byte: stop.byte,
                    x: stop.x,
                    affinities,
                })
            }
        }
    }
    pub(in crate::text) fn before(self, byte: u32) -> usize {
        match self {
            Self::Common(stops) => stops.partition_point(|stop| stop.byte < byte),
            Self::General(stops) => stops.partition_point(|stop| stop.byte < byte),
        }
    }
    pub(in crate::text) fn through(self, byte: u32) -> usize {
        match self {
            Self::Common(stops) => stops.partition_point(|stop| stop.byte <= byte),
            Self::General(stops) => stops.partition_point(|stop| stop.byte <= byte),
        }
    }
    // Callers cut only at byte-group boundaries. Neighbors used to infer an
    // affinity therefore remain inside this borrowed slice, including wraps.
    pub(in crate::text) fn slice(self, range: Range<usize>) -> Self {
        debug_assert!(
            range.start == 0
                || self.get(range.start - 1).map(|s| s.byte)
                    != self.get(range.start).map(|s| s.byte)
        );
        debug_assert!(
            range.end == self.len()
                || range.end == 0
                || self.get(range.end - 1).map(|s| s.byte) != self.get(range.end).map(|s| s.byte)
        );
        match self {
            Self::Common(stops) => Self::Common(&stops[range]),
            Self::General(stops) => Self::General(&stops[range]),
        }
    }
    pub(in crate::text) fn iter(self) -> impl Iterator<Item = Stop> + Clone + 'a {
        (0..self.len()).map(move |index| self.get(index).unwrap())
    }
    pub(in crate::text) fn groups(self) -> impl Iterator<Item = Self> + Clone + 'a {
        let mut next = 0;
        std::iter::from_fn(move || {
            let first = next;
            let byte = self.get(first)?.byte;
            next += 1;
            while self.get(next).is_some_and(|stop| stop.byte == byte) {
                next += 1;
            }
            Some(self.slice(first..next))
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn frozen_maps_preserve_every_record_and_fall_back_for_exclusive_affinities() {
        let common = vec![
            Stop {
                byte: 0,
                x: -0.,
                affinities: 3,
            },
            Stop {
                byte: 9,
                x: 1.,
                affinities: 1,
            },
            Stop {
                byte: 9,
                x: 1.,
                affinities: 2,
            },
            Stop {
                byte: u32::MAX,
                x: f32::MAX,
                affinities: 3,
            },
        ];
        for tail in [None, Some(1), Some(2), Some(0)] {
            let mut source = common.clone();
            if let Some(affinities) = tail {
                source.last_mut().unwrap().affinities = affinities;
            }
            let encoded = Carets::freeze(source.clone());
            assert_eq!(matches!(encoded, Carets::Common(_)), tail.is_none());
            let decoded = encoded.stops().iter().collect::<Vec<_>>();
            assert_eq!(decoded.len(), source.len());
            for (a, b) in source.iter().zip(&decoded) {
                assert_eq!(
                    (a.byte, a.x.to_bits(), a.affinities),
                    (b.byte, b.x.to_bits(), b.affinities)
                );
            }
            let stops = encoded.stops();
            let group = stops.slice(stops.before(9)..stops.through(9));
            assert_eq!(
                group.iter().map(|s| s.affinities).collect::<Vec<_>>(),
                [1, 2]
            );
        }
        let mut unexpected = common;
        unexpected.insert(
            2,
            Stop {
                byte: 9,
                x: -f32::MIN_POSITIVE,
                affinities: 1,
            },
        );
        assert!(matches!(Carets::freeze(unexpected), Carets::General(_)));
    }
}
