global CANDIDATES: Field = 2;

use dep::std;
use dep::ecrecover;

fn main(
  pub_key: [u8; 64],
  signature: [u8; 64],
  hashed_message: pub [u8; 32],
  polynomial: [Field; CANDIDATES + 1],
  polynomial_commitment: Field,
  nullifier: pub [u8; 32],
) {
  let key = ecrecover::secp256k1::PubKey::from_unified(pub_key);
  let address = key.to_eth_address();
  
  // Check signature validity
  let is_valid = key.verify_sig(signature, hashed_message);
  assert(is_valid);

  // Check polynomial
  assert(polynomial_commitment == std::hash::pedersen(polynomial)[0]);
  assert(evaluate_polynomial(polynomial, address) == 0);
  
  // Check nullifier
  assert(std::hash::blake2s(nullifier)[0] == 0);
}

fn evaluate_polynomial(polynomial: [Field; CANDIDATES + 1], x: Field) -> Field {
  // Write logic to evaluate polynomial here
  //
  //let mult = 1n;
  //  let evaluation = 0n;
//
  //  for (let idx = 0; idx < polynomial.length; idx++) {
  //      evaluation = modulo(mult * polynomial[idx] + evaluation, PRIME_FIELD);
  //      mult = mult * x;
  //  }
//
  //  return evaluation;
  //
  let mut mult = 1;
  let mut evaluation = 0;
  for idx in 0..polynomial.len() {
    evaluation = (mult * polynomial[idx] + evaluation);
    mult = mult * x;
  }
  evaluation
}

#[test]
fn test_main() {
  let pub_key = [131,  24,  83,  91,  84,  16,  93,  74,  122,  174,  96,  192,  143,  196,  95,  150,  135,  24,  27,  79,  223,  198,  37,  189,  26,  117,  63,  167,  57,  127,  237,  117,  53,  71,  241,  28,  168,  105,  102,  70,  242,  243,  172,  176,  142,  49,  1,  106,  250,  194,  62,  99,  12,  93,  17,  245,  159,  97,  254,  245,  123,  13,  42,  165];
  let signature = [1,  83,  82,  167,  184,  77,  226,  104,  5,  27,  151,  91,  202,  127,  17,  183,  75,  31,  190,  253,  159,  116,  155,  13,  24,  178,  40,  165,  129,  90,  103,  204,  42,  164,  230,  62,  73,  181,  169,  61,  251,  221,  128,  221,  14,  19,  179,  25,  107,  132,  10,  188,  149,  0,  197,  52,  151,  239,  244,  103,  215,  224,  56,  242];

  let hashed_message = [3,  57, 199, 96, 145, 58, 183, 241, 206, 140, 36, 34, 165, 163, 17, 210, 97, 254, 154, 79, 91, 223, 149, 18, 3, 210, 111, 56, 246, 219, 19, 104];

  let polynomial = [
    0x0832c9fedf291cc3adf56eefd21ac09630c66ad67747329385c9fcfc7cbf8d38,
    0x30644e72e131a029b85045b51d480807486e4c754ae9f95bbfba6db6d86a63d3,
    0x01
  ];

  let polynomial_commitment = 0x1eceef64088bbbeb280bee01b3f4e611137e8d0ac5a868f538e4617df5c62ec2;
  let nullifier = [142,  197,  227,  35,  35,  142,  255,  176,  38,  63,  247,  168,  33,  178,  55,  202,  46,  76,  167,  202,  130,  208,  59,  14,  151,  19,  144,  228,  58,  37,  10,  101];

  main(pub_key, signature, hashed_message, polynomial, polynomial_commitment, nullifier);
}

