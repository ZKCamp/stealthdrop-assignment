global CANDIDATES: Field = 2;

use dep::std; 
// use dep::std::slice; 
use dep::ecrecover; 
// /path = "../../../../../../../nargo/github.com/colinnielsen/ecrecover-noirv0.8.0"
 
fn main(
  pub_key: [u8; 64],
  signature: [u8; 64],
  hashed_message: pub [u8; 32],
  polynomial: [Field; CANDIDATES + 1], // 3
  polynomial_commitment: Field, // hash of polynomial
  nullifier: pub [u8; 32],
) { 
  // Write your main logic here 

  // 1. Recover the signer's address from signature, hashed message and public key.
  let mut pub_key_x: [u8; 32] = [0; 32];
  let mut pub_key_y: [u8; 32] = [0; 32];

  // populate pub_key_x
  for i in 0..32 {
    pub_key_x[i] = pub_key[i];
    pub_key_y[i] = pub_key[i+32];
    }
    
  let signers_address = ecrecover::ecrecover(pub_key_x, pub_key_y, signature, hashed_message); 
  
  // 2. Check whether the address is included in the polynomial. To do this, you will have to make sure the evaluation of polynomial at address is 0.
  let root = std::hash::pedersen([polynomial[0], polynomial[1]])[0];
  std::println("root:");
  std::println(root);

  let check_root = std::merkle::compute_merkle_root(signers_address, 0, polynomial);
  std::println("...");
  std::println("check root:");
  std::println(check_root);

  
  // Steps to use polynomial commitments in ZKP circuits:
  // 1. Create a polynomial with the hash of values to include
  

  // 2. Hash the polynomial. This hash can be a public input to the circuit

  // 3. In the circuit, check that the user knows a secret value which hashes to an included value in polynomial. This can be done by hashing the input value and asserting the evaluation of the polynomial at that hashed value to be zero

  // 4.  Check that the hash of the polynomial is the same as the public polynomial hash provided


  
  // let address_root = std::hash::pedersen([pub_key_x, pub_key_y]);
  
  // assert (check_root == root);

  let comm_2 = std::hash::pedersen([2])[0]; 
  std::println("...");
  std::println("comm 2");
  std::println(comm_2);

  std::println("polynomial:");
  std::println(polynomial);
  std::println("...");
  std::println("polynomial_commitment (hash of polynomial):");
  std::println(polynomial_commitment);
  std::println("...");
  std::println("hashed_message:");
  std::println(hashed_message);
  std::println("...");
  std::println("signers_address:");
  std::println(signers_address);

  // evaluate_polynomial(polynomial, signers_address);
  
  std::println(evaluate_polynomial);
  
}

fn evaluate_polynomial(polynomial: [Field; CANDIDATES + 1], x: Field) -> Field {
  // Write logic to evaluate polynomial here
  // let polynomial = polynomial;
  x
  
  
  
}


// 3. Check the given nullifier is a valid hash of signature. We are using blake hash for hashing signature. The hash is already implemented and can be accessed via std::hash::blake2s


// #[test]
// fn test_main_0() {
//   std::println("test_main_0");
//   main();
// }

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

