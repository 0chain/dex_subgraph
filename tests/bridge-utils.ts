import { newMockEvent } from "matchstick-as"
import { ethereum, Address, BigInt, Bytes } from "@graphprotocol/graph-ts"
import {
  AuthorizersTransferred,
  Burned,
  Minted,
  OwnershipTransferred
} from "../generated/Bridge/Bridge"

export function createAuthorizersTransferredEvent(
  previousAuthorizers: Address,
  newAuthorizers: Address
): AuthorizersTransferred {
  let authorizersTransferredEvent = changetype<AuthorizersTransferred>(
    newMockEvent()
  )

  authorizersTransferredEvent.parameters = new Array()

  authorizersTransferredEvent.parameters.push(
    new ethereum.EventParam(
      "previousAuthorizers",
      ethereum.Value.fromAddress(previousAuthorizers)
    )
  )
  authorizersTransferredEvent.parameters.push(
    new ethereum.EventParam(
      "newAuthorizers",
      ethereum.Value.fromAddress(newAuthorizers)
    )
  )

  return authorizersTransferredEvent
}

export function createBurnedEvent(
  from: Address,
  amount: BigInt,
  clientId: Bytes,
  nonce: BigInt
): Burned {
  let burnedEvent = changetype<Burned>(newMockEvent())

  burnedEvent.parameters = new Array()

  burnedEvent.parameters.push(
    new ethereum.EventParam("from", ethereum.Value.fromAddress(from))
  )
  burnedEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )
  burnedEvent.parameters.push(
    new ethereum.EventParam("clientId", ethereum.Value.fromBytes(clientId))
  )
  burnedEvent.parameters.push(
    new ethereum.EventParam("nonce", ethereum.Value.fromUnsignedBigInt(nonce))
  )

  return burnedEvent
}

export function createMintedEvent(
  to: Address,
  amount: BigInt,
  txid: Bytes,
  nonce: BigInt
): Minted {
  let mintedEvent = changetype<Minted>(newMockEvent())

  mintedEvent.parameters = new Array()

  mintedEvent.parameters.push(
    new ethereum.EventParam("to", ethereum.Value.fromAddress(to))
  )
  mintedEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )
  mintedEvent.parameters.push(
    new ethereum.EventParam("txid", ethereum.Value.fromBytes(txid))
  )
  mintedEvent.parameters.push(
    new ethereum.EventParam("nonce", ethereum.Value.fromUnsignedBigInt(nonce))
  )

  return mintedEvent
}

export function createOwnershipTransferredEvent(
  previousOwner: Address,
  newOwner: Address
): OwnershipTransferred {
  let ownershipTransferredEvent = changetype<OwnershipTransferred>(
    newMockEvent()
  )

  ownershipTransferredEvent.parameters = new Array()

  ownershipTransferredEvent.parameters.push(
    new ethereum.EventParam(
      "previousOwner",
      ethereum.Value.fromAddress(previousOwner)
    )
  )
  ownershipTransferredEvent.parameters.push(
    new ethereum.EventParam("newOwner", ethereum.Value.fromAddress(newOwner))
  )

  return ownershipTransferredEvent
}
