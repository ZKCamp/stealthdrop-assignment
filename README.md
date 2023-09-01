# My note

I tried my best, but I got stuck on the 2nd step.


# ZK Stealth Drop Assignment

## What is a stealth drop?

StealthDrop is an airdrop utility that enables token airdrops to be claimed by completely anonymous accounts. The purpose of StealthDrop is to address the privacy and identity issues associated with traditional token airdrops, where recipients' identities and actions are often known and visible to others.

The mechanism of StealthDrop involves a combination of techniques such as zero-knowledge proofs, proof of inclusion, and cryptographic signatures. Here's a summary of how it works:

The airdropper creates a polynomial with roots as addresses eligible for the airdrop. The polynomials commitment (hash of polynomial) is publically available. The eligibility of an address to claim the airdrop can be checked by evaluating the polynomial at that point and proving that it is 0. ZKPs are used to establish the following:

* The validity of an ECDSA signature's origin from a particular public key.

* The inclusion of the public key in the polynomial.

* The hash of the signature (also called nullifier) is derived from the signature, it helps in preventing double-claiming.

* ECDSA signature verification is done to ensure that the signature is actually signed by the corresponding private key of the given public key.


## Instructions

Use the below steps to form the logic of circuit:

* Recover the signer's address from signature, hashed message and public key.

* Check whether the address is included in the polynomial. To do this, you will have to make sure the evaluation of polynomial at address is 0.

* Check the given nullifier is a valid hash of signature. We are using `blake` hash for hashing signature. The hash is already implemented and can be accessed via `std::hash::blake2s`

* `Prover.toml` file already has sample inputs. You can regenerate the inputs using the following command

```bash
npm run generate-example-inputs
```

__Note: The [file](utils/populate.ts) being used to populate the inputs is also very useful for understanding how the inputs are being formed.__

## How do polynomial commitments work?

* Values can be encoded in polynomials similar to how it is done in merkle trees. For example, values a, b can be represented by polynomial (x - a) * (x - b). This polynomial has roots a, b

* To check the inclusion of a value, you can check if the value is a root of the polynomial

* Steps to use polynomial commitments in ZKP circuits:

    * Create a polynomial with the hash of values to include

    * Hash the polynomial. This hash can be a public input to the circuit

    * In the circuit, check that the user knows a secret value which hashes to an included value in polynomial. This can be done by hashing the input value and asserting the evaluation of the polynomial at that hashed value to be zero

    * Check that the hash of the polynomial is the same as the public polynomial hash provided

## Setup

* Install dependencies

```bash
yarn
```

* Make sure you are using the nargo version `0.7.1`. The libraries being used are only compatible with this version. You can check your nargo version using the below command

```bash
nargo --version
```

* If you have some other version of nargo installed. Use this command to install the required version

```bash
noirup -v 0.7.1
```

## Evaluation

-   Create a fork of this repo.

-   Clone the forked repo. You can use the following command after replacing the `CLONE_URL` with the clone url of your repo

    ```
    git clone CLONE_URL
    ```
-   Create a new branch

    ```
    git checkout -b solution
    ```
    
-   Make changes to the `circuits/src/main.nr` file.

-   Run Tests
    ```
    nargo test
    ```

-   Push your changes to `solution` branch and create a pull request to the main branch of your forked repo.

-   Submit your name, email and link to your forked repo [here](https://airtable.com/apppwJwKgRGomJLLY/shrlDlkFR3XZKZRmN).

## Reference

- [Noir Docs](https://noir-lang.org/)
