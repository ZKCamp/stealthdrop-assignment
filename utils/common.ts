import * as toml from '@iarna/toml';
import * as fs from 'fs';

export function convertToHex(num: BigInt | number) {
    let hexVal = num.toString(16);
    return '0x' + (hexVal.length % 2 == 0 ? hexVal : "0" + hexVal);
}

export function writeToToml(content: toml.JsonMap, filePath: string) {
    const tomlString = toml.stringify(content);
    fs.writeFileSync(filePath, tomlString);
}