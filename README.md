# 🔐 ABI Encoder - Comprehensive DeFi Data Encoding Library for Solidity Smart Contracts

## 📌 Description

**ABI Encoder** is a comprehensive Solidity smart contract that demonstrates the use of **abi.encodePacked** in various **DeFi applications**. The contract provides a collection of encoding functions for different DeFi operations including pool identifiers, trading positions, limit orders, yield farming, flash loans, and much more.

Built with **Solidity 0.8.28**, this contract serves as an educational and practical tool for understanding efficient data encoding patterns in decentralized finance protocols.

---

## 🧩 Features

| **Feature**                    | **Description**                                                                 |
|--------------------------------|---------------------------------------------------------------------------------|
| 🏊 **Pool Identifiers**        | Create unique identifiers for liquidity pools with consistent token ordering.  |
| 📊 **Trading Positions**       | Encode user trading positions with token pairs and amounts.                    |
| 📈 **Swap Data Encoding**      | Efficiently encode swap paths and amounts for DEX operations.                  |
| 📋 **Limit Orders**            | Create structured limit order data with maker/taker information.               |
| 🌾 **Yield Farming**           | Encode yield farming positions and strategies.                                 |
| ⚡ **Flash Loans**             | Structure flash loan data with callback information.                           |
| 🌉 **Cross-Chain Bridges**     | Encode bridge operations between different blockchains.                        |
| 🛡️ **Stop Loss/Take Profit**   | Create advanced order types for risk management.                              |
| 🧪 **Foundry Test Suite**      | Complete test coverage for all encoding functions.                            |

---

## 📜 Contract Details

### 🏷️ Constants

The contract defines several version constants for different DeFi operations:

```solidity
string public constant LIMIT_ORDER_NAME = "LIMIT_ORDER_V1";
string public constant YIELD_POSITION_NAME = "YIELD_POSITION_V1";
string public constant FLASH_LOAN_NAME = "FLASH_LOAN_V1";
string public constant MULTIPOOL_NAME = "USER_MULTI_POOL_V1";
string public constant STRATEGY_NAME = "YIELD_STRATEGY_V1";
string public constant BRIDGE_NAME = "CROSS_CHAIN_BRIDGE_V1";
string public constant DEFI_TX_NAME = "DEFI_TRANSACTION_V1";
string public constant STOP_LOSS_NAME = "STOP_LOSS_ORDER_V1";
string public constant TAKE_PROFIT_NAME = "TAKE_PROFIT_ORDER_V1";
string public constant TRAILING_STOP_NAME = "TRAILING_STOP_ORDER_V1";
```

---

### 🔧 Functions

| **Function**                    | **Description**                                                              |
|---------------------------------|------------------------------------------------------------------------------|
| `createPoolIdentifier()`        | Creates unique pool identifiers with consistent token ordering.             |
| `encodeTradingPosition()`       | Encodes trading positions with user, tokens, amounts, and deadline.         |
| `encodeSwapData()`              | Encodes swap paths and amounts for DEX operations.                          |
| `encodeLimitOrder()`            | Creates structured limit order data with all necessary parameters.          |
| `encodeYieldPosition()`         | Encodes yield farming positions with pool and staking information.          |
| `encodeFlashLoanData()`         | Structures flash loan data with token, amount, and callback.               |
| `encodeStakingPoolConfig()`     | Encodes staking pool configurations with rates and lock periods.            |
| `createUserMultiPoolHash()`     | Creates hashes for users participating in multiple pools.                   |
| `encodeYieldStrategy()`         | Encodes yield strategies with pool weights and allocations.                 |
| `encodeCrossChainBridgeData()`  | Structures cross-chain bridge operations.                                   |
| `createDefiTransactionId()`     | Generates unique IDs for DeFi transactions.                                |
| `encodeStopLossOrder()`         | Encodes stop-loss orders with trigger prices.                              |
| `encodeTakeProfitOrder()`       | Encodes take-profit orders for automated selling.                          |
| `encodeTrailingStopOrder()`     | Encodes trailing stop orders with percentage-based triggers.               |

---

### 📡 Events

| **Event**                | **Description**                                    |
|--------------------------|----------------------------------------------------|
| `EncodedData`            | Emitted when data is successfully encoded.        |
| `PoolIdentifierCreated`  | Emitted when a new pool identifier is created.    |
| `UserPositionEncoded`    | Emitted when a user position is encoded.          |

---

### 🔐 Key Features & Validations

- **Consistent Token Ordering**: Pool identifiers ensure tokens are ordered consistently regardless of input order.
- **Array Length Validation**: Functions with multiple arrays validate matching lengths to prevent data corruption.
- **Efficient Encoding**: Uses `abi.encodePacked` for gas-efficient, compact data encoding.
- **Unique Identifiers**: Generates unique hashes using keccak256 for position and order identification.
- **Version Control**: Each operation type includes version strings for future compatibility.

