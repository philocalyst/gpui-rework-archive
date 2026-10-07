//! Redaction of secret-like environment assignments in command diagnostics.

use std::sync::LazyLock;

static REDACT_REGEX: LazyLock<regex::Regex> = LazyLock::new(|| {
    regex::Regex::new(r#"([A-Z_][A-Z0-9_]*)=("(?:[^"\\]|\\.)*"|'(?:[^'\\]|\\.)*'|\S+)"#).unwrap()
});

/// Returns whether an environment variable name should have its value redacted.
///
/// Matching is case-sensitive and uses suffixes such as `KEY`, `TOKEN`,
/// `PASSWORD`, and `SECRET`; callers should pass the variable name without an
/// assignment or value.
pub fn should_redact(env_var_name: &str) -> bool {
    const REDACTED_SUFFIXES: &[&str] = &[
        "KEY",
        "TOKEN",
        "PASSWORD",
        "SECRET",
        "PASS",
        "CREDENTIALS",
        "LICENSE",
    ];
    REDACTED_SUFFIXES
        .iter()
        .any(|suffix| env_var_name.ends_with(suffix))
}

/// Redacts secret-like assignments in a command string for diagnostics.
///
/// This is a best-effort textual filter, not a shell parser: it recognizes
/// uppercase variable names followed by `=` and a quoted or non-whitespace
/// value. Other spellings may pass through unchanged.
pub fn redact_command(command: &str) -> String {
    REDACT_REGEX
        .replace_all(command, |caps: &regex::Captures| {
            let var_name = &caps[1];
            let value = &caps[2];
            if should_redact(var_name) {
                format!(r#"{}="[REDACTED]""#, var_name)
            } else {
                format!("{}={}", var_name, value)
            }
        })
        .to_string()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_redact_string_with_multiple_env_vars() {
        let input = r#"failed to spawn command cd "/code/something" && ANTHROPIC_API_KEY="sk-ant-api03-WOOOO" COMMAND_MODE="unix2003" GEMINI_API_KEY="AIGEMINIFACE" HOME="/Users/foo""#;
        let result = redact_command(input);
        let expected = r#"failed to spawn command cd "/code/something" && ANTHROPIC_API_KEY="[REDACTED]" COMMAND_MODE="unix2003" GEMINI_API_KEY="[REDACTED]" HOME="/Users/foo""#;
        assert_eq!(result, expected);
    }
}
