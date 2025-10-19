// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title ABIEncoder
 * @author Alberto Flores
 * @dev Contract to demonstrate abi.encodePacked use in DEFI applications.
 */
contract ABIEncoder {

    //Variables

    string public constant LIMIT_ORDER_NAME = "LIMIT_ORDER_V1";
    string public constant YIELD_POSITION_NAME = "YIELD_POSITION_V1";
    // Events to show codification

    event EncodedData(bytes32 indexed hash, bytes encodedData);
    event PoolIdentifierCreated(bytes32 indexed poolId, address token, uint256 rate);
    event UserPositionEncoded(bytes32 indexed positionId, address user,uint256 amount);

    
    /**
     * @dev Function to create a unique pool identifier using abi.encodePacked.
     * @param tokenA Address of the first token.
     * @param tokenB Address of the second token.
     * @param fee Fee associated with the pool.
     * @return poolId Unique identifier for the pool.
     */
    function createPoolIdentifier(address tokenA, address tokenB, uint256 fee) external pure returns(bytes32 poolId) {

        // Ensure consistent ordering of token addresses
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);

        // Use abi.encodePacked to create a unique pool identifier        
        poolId = keccak256(abi.encodePacked(token0, token1, fee));
         
    }

    /**
     * @dev Function to encode a user's trading position using abi.encodePacked.
     * @param user Address of the user.
     * @param tokenIn Address of the input token.
     * @param tokenOut Address of the output token.
     * @param amountIn Amount of input token.
     * @param minAmountOut Minimum amount of output token.
     * @param deadline Timestamp by which the trade must be executed.
     * @return positionId Unique identifier for the trading position.
     * @return encodedData Encoded data of the trading position.
     */
    function encodeTradingPosition(address user, address tokenIn, address tokenOut, uint256 amountIn, uint256 minAmountOut, uint256 deadline) external pure returns(bytes32 positionId, bytes memory encodedData) {

        // Encode the trading position data using abi.encodePacked
        encodedData = abi.encodePacked(user, tokenIn, tokenOut, amountIn, minAmountOut, deadline);

        // Create a unique identifier for the position
        positionId = keccak256(encodedData);
     
    }

    /**
     * @dev Function to encode swap data for a swap on a decentralized exchange using abi.encodePacked.
     * @param path Array of token addresses representing the swap path.
     * @param amount Array of amount in the swap.
     * @param deadline Timestamp by which the swap must be executed.
     * @return swapData Encoded data 
     */
    function encodeSwapData(address[] calldata path, uint256[] calldata amount, uint256 deadline) external pure returns(bytes memory swapData) {
        
        require(path.length == amount.length, "Path and amount length mismatch");

        // Encode the path using abi.encodePacked
        bytes memory pathData;
        for(uint i = 0; i < path.length; i++) {
            pathData = abi.encodePacked(pathData, path[i]);
        }

        //Encode the amount using abi.encodePacked
        bytes memory amountData;
        for(uint i = 0; i < amount.length; i++) {
            amountData = abi.encodePacked(amountData, amount[i]);
        }

        // Combine all data into swapData
        swapData = abi.encodePacked(pathData, amountData, deadline);
   
    }

    /**
     * @dev Function to encode a limit order using abi.encodePacked.
     * @param maker Address of the order maker.
     * @param taker Address of the order taker.
     * @param tokenIn Address of the input token.
     * @param tokenOut Address of the output token.
     * @param amountIn Amount of input token.
     * @param amountOut Amount of output token.
     * @param nonce Unique nonce for the order.
     * @return orderHash Unique hash for the limit order.
     * @return orderData Encoded data of the limit order.
     */
    function encodeLimitOrder(address maker, address taker, address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut, uint256 nonce) external pure returns(bytes32 orderHash, bytes memory orderData) {
    
        // Encode the limit order data using abi.encodePacked
        orderData = abi.encodePacked(maker, taker, tokenIn, tokenOut, amountIn, amountOut, nonce, LIMIT_ORDER_NAME);
        // Create a unique hash for the order
        orderHash = keccak256(orderData);
    }

    /**
     * @dev Function to encode a yield farming position using abi.encodePacked.
     * @param user Address of the user.
     * @param poolId Identifier of the yield farming pool.
     * @param amount Amount staked in the pool.
     * @param startTime Timestamp when the position was created.
     * @return positionId Unique identifier for the yield farming position.
     */
    function encodeYieldPosition(address user, bytes32 poolId, uint256 amount, uint256 startTime) external pure returns(bytes32 positionId){

        positionId = keccak256(abi.encodePacked(user, poolId, amount, startTime,YIELD_POSITION_NAME));
    }


   

  

}