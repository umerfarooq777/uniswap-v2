import { newMockEvent } from "matchstick-as"
import { ethereum, Address, BigInt } from "@graphprotocol/graph-ts"
import {
  Approval,
  LiquidityAdded,
  LiquidityRemoved,
  OwnershipTransferred,
  TokenSwaped,
  Transfer
} from "../generated/TokenContract2/TokenContract2"

export function createApprovalEvent(
  owner: Address,
  spender: Address,
  value: BigInt
): Approval {
  let approvalEvent = changetype<Approval>(newMockEvent())

  approvalEvent.parameters = new Array()

  approvalEvent.parameters.push(
    new ethereum.EventParam("owner", ethereum.Value.fromAddress(owner))
  )
  approvalEvent.parameters.push(
    new ethereum.EventParam("spender", ethereum.Value.fromAddress(spender))
  )
  approvalEvent.parameters.push(
    new ethereum.EventParam("value", ethereum.Value.fromUnsignedBigInt(value))
  )

  return approvalEvent
}

export function createLiquidityAddedEvent(
  _from: Address,
  _mintedLiquidity: BigInt,
  _time: BigInt
): LiquidityAdded {
  let liquidityAddedEvent = changetype<LiquidityAdded>(newMockEvent())

  liquidityAddedEvent.parameters = new Array()

  liquidityAddedEvent.parameters.push(
    new ethereum.EventParam("_from", ethereum.Value.fromAddress(_from))
  )
  liquidityAddedEvent.parameters.push(
    new ethereum.EventParam(
      "_mintedLiquidity",
      ethereum.Value.fromUnsignedBigInt(_mintedLiquidity)
    )
  )
  liquidityAddedEvent.parameters.push(
    new ethereum.EventParam("_time", ethereum.Value.fromUnsignedBigInt(_time))
  )

  return liquidityAddedEvent
}

export function createLiquidityRemovedEvent(
  _from: Address,
  _removedLiquidity: BigInt,
  _time: BigInt
): LiquidityRemoved {
  let liquidityRemovedEvent = changetype<LiquidityRemoved>(newMockEvent())

  liquidityRemovedEvent.parameters = new Array()

  liquidityRemovedEvent.parameters.push(
    new ethereum.EventParam("_from", ethereum.Value.fromAddress(_from))
  )
  liquidityRemovedEvent.parameters.push(
    new ethereum.EventParam(
      "_removedLiquidity",
      ethereum.Value.fromUnsignedBigInt(_removedLiquidity)
    )
  )
  liquidityRemovedEvent.parameters.push(
    new ethereum.EventParam("_time", ethereum.Value.fromUnsignedBigInt(_time))
  )

  return liquidityRemovedEvent
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

export function createTokenSwapedEvent(
  _swaper: Address,
  _tokenRecieved: Address,
  _amountRecieved: BigInt,
  _tokenSent: Address,
  _amountSent: BigInt,
  _time: BigInt
): TokenSwaped {
  let tokenSwapedEvent = changetype<TokenSwaped>(newMockEvent())

  tokenSwapedEvent.parameters = new Array()

  tokenSwapedEvent.parameters.push(
    new ethereum.EventParam("_swaper", ethereum.Value.fromAddress(_swaper))
  )
  tokenSwapedEvent.parameters.push(
    new ethereum.EventParam(
      "_tokenRecieved",
      ethereum.Value.fromAddress(_tokenRecieved)
    )
  )
  tokenSwapedEvent.parameters.push(
    new ethereum.EventParam(
      "_amountRecieved",
      ethereum.Value.fromUnsignedBigInt(_amountRecieved)
    )
  )
  tokenSwapedEvent.parameters.push(
    new ethereum.EventParam(
      "_tokenSent",
      ethereum.Value.fromAddress(_tokenSent)
    )
  )
  tokenSwapedEvent.parameters.push(
    new ethereum.EventParam(
      "_amountSent",
      ethereum.Value.fromUnsignedBigInt(_amountSent)
    )
  )
  tokenSwapedEvent.parameters.push(
    new ethereum.EventParam("_time", ethereum.Value.fromUnsignedBigInt(_time))
  )

  return tokenSwapedEvent
}

export function createTransferEvent(
  from: Address,
  to: Address,
  value: BigInt
): Transfer {
  let transferEvent = changetype<Transfer>(newMockEvent())

  transferEvent.parameters = new Array()

  transferEvent.parameters.push(
    new ethereum.EventParam("from", ethereum.Value.fromAddress(from))
  )
  transferEvent.parameters.push(
    new ethereum.EventParam("to", ethereum.Value.fromAddress(to))
  )
  transferEvent.parameters.push(
    new ethereum.EventParam("value", ethereum.Value.fromUnsignedBigInt(value))
  )

  return transferEvent
}