---

## 🧪 Testing with Foundry

All functions are comprehensively tested with **Foundry**, covering both successful operations and edge cases.

### ✅ Implemented Tests

| **Test**                                    | **Description**                                       |
|---------------------------------------------|-------------------------------------------------------|
| `testCreatePoolIdentifier`                  | Verifies consistent pool identifier creation.        |
| `testCheckDifferentIdsPoolsIdentifier`      | Ensures different pools have different identifiers.  |
| `testEncodeTradingPositionCorrectly`        | Tests trading position encoding accuracy.            |
| `testEncodeSwapDataCorrectly`               | Validates swap data encoding with paths and amounts. |
| `testEncodeSwapDataRevertsOnMismatch`       | Ensures revert on mismatched array lengths.         |
| `testEncodeLimitOrderCorrectly`             | Tests limit order data structure creation.           |
| `testEncodeYieldPositionCorrectly`          | Validates yield position identifier generation.      |
| `testEncodeFlashLoanDataCorrectly`          | Tests flash loan data encoding with callbacks.       |
| `testEncodeStakingPoolConfigCorrectly`      | Validates staking pool configuration encoding.       |
| `testCreateUserMultiPoolHashCorrectly`      | Tests multi-pool user hash generation.              |
| `testEncodeYieldStrategyCorrectly`          | Validates yield strategy encoding with weights.      |
| `testEncodeYieldStrategyRevertsOnMismatch`  | Ensures revert on pool/weight array mismatch.       |
| `testEncodeCrossChainBridgeDataCorrectly`   | Tests cross-chain bridge data structure.            |
| `testCreateDefiTransactionIdCorrectly`      | Validates DeFi transaction ID generation.            |
| `testEncodeStopLossOrderCorrectly`          | Tests stop-loss order encoding.                      |
| `testEncodeTakeProfitOrderCorrectly`        | Validates take-profit order structure.               |
| `testEncodeTrailingStopOrderCorrectly`      | Tests trailing stop order encoding.                  |

---

## 🔗 Dependencies

- [Foundry](https://book.getfoundry.sh/) - Development framework and testing
- [Forge Std](https://github.com/foundry-rs/forge-std) - Standard library for Foundry tests

---

## 🛠️ How to Use

### 🔧 Prerequisites

- Install [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Basic understanding of Solidity and DeFi concepts

---

### 🧪 Run Tests

```bash
# Run all tests
forge test

# Run tests with verbose output
forge test -v

# Run specific test
forge test --match-test testCreatePoolIdentifier

# Check test coverage
forge coverage
```

### 📊 Test Coverage

The project achieves **100% test coverage** across all metrics:

| **File**           | **% Lines**         | **% Statements**    | **% Branches**    | **% Funcs**         |
|--------------------|---------------------|---------------------|-------------------|---------------------|
| src/ABIEncoder.sol | 100.00% (59/59)     | 100.00% (60/60)     | 100.00% (4/4)     | 100.00% (14/14)     |
| **Total**          | **100.00% (59/59)** | **100.00% (60/60)** | **100.00% (4/4)** | **100.00% (14/14)** |

This comprehensive coverage ensures all functions, branches, and edge cases are thoroughly tested, providing confidence in the contract's reliability and security.

---

### 🚀 Deployment

1. Clone the repository:

```bash
git clone https://github.com/aflores255/abi-encode.git
cd abi-encode
```

2. Install dependencies:

```bash
forge install
```

3. Deploy the contract:

```bash
forge create src/ABIEncoder.sol:ABIEncoder --private-key YOUR_PRIVATE_KEY
```

---

### 💡 Usage Examples

#### Creating a Pool Identifier

```solidity
ABIEncoder encoder = new ABIEncoder();
bytes32 poolId = encoder.createPoolIdentifier(
    0x1234567890123456789012345678901234567890, // tokenA
    0x0987654321098765432109876543210987654321, // tokenB
    3000 // fee (0.3%)
);
```

#### Encoding a Trading Position

```solidity
(bytes32 positionId, bytes memory encodedData) = encoder.encodeTradingPosition(
    msg.sender,           // user
    tokenIn,             // input token
    tokenOut,            // output token
    1 ether,             // amount in
    0.95 ether,          // minimum amount out
    block.timestamp + 3600 // deadline (1 hour)
);
```

#### Creating a Limit Order

```solidity
(bytes32 orderHash, bytes memory orderData) = encoder.encodeLimitOrder(
    maker,               // order maker
    address(0),          // taker (0 for any)
    tokenIn,             // input token
    tokenOut,            // output token
    100 ether,           // amount in
    200 ether,           // amount out
    nonce                // unique nonce
);
```

---

## 📄 License

This project is licensed under the **MIT License**.