/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import {
  ethers,
  EventFilter,
  Signer,
  BigNumber,
  BigNumberish,
  PopulatedTransaction,
  BaseContract,
  ContractTransaction,
  CallOverrides,
} from "ethers";
import { BytesLike } from "@ethersproject/bytes";
import { Listener, Provider } from "@ethersproject/providers";
import { FunctionFragment, EventFragment, Result } from "@ethersproject/abi";
import type { TypedEventFilter, TypedEvent, TypedListener } from "./common";

interface StdStorageInterface extends ethers.utils.Interface {
  functions: {
    "bytesToBytes32(bytes,uint256)": FunctionFragment;
  };

  encodeFunctionData(
    functionFragment: "bytesToBytes32",
    values: [BytesLike, BigNumberish]
  ): string;

  decodeFunctionResult(
    functionFragment: "bytesToBytes32",
    data: BytesLike
  ): Result;

  events: {
    "SlotFound(address,bytes4,bytes32,uint256)": EventFragment;
    "WARNING_UninitedSlot(address,uint256)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "SlotFound"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "WARNING_UninitedSlot"): EventFragment;
}

export type SlotFoundEvent = TypedEvent<
  [string, string, string, BigNumber] & {
    who: string;
    fsig: string;
    keysHash: string;
    slot: BigNumber;
  }
>;

export type WARNING_UninitedSlotEvent = TypedEvent<
  [string, BigNumber] & { who: string; slot: BigNumber }
>;

export class StdStorage extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  listeners<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter?: TypedEventFilter<EventArgsArray, EventArgsObject>
  ): Array<TypedListener<EventArgsArray, EventArgsObject>>;
  off<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  on<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  once<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  removeListener<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  removeAllListeners<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>
  ): this;

  listeners(eventName?: string): Array<Listener>;
  off(eventName: string, listener: Listener): this;
  on(eventName: string, listener: Listener): this;
  once(eventName: string, listener: Listener): this;
  removeListener(eventName: string, listener: Listener): this;
  removeAllListeners(eventName?: string): this;

  queryFilter<EventArgsArray extends Array<any>, EventArgsObject>(
    event: TypedEventFilter<EventArgsArray, EventArgsObject>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEvent<EventArgsArray & EventArgsObject>>>;

  interface: StdStorageInterface;

  functions: {
    bytesToBytes32(
      b: BytesLike,
      offset: BigNumberish,
      overrides?: CallOverrides
    ): Promise<[string]>;
  };

  bytesToBytes32(
    b: BytesLike,
    offset: BigNumberish,
    overrides?: CallOverrides
  ): Promise<string>;

  callStatic: {
    bytesToBytes32(
      b: BytesLike,
      offset: BigNumberish,
      overrides?: CallOverrides
    ): Promise<string>;
  };

  filters: {
    "SlotFound(address,bytes4,bytes32,uint256)"(
      who?: null,
      fsig?: null,
      keysHash?: null,
      slot?: null
    ): TypedEventFilter<
      [string, string, string, BigNumber],
      { who: string; fsig: string; keysHash: string; slot: BigNumber }
    >;

    SlotFound(
      who?: null,
      fsig?: null,
      keysHash?: null,
      slot?: null
    ): TypedEventFilter<
      [string, string, string, BigNumber],
      { who: string; fsig: string; keysHash: string; slot: BigNumber }
    >;

    "WARNING_UninitedSlot(address,uint256)"(
      who?: null,
      slot?: null
    ): TypedEventFilter<[string, BigNumber], { who: string; slot: BigNumber }>;

    WARNING_UninitedSlot(
      who?: null,
      slot?: null
    ): TypedEventFilter<[string, BigNumber], { who: string; slot: BigNumber }>;
  };

  estimateGas: {
    bytesToBytes32(
      b: BytesLike,
      offset: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    bytesToBytes32(
      b: BytesLike,
      offset: BigNumberish,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;
  };
}