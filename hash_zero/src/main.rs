use regex::Regex;
use sha256::digest;

fn main() {
    let mut nickname = "Soso";
    let mut hashed_nickname = digest(&mut nickname);
    loop {
        if check_string_has_4_zeros(&hashed_nickname) == true {
            println!("has 4 zeros: {}", hashed_nickname);
            loop {
                if check_string_has_5_zeros(&hashed_nickname) == true {
                    println!("has 5 zeros: {}", hashed_nickname);
                    break;
                }
                hashed_nickname = digest(hashed_nickname);
            }
            break;
        }

        hashed_nickname = digest(hashed_nickname);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let five_zero = "000abc00";
        let has_5_zeros = check_string_has_5_zeros(five_zero);
        assert_eq!(has_5_zeros, true);

        let four_zero = "00abc00";
        let has_4_zeros = check_string_has_4_zeros(four_zero);
        assert_eq!(has_4_zeros, true);
    }
}

fn check_string_has_5_zeros(input_string: &str) -> bool {
    let re = Regex::new(r"^(?:[^0]*0){5}[^0]*$").unwrap();
    re.is_match(input_string)
}

fn check_string_has_4_zeros(input_string: &str) -> bool {
    let re = Regex::new(r"^(?:[^0]*0){4}[^0]*$").unwrap();
    re.is_match(input_string)
}
