# MultiTransfer EVM Contract

## Introduction

```txt
Introducción

🇲🇽 El contrato MultiTransfer está diseñado para facilitar la distribución eficiente y segura de tokens ERC20 y Ether nativo (ETH) a múltiples destinatarios. Este contrato inteligente actúa como un proxy, permitiendo a los usuarios enviar tokens o ETH a una lista de direcciones en una sola transacción, en lugar de ejecutar múltiples transacciones independientes. El enfoque principal de MultiTransfer es garantizar la seguridad y protección de las transferencias, convirtiéndolo en una herramienta confiable para la distribución en lote de activos digitales.
```

The MultiTransfer contract is designed to facilitate the efficient and secure distribution of ERC20 tokens and native Ether (ETH) to multiple recipients. This smart contract acts as a proxy, enabling users to send tokens or ETH to a list of addresses in a single transaction, rather than executing multiple independent transactions. The primary focus of MultiTransfer is to ensure the safety and security of transfers, making it a reliable tool for batch distribution of digital assets.

## Features

```txt
Características

- Transferencia en Lote de Tokens ERC20: Envía tokens ERC20 a múltiples direcciones en una sola transacción.
- Transferencia en Lote de Ether: Distribuye Ether nativo a una lista de destinatarios de manera fluida.
- Seguridad Primero: Implementa rigurosas verificaciones de seguridad para asegurar transacciones exitosas y seguras.
```

- Batch Transfer of ERC20 Tokens: Send ERC20 tokens to multiple addresses in one transaction.
- Batch Transfer of Ether: Distribute native Ether to a list of recipients seamlessly.
- Security First: Implements robust security checks to ensure safe and successful transactions.

## Prerequisites

Before you begin, ensure that you have the following installed:

- Rust: The programming language used for Foundry tooling.
- Foundry: A development environment and testing framework for Ethereum smart contract development.

## Installation

Clone the Repository:

```bash
git clone https://github.com/josemariasosa/erc20-multi-trasfer
cd erc20-multi-trasfer
```

Install Dependencies:

```bash
forge install
```

## Compilation

Compile the MultiTransfer contract using Foundry's forge command:

```bash
forge compile
```

This command compiles the smart contract and checks for any compilation errors.

## Testing

Run tests to ensure the contract functions as expected:

```bash
forge test
```

Testing is crucial as it validates the functionality and security of the contract before deployment.

## Usage

The contract is deployed in the following networks addresses:
- q testnet https://explorer.qtestnet.org/address/0x11adbe0E9Ca21DBA3068381E750d93BAc92323aD
- q mainnet https://explorer.q.org/address/0x23B4904924cFF879DE6d084B8AA3b40F09A7A150


## Contributions

Contributions to the MultiTransfer contract are welcome. Please ensure that any pull requests or issues adhere to security best practices and improve the efficiency and safety of the contract.

## License

This project is licensed under [specify license], making it open for use and modification within the terms of the license.
