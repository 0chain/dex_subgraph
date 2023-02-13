import {
  assert,
  describe,
  test,
  clearStore,
  beforeAll,
  afterAll
} from "matchstick-as/assembly/index"
import { Address, BigInt, Bytes } from "@graphprotocol/graph-ts"
import { AuthorizersTransferred } from "../generated/schema"
import { AuthorizersTransferred as AuthorizersTransferredEvent } from "../generated/Bridge/Bridge"
import { handleAuthorizersTransferred } from "../src/bridge"
import { createAuthorizersTransferredEvent } from "./bridge-utils"

// Tests structure (matchstick-as >=0.5.0)
// https://thegraph.com/docs/en/developer/matchstick/#tests-structure-0-5-0

describe("Describe entity assertions", () => {
  beforeAll(() => {
    let previousAuthorizers = Address.fromString(
      "0x0000000000000000000000000000000000000001"
    )
    let newAuthorizers = Address.fromString(
      "0x0000000000000000000000000000000000000001"
    )
    let newAuthorizersTransferredEvent = createAuthorizersTransferredEvent(
      previousAuthorizers,
      newAuthorizers
    )
    handleAuthorizersTransferred(newAuthorizersTransferredEvent)
  })

  afterAll(() => {
    clearStore()
  })

  // For more test scenarios, see:
  // https://thegraph.com/docs/en/developer/matchstick/#write-a-unit-test

  test("AuthorizersTransferred created and stored", () => {
    assert.entityCount("AuthorizersTransferred", 1)

    // 0xa16081f360e3847006db660bae1c6d1b2e17ec2a is the default address used in newMockEvent() function
    assert.fieldEquals(
      "AuthorizersTransferred",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "previousAuthorizers",
      "0x0000000000000000000000000000000000000001"
    )
    assert.fieldEquals(
      "AuthorizersTransferred",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "newAuthorizers",
      "0x0000000000000000000000000000000000000001"
    )

    // More assert options:
    // https://thegraph.com/docs/en/developer/matchstick/#asserts
  })
})
