mod passport;

use passport::Passport;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    // Add newline to eof because lines ignores the final newline
    let mut fixed_input = String::from(&args[0]);
    fixed_input.push('\n');

    let mut valid_passports = 0;
    let mut new_passport = Passport::new();
    fixed_input.lines()
        .for_each(|line| {
            let trimmed_line = String::from(line.trim());
            if trimmed_line.is_empty() {
                if new_passport.is_valid() {
                    valid_passports += 1;
                }
                new_passport = Passport::new();
            } else {
            trimmed_line.split_whitespace()
                .for_each(|val| new_passport.update_value(val))
            }
        });

    Ok(valid_passports.to_string())
}
