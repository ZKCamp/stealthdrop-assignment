import { NoirNode } from "./NoirNode";
import { convertToHex, writeToToml } from "./common";
import config from "../data/config.json" assert { type: "json" };
// import circuit from '../circuits/target/main.json' assert { type: "json" };
import { fileURLToPath } from 'url';
import { resolve, dirname } from "path";

import { ethers } from "ethers";

// @ts-ignore -- no types
import blake2 from 'blake2';

const PRIME_FIELD = 21888242871839275222246405745257275088548364400416034343698204186575808495617n;

function multiplyPolynomials(coefficients1: bigint[], coefficients2: bigint[]): bigint[] {
    const resultCoefficients: bigint[] = Array(coefficients1.length + coefficients2.length - 1).fill(0n);
    for (let i = 0; i < coefficients1.length; i++) {
        for (let j = 0; j < coefficients2.length; j++) {
            resultCoefficients[i + j] = modulo((coefficients1[i] * coefficients2[j]) + resultCoefficients[i + j], PRIME_FIELD);
        }
    }
    return resultCoefficients;
}

function formPolynomial(roots: Array<bigint>): Array<bigint> {
    let poly = [1n];
    for (const root of roots) {
        poly = multiplyPolynomials(poly, [-1n * root, 1n]);
    }
    return poly;
}

function modulo(num: bigint, primeField: bigint) {
    let val = num % primeField;

    if (val < 0) {
        return val + primeField;
    }
    else {
        return val;
    }
}

function evaluatePolynomial(polynomial: Array<bigint>, x: bigint): bigint {
    let mult = 1n;
    let evaluation = 0n;

    for (let idx = 0; idx < polynomial.length; idx++) {
        evaluation = modulo(mult * polynomial[idx] + evaluation, PRIME_FIELD);
        mult = mult * x;
    }

    return evaluation;
}

export async function main() {
    const noir = new NoirNode();
    await noir.init();

    let walletPrivKeys = config.priv_keys;
    const getWallet = (privKey: string) => new ethers.Wallet(privKey);

    let wallets = walletPrivKeys.map(getWallet);
    let addresses = wallets.map((wallet) => BigInt(wallet.address));
    let user = wallets[0];

    let polynomialInNum = formPolynomial(addresses);
    let polynomial = polynomialInNum.map((elem) => convertToHex(elem));

    const pubKey = Array.from(ethers.utils.arrayify(user.publicKey).slice(1).values());
    let message = '0xabfd76608112cc843dca3a31931f3974da5f9f5d32833e7817bc7e5c50c7821e';

    let signature = Array.from(ethers.utils.arrayify(await user.signMessage(message)).slice(0, 64).values());

    let polynomialCommitment = convertToHex(await noir.pedersenHash(polynomialInNum));

    let hashedMessage = ethers.utils.hashMessage(message);
    let hashed_message = Array.from(ethers.utils.arrayify(hashedMessage).values());

    const nullifierBuff = blake2
        .createHash('blake2s')
        .update(ethers.utils.arrayify(signature).slice(0, 64))
        .digest();

    let nullifier = Array.from(nullifierBuff).map((elem) => Number(elem));

    let data = {
        pub_key: pubKey,
        signature,
        hashed_message,
        nullifier,
        polynomial,
        polynomial_commitment: polynomialCommitment
    };

    console.log(data);

    const dir = dirname(fileURLToPath(import.meta.url));
    let path = resolve(dir + "/../circuits/Prover.toml");

    writeToToml(data, path);
}

main();