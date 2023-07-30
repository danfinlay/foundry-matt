## MATT Auction

This is a Foundry implementation of a [MATT Auction](https://roamresearch.com/#/app/capabul/page/n9MReVeX0), designed to maximize revenue from auctioning a set of NFTs, while guaranteeing no bidder pays more than any other.

This implementation is extremely simple because it foregoes any bid struct, instead using an ERC-20 allowance _as_ the bid.

So to use properly, the issuer would define the currency they're accepting, and would need to track allowances of that token to their contract for the lifetime of the auction.

To close the auction: The owner calls the `bid` function with the final price, and an array of winners who bid (granted allowances) equal to or higher than that price.

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
