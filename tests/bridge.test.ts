import {
  assert,
  describe,
  test,
  clearStore,
  beforeAll,
  afterAll
} from "matchstick-as/assembly/index"
import { Address, BigInt, Bytes } from "@graphprotocol/graph-ts"
import {Burned} from "../generated/schema"

describe("Describe entity assertions", () => {
  beforeAll(() => { 
    let burned = new Burned(Bytes.fromI32(1))
    burned.from = Address.fromString(
      "0x0000000000000000000000000000000000000001"
    )
    burned.amount = BigInt.fromI64(1)
    burned.clientId = Bytes.fromHexString("0x0000000000000000000000000000000000000001")
    burned.nonce = BigInt.fromI64(1)

    burned.blockNumber = BigInt.fromI64(1)
    burned.blockTimestamp = BigInt.fromI64(1)
    burned.transactionHash = Bytes.fromHexString("0x0000000000000000000000000000000000000001")

    burned.save()
  })

  afterAll(() => {
    clearStore()
  })

  test("Burned created and stored", () => {
    assert.entityCount('Burned', 1)
    
    let mainAccount = Burned.load(Bytes.fromI32(1))!

    assert.bytesEquals(mainAccount.from, Bytes.fromHexString("0x0000000000000000000000000000000000000001"))
    assert.bigIntEquals(mainAccount.amount, BigInt.fromI64(1))
    assert.bytesEquals(mainAccount.clientId, Bytes.fromHexString("0x0000000000000000000000000000000000000001"))
    assert.bigIntEquals(mainAccount.nonce, BigInt.fromI64(1))
  })
})
