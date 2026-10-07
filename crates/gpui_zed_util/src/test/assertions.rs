/// The first element found in one set but missing from the other.
///
/// `LeftMissing` means the left set does not contain a value present in the
/// right set; `RightMissing` means the converse. The variants identify the side
/// that is missing the value, not the side it came from.
pub enum SetEqError<T> {
    LeftMissing(T),
    RightMissing(T),
}

impl<T> SetEqError<T> {
    /// Transform the missing value while preserving which side lacked it.
    pub fn map<R, F: FnOnce(T) -> R>(self, update: F) -> SetEqError<R> {
        match self {
            SetEqError::LeftMissing(missing) => SetEqError::LeftMissing(update(missing)),
            SetEqError::RightMissing(missing) => SetEqError::RightMissing(update(missing)),
        }
    }
}

/// Return the first difference between two set-like collections, or `Ok(())`
/// when each contains every value from the other. Iteration order determines
/// which difference is reported when there is more than one.
#[macro_export]
macro_rules! set_eq {
    ($left:expr,$right:expr) => {{
        use util::test::*;

        let left = $left;
        let right = $right;

        let mut result = Ok(());
        for right_value in right.iter() {
            if !left.contains(right_value) {
                result = Err(SetEqError::LeftMissing(right_value.clone()));
                break;
            }
        }

        if result.is_ok() {
            for left_value in left.iter() {
                if !right.contains(left_value) {
                    result = Err(SetEqError::RightMissing(left_value.clone()));
                }
            }
        }

        result
    }};
}

/// Assert set equality and panic with the first missing value and both inputs.
///
/// Each expression is evaluated once. Values need `iter`, `contains`, `Clone`
/// (for the missing item), and `Debug` (for a failure message).
#[macro_export]
macro_rules! assert_set_eq {
    ($left:expr,$right:expr) => {{
        use util::test::*;
        use util::set_eq;

        let left = $left;
        let right = $right;

        match set_eq!(&left, &right) {
            Err(SetEqError::LeftMissing(missing)) => {
                panic!("assertion failed: `(left == right)`\n left: {:?}\nright: {:?}\nleft does not contain {:?}", &left, &right, &missing);
            },
            Err(SetEqError::RightMissing(missing)) => {
                panic!("assertion failed: `(left == right)`\n left: {:?}\nright: {:?}\nright does not contain {:?}", &left, &right, &missing);
            },
            _ => {}
        }
    }};
}
