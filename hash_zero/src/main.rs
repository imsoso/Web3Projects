use regex::Regex;
use sha256::digest;
use std::time::Instant;

fn main() {
    let nickname = "Soso";
    let mut nonce = 1;
    let mut nickname_nonce = nickname.to_string() + &nonce.to_string();
    let mut hashed_nickname = digest(nickname_nonce);
    let start = Instant::now();

    loop {
        if check_string_has_4_zeros(&hashed_nickname) == true {
            let duration = start.elapsed().as_millis();
            println!("find 4 zeros: {} in {}ms", hashed_nickname, duration);
            loop {
                if check_string_has_5_zeros(&hashed_nickname) == true {
                    let duration = start.elapsed().as_millis();

                    println!("find 5 zeros: {} in {}ms", hashed_nickname, duration);
                    break;
                }
                nonce += 1;
                nickname_nonce = nickname.to_string() + &nonce.to_string();
                hashed_nickname = digest(nickname_nonce);
            }
            break;
        }

        nonce += 1;
        nickname_nonce = nickname.to_string() + &nonce.to_string();
        hashed_nickname = digest(nickname_nonce);
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
