use rsa::{Pkcs1v15Encrypt, RsaPrivateKey, RsaPublicKey};

fn main() {
    let mut rng = rand::thread_rng();
    let bits = 2048;
    let priv_key = RsaPrivateKey::new(&mut rng, bits).expect("failed to generate a key");
    let pub_key = RsaPublicKey::from(&priv_key);

fn check_string_has_4_zeros(input_string: &str) -> bool {
    let re = Regex::new(r"^0000.*").unwrap();
    re.is_match(input_string)
}

fn pow_with_4_zeros() -> String {
    let nickname = "Soso";
    let mut nonce = 1;
    let mut nickname_nonce = nickname.to_string() + &nonce.to_string();
    let mut hashed_nickname = digest(nickname_nonce.clone());

    loop {
        if check_string_has_4_zeros(&hashed_nickname) == true {
            println!("{} find 4 zeros: {}", nickname_nonce, hashed_nickname);
            break;
        }

        nonce += 1;
        nickname_nonce = nickname.to_string() + &nonce.to_string();
        hashed_nickname = digest(nickname_nonce.clone());
    }

    hashed_nickname
}
