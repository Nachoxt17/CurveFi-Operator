/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { BFactory, BFactoryInterface } from "../BFactory";

const _abi = [
  {
    constant: true,
    inputs: [
      {
        internalType: "address",
        name: "b",
        type: "address",
      },
    ],
    name: "isBPool",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    payable: false,
    stateMutability: "view",
    type: "function",
  },
  {
    constant: false,
    inputs: [],
    name: "newBPool",
    outputs: [
      {
        internalType: "contract BPool",
        name: "",
        type: "address",
      },
    ],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
];

export class BFactory__factory {
  static readonly abi = _abi;
  static createInterface(): BFactoryInterface {
    return new utils.Interface(_abi) as BFactoryInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): BFactory {
    return new Contract(address, _abi, signerOrProvider) as BFactory;
  }
}
