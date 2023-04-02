import {
  AuthorizersTransferred as AuthorizersTransferredEvent,
  Burned as BurnedEvent,
  Minted as MintedEvent,
  OwnershipTransferred as OwnershipTransferredEvent
} from "../generated/0chain/dex/Bridge"
import {
  AuthorizersTransferred,
  Burned,
  Minted,
  OwnershipTransferred
} from "../generated/schema"

export function handleAuthorizersTransferred(
  event: AuthorizersTransferredEvent
): void {
  let entity = new AuthorizersTransferred(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.previousAuthorizers = event.params.previousAuthorizers
  entity.newAuthorizers = event.params.newAuthorizers

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleBurned(event: BurnedEvent): void {
  let entity = new Burned(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.from = event.params.from
  entity.amount = event.params.amount
  entity.clientId = event.params.clientId
  entity.nonce = event.params.nonce

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleMinted(event: MintedEvent): void {
  let entity = new Minted(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.to = event.params.to
  entity.amount = event.params.amount
  entity.txid = event.params.txid
  entity.nonce = event.params.nonce

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleOwnershipTransferred(
  event: OwnershipTransferredEvent
): void {
  let entity = new OwnershipTransferred(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.previousOwner = event.params.previousOwner
  entity.newOwner = event.params.newOwner

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
