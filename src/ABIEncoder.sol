// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title ABIEncoder
 * @author Alberto Flores
 * @dev Contract to demonstrate abi.encodePacked use in DEFI applications.
 */
contract ABIEncoder {

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
    function createPoolIdentifier(address tokenA, address tokenB, uint256 fee) external pure (bytes32 poolId) {

        // Ensure consistent ordering of token addresses
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);

        // Use abi.encodePacked to create a unique pool identifier        
        poolId = keccak256(abi.encodePacked(token0, token1, fee));
        
        
    }


   

  

}