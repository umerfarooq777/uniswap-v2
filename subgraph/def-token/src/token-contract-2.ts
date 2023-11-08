import {
  Approval as ApprovalEvent,
  LiquidityAdded as LiquidityAddedEvent,
  LiquidityRemoved as LiquidityRemovedEvent,
  OwnershipTransferred as OwnershipTransferredEvent,
  TokenSwaped as TokenSwapedEvent,
  Transfer as TransferEvent
} from "../generated/TokenContract2/TokenContract2"
import {
  Approval,
  LiquidityAdded,
  LiquidityRemoved,
  OwnershipTransferred,
  TokenSwaped,
  Transfer
} from "../generated/schema"

export function handleApproval(event: ApprovalEvent): void {
  let entity = new Approval(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.owner = event.params.owner
  entity.spender = event.params.spender
  entity.value = event.params.value

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleLiquidityAdded(event: LiquidityAddedEvent): void {
  let entity = new LiquidityAdded(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._from = event.params._from
  entity._mintedLiquidity = event.params._mintedLiquidity
  entity._time = event.params._time

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleLiquidityRemoved(event: LiquidityRemovedEvent): void {
  let entity = new LiquidityRemoved(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._from = event.params._from
  entity._removedLiquidity = event.params._removedLiquidity
  entity._time = event.params._time

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

export function handleTokenSwaped(event: TokenSwapedEvent): void {
  let entity = new TokenSwaped(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._swaper = event.params._swaper
  entity._tokenRecieved = event.params._tokenRecieved
  entity._amountRecieved = event.params._amountRecieved
  entity._tokenSent = event.params._tokenSent
  entity._amountSent = event.params._amountSent
  entity._time = event.params._time

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleTransfer(event: TransferEvent): void {
  let entity = new Transfer(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.from = event.params.from
  entity.to = event.params.to
  entity.value = event.params.value

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
