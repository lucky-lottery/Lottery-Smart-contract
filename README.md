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

