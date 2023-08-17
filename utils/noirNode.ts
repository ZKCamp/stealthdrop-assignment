// TODO use the JSON directly for now
// import { compile } from '@noir-lang/noir_wasm';
import { decompressSync } from 'fflate';
import {
  BarretenbergApiAsync,
  Crs,
  newBarretenbergApiAsync,
  RawBuffer,
} from '@aztec/bb.js/dest/node/index.js';
import { executeCircuit, compressWitness } from '@noir-lang/acvm_js';
import { ethers } from 'ethers';
import { Ptr, Fr } from '@aztec/bb.js/dest/node/types/index.js';


export class NoirNode {
  acir: string = '';
  acirBuffer: Uint8Array = Uint8Array.from([]);
  acirBufferUncompressed: Uint8Array = Uint8Array.from([]);

  api = {} as BarretenbergApiAsync;
  acirComposer = {} as Ptr;

  async init() {
    this.api = await newBarretenbergApiAsync(4);
  }
  
  async pedersenHash(data: BigInt[] | Number[]) {
    let hexData = [];

    for (let dataPoint of data) {
      let hexVal = ethers.utils.hexZeroPad(`0x${dataPoint.toString(16)}`, 32);
      let num = Fr.fromString(hexVal);

      hexData.push(num);
    }

    let hash = await this.api.pedersenPlookupCommit(hexData);
    return hash.value;
  }

  async destroy() {
    await this.api.destroy();
  }
}