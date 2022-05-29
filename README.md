# Lottery-Contract

---

## Repository setup

### Install

To install the needed packages run:

`yarn` or `npm install`

### Build

To build the smart contracts run:

`yarn build` or `npm run build`

### Test

To run the tests for the smart contracts run:

`yarn test` or `npm run test`

### Test coverage

For the test converge of the contracts run:

`yarn cover` or `npm run cover`

There are multiple mock contracts that have been created for testing purposes. These have been excluded from the coverage. For more information check the [.solcover.js](./.solcover.js).

### Deploy

To deploy the contracts locally run:

`yarn deploy:local` or `npm run deploy:local`

Note that deploying the contracts locally does not require any inputs.

### Design Notes

The `Lottery` and `LotteryNFT` contracts both inherit from a contract called `Testable`. This contract allows for simple time manipulation for testing purposes. For a non-local deployment the address of this contract can simply be set to 0 in the constructor and the contracts will use the current `block.timestamp`.

https://explorer.bitquery.io/bsc_testnet

```cmd

npm install -g --force gatsby-cli
npm init
npm install -g @truffle/hdwallet-provider
npm install -g truffle@5.4.29 --force

npm install dotenv
npm install truffle-hdwallet-provider 

```

## develop
```cmd
truffle develop
compile --reset
migrate --reset

```

## Test net
```cmd
    truffle migrate --reset --network testnet
```

## local test net
```cmd
First, you need to run ```ganache-cli``` in the terminal. (if you doesn't have ganache CLI then firstly install it by running this command ```npm install -g ganache-cli``` ) After this command, you will be able to run ```truffle migrate```.
```

