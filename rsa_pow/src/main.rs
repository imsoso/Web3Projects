use regex::Regex;
use sha256::digest;

use crypto::*;
use ed25519::{keypair, signature, verify};
fn main() {
    let seed: &[u8] = &[
        0x26, 0x27, 0xf6, 0x85, 0x97, 0x15, 0xad, 0x1d, 0xd2, 0x94, 0xdd, 0xc4, 0x76, 0x19, 0x39,
        0x31, 0xf1, 0xad, 0xb5, 0x58, 0xf0, 0x93, 0x97, 0x32, 0x19, 0x2b, 0xd1, 0xc0, 0xfd, 0x16,
        0x8e, 0x4e,
    ]; //32位

    // KEYGEN
    let (private_key, public_key) = keypair(seed); //[U8,64]

    let binding = pow_with_4_zeros();
    let message = binding.as_bytes();

    //私钥签名
    let sig = signature(message, &private_key); //[U8,64]

    //private_key
    println!("private_key: {:?} ", private_key.to_vec());
    println!("private_key_len :{:? }", private_key.len());

    // public_key
    println!("public_key :{:?}", public_key.to_vec());
    println!("public_key_len :{:?}", public_key.len());

    //signature
    println!("signature:{:?}", sig.to_vec());
    println!("signature_len:{:?}", sig.len());

    // verify
    println!("验证是否成功：{:?} ", verify(message, &public_key, &sig));
}

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
