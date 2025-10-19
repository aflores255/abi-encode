// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/ABIEncoder.sol";

/*
 * @title ABIEncoderTest
 * @notice Test contract for ABIEncoder functionalities.
 */

contract ABIEncoderTest is Test {
    ABIEncoder encoder;

    // Setup function to initialize the ABIEncoder instance
    function setUp() public {
        encoder = new ABIEncoder();
    }

    // Invariant tests

    // Test for createPoolIdentifier function. Order of parameters matters.

    function testCreatePoolIdentifier() public view {

        address tokenA = address(0x1);
        address tokenB = address(0x2);
        uint256 fee = 3000;

        bytes32 idAB = encoder.createPoolIdentifier(tokenA, tokenB, fee);
        bytes32 idBA = encoder.createPoolIdentifier(tokenB, tokenA, fee);

        assertEq(idAB, idBA, "Pool identifiers should be the same regardless of token order");
    }
}