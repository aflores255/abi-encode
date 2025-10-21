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

    function testCreatePoolIdentifier() external {
        address tokenA = address(0x1);
        address tokenB = address(0x2);
        uint256 fee = 3000;

        bytes32 idAB = encoder.createPoolIdentifier(tokenA, tokenB, fee);
        bytes32 idBA = encoder.createPoolIdentifier(tokenB, tokenA, fee);

        assertEq(idAB, idBA, "Pool identifiers should be the same regardless of token order");
    }

    // Test for different token pairs and fees producing different pool identifiers.

    function testCheckDifferentIdsPoolsIdentifier() public {
        address tokenA = address(0x1);
        address tokenB = address(0x2);
        address tokenC = address(0x3);
        uint256 fee = 3000;
        uint256 fee2 = 500;

        bytes32 idAB = encoder.createPoolIdentifier(tokenA, tokenB, fee);
        bytes32 idAC = encoder.createPoolIdentifier(tokenA, tokenC, fee);
        bytes32 idfees = encoder.createPoolIdentifier(tokenA, tokenB, fee2);

        assertTrue(idAB != idAC, "Pool identifiers for different token pairs should be different");
        assertTrue(idAB != idfees, "Pool identifiers for different fees should be different");
    }

    function testEncodeTradingPositionCorrectly() public {
        address trader = address(0x123);
        address tokenIn = address(0x456);
        address tokenOut = address(0x789);
        uint256 amountIn = 1 ether;
        uint256 amountOut = 2 ether;

        uint256 fixedTimestamp = 1_700_000_000;
        vm.warp(fixedTimestamp);

        (bytes32 positionId, bytes memory encodedData) =
            encoder.encodeTradingPosition(trader, tokenIn, tokenOut, amountIn, amountOut, fixedTimestamp);

        bytes memory expectedData = abi.encodePacked(trader, tokenIn, tokenOut, amountIn, amountOut, fixedTimestamp);

        assertEq(encodedData, expectedData, "Encoded trading position data does not match expected data");
        assertEq(positionId, keccak256(expectedData), "Position ID does not match expected hash");
    }

    // Test that encodeSwapData encodes data correctly

    function testEncodeSwapDataCorrectly() public {
        address[] memory path = new address[](3);
        path[0] = address(0x111);
        path[1] = address(0x222);
        path[2] = address(0x333);

        uint256[] memory amounts = new uint256[](3);
        amounts[0] = 100 ether;
        amounts[1] = 200 ether;
        amounts[2] = 300 ether;

        uint256 deadline = 1_700_000_000;

        bytes memory swapData = encoder.encodeSwapData(path, amounts, deadline);

        // Build expected data manually
        bytes memory expectedPathData = abi.encodePacked(path[0], path[1], path[2]);
        bytes memory expectedAmountData = abi.encodePacked(amounts[0], amounts[1], amounts[2]);
        bytes memory expectedData = abi.encodePacked(expectedPathData, expectedAmountData, deadline);

        assertEq(swapData, expectedData, "Encoded swap data does not match expected data");
    }

    // Test that encodeSwapData reverts when path and amounts length do not match
    function testEncodeSwapDataRevertsOnMismatch() public {
        address[] memory path = new address[](2);
        path[0] = address(0x111);
        path[1] = address(0x222);

        uint256[] memory amounts = new uint256[](3);
        amounts[0] = 100 ether;
        amounts[1] = 200 ether;
        amounts[2] = 300 ether;

        uint256 deadline = 1_700_000_000;

        vm.expectRevert("Path and amount length mismatch");
        encoder.encodeSwapData(path, amounts, deadline);
    }

    // test for encodeLimitOrder function
    function testEncodeLimitOrderCorrectly() public {
        address maker = address(0x111);
        address taker = address(0x222);
        address tokenIn = address(0x333);
        address tokenOut = address(0x444);
        uint256 amountIn = 100 ether;
        uint256 amountOut = 200 ether;
        uint256 nonce = 12345;

        (bytes32 orderHash, bytes memory orderData) =
            encoder.encodeLimitOrder(maker, taker, tokenIn, tokenOut, amountIn, amountOut, nonce);

        bytes memory expectedData =
            abi.encodePacked(maker, taker, tokenIn, tokenOut, amountIn, amountOut, nonce, encoder.LIMIT_ORDER_NAME());

        assertEq(orderData, expectedData, "Encoded limit order data does not match expected data");
        assertEq(orderHash, keccak256(expectedData), "Order hash does not match expected hash");
    }

    // test for encodeYieldPosition function
    function testEncodeYieldPositionCorrectly() public {
        address user = address(0x123);
        bytes32 poolId = keccak256("test_pool");
        uint256 amount = 500 ether;
        uint256 startTime = 1_700_000_000;

        bytes32 positionId = encoder.encodeYieldPosition(user, poolId, amount, startTime);

        bytes32 expectedId = keccak256(abi.encodePacked(user, poolId, amount, startTime, encoder.YIELD_POSITION_NAME()));

        assertEq(positionId, expectedId, "Yield position ID does not match expected ID");
    }

    // test for encodeFlashLoanData function
    function testEncodeFlashLoanDataCorrectly() public {
        address token = address(0x123);
        uint256 amount = 1000 ether;
        bytes memory callbackData = abi.encode("test_callback", 42);

        bytes memory flashLoanData = encoder.encodeFlashLoanData(token, amount, callbackData);

        bytes memory expectedData = abi.encodePacked(token, amount, callbackData, encoder.FLASH_LOAN_NAME());

        assertEq(flashLoanData, expectedData, "Flash loan data does not match expected data");
    }

    // test for encodeStakingPoolConfig function
    function testEncodeStakingPoolConfigCorrectly() public {
        address token = address(0x123);
        uint256 rewardRate = 100;
        uint256 lockPeriod = 86400; // 1 day
        uint256 maxStake = 10000 ether;

        uint256 fixedTimestamp = 1_700_000_000;
        vm.warp(fixedTimestamp);

        bytes memory poolConfig = encoder.encodeStakingPoolConfig(token, rewardRate, lockPeriod, maxStake);

        bytes memory expectedData = abi.encodePacked(token, rewardRate, lockPeriod, maxStake, fixedTimestamp);

        assertEq(poolConfig, expectedData, "Staking pool config does not match expected data");
    }

    // test for createUserMultiPoolHash function
    function testCreateUserMultiPoolHashCorrectly() public view {
        address user = address(0x123);

        bytes32[] memory poolIds = new bytes32[](3);
        poolIds[0] = keccak256("pool1");
        poolIds[1] = keccak256("pool2");
        poolIds[2] = keccak256("pool3");

        bytes32 userPoolHash = encoder.createUserMultiPoolHash(user, poolIds);

        bytes memory expectedCombinedData =
            abi.encodePacked(user, poolIds[0], poolIds[1], poolIds[2], encoder.MULTIPOOL_NAME());
        bytes32 expectedHash = keccak256(expectedCombinedData);

        assertEq(userPoolHash, expectedHash, "User multi-pool hash does not match expected hash");
    }

    // test for encodeYieldStrategy function
    function testEncodeYieldStrategyCorrectly() public view {
        string memory strategyName = "Test Strategy";

        address[] memory pools = new address[](2);
        pools[0] = address(0x111);
        pools[1] = address(0x222);

        uint256[] memory weights = new uint256[](2);
        weights[0] = 60;
        weights[1] = 40;

        bytes memory strategyData = encoder.encodeYieldStrategy(strategyName, pools, weights);

        bytes memory expectedStrategyNameData = abi.encodePacked(strategyName);
        bytes memory expectedPoolsData = abi.encodePacked(pools[0], pools[1]);
        bytes memory expectedWeightsData = abi.encodePacked(weights[0], weights[1]);
        bytes memory expectedData =
            abi.encodePacked(expectedStrategyNameData, expectedPoolsData, expectedWeightsData, encoder.STRATEGY_NAME());

        assertEq(strategyData, expectedData, "Yield strategy data does not match expected data");
    }

    // test that encodeYieldStrategy reverts when pools and weights length do not match

    function testEncodeYieldStrategyRevertsOnMismatch() public {
        string memory strategyName = "Test Strategy";

        address[] memory pools = new address[](2);
        pools[0] = address(0x111);
        pools[1] = address(0x222);

        uint256[] memory weights = new uint256[](3);
        weights[0] = 60;
        weights[1] = 40;
        weights[2] = 50;

        vm.expectRevert("Pools and weights length mismatch");
        encoder.encodeYieldStrategy(strategyName, pools, weights);
    }

    // test for encodeCrossChainBridgeData function
    function testEncodeCrossChainBridgeDataCorrectly() public view {
        uint256 sourceChainId = 1; // Ethereum
        uint256 destinationChainId = 137; // Polygon
        address token = address(0x123);
        uint256 amount = 1000 ether;
        address recipient = address(0x456);

        bytes memory bridgeData =
            encoder.encodeCrossChainBridgeData(sourceChainId, destinationChainId, token, amount, recipient);

        bytes memory expectedData =
            abi.encodePacked(sourceChainId, destinationChainId, token, amount, recipient, encoder.BRIDGE_NAME());

        assertEq(bridgeData, expectedData, "Bridge data does not match expected data");
    }

    // test for createDefiTransactionId function
    function testCreateDefiTransactionIdCorrectly() public view {
        string memory transactionType = "SWAP";
        address user = address(0x123);
        uint256 timestamp = 1_700_000_000;
        uint256 nonce = 12345;

        bytes32 transactionId = encoder.createDefiTransactionId(transactionType, user, timestamp, nonce);

        bytes32 expectedId =
            keccak256(abi.encodePacked(transactionType, user, timestamp, nonce, encoder.DEFI_TX_NAME()));

        assertEq(transactionId, expectedId, "Transaction ID does not match expected ID");
    }

    // test for encodeStopLossOrder function
    function testEncodeStopLossOrderCorrectly() public view {
        address user = address(0x123);
        address token = address(0x456);
        uint256 amount = 100 ether;
        uint256 stopPrice = 2000 ether;
        uint256 triggerPrice = 1900 ether;

        bytes memory stopLossData = encoder.encodeStopLossOrder(user, token, amount, stopPrice, triggerPrice);

        bytes memory expectedData =
            abi.encodePacked(user, token, amount, stopPrice, triggerPrice, encoder.STOP_LOSS_NAME());

        assertEq(stopLossData, expectedData, "Stop loss data does not match expected data");
    }

    // test for encodeTakeProfitOrder function
    function testEncodeTakeProfitOrderCorrectly() public view {
        address user = address(0x123);
        address token = address(0x456);
        uint256 amount = 100 ether;
        uint256 takeProfitPrice = 2500 ether;

        bytes memory takeProfitData = encoder.encodeTakeProfitOrder(user, token, amount, takeProfitPrice);

        bytes memory expectedData = abi.encodePacked(user, token, amount, takeProfitPrice, encoder.TAKE_PROFIT_NAME());

        assertEq(takeProfitData, expectedData, "Take profit data does not match expected data");
    }

    // test for encodeTrailingStopOrder function
    function testEncodeTrailingStopOrderCorrectly() public view {
        address user = address(0x123);
        address token = address(0x456);
        uint256 amount = 100 ether;
        uint256 trailPercentage = 5; // 5%
        uint256 activationPrice = 2000 ether;

        bytes memory trailingStopData =
            encoder.encodeTrailingStopOrder(user, token, amount, trailPercentage, activationPrice);

        bytes memory expectedData =
            abi.encodePacked(user, token, amount, trailPercentage, activationPrice, encoder.TRAILING_STOP_NAME());

        assertEq(trailingStopData, expectedData, "Trailing stop data does not match expected data");
    }
}
