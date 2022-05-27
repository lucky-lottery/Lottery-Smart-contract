require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');
const { TruffleProvider } = require('@harmony-js/core')
const mnemonic = process.env.MNEMONIC;

module.exports = {
  plugins: ['truffle-plugin-verify'],
  // truffle run verify BEP20Token@{contract-address} --network testnet
  api_keys: {
    etherscan: process.env.ETHERSCAN_API_KEY,
    polygonscan: process.env.POLYGONSCAN_API_KEY,
    bscscan: process.env.BSCSCAN_API_KEY
  },
  /**
   * $ truffle test --network <network-name>
   */
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id
      gas: 5000000
    },
    testnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://data-seed-prebsc-1-s1.binance.org:8545`),
      network_id: 97,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    bsc: {
      provider: () =>{ 
        if (!mnemonic.trim()) {
          throw new Error(
            'Please enter a private key with funds, you can use the default one'
          );
        }
        return new HDWalletProvider(mnemonic, `https://bsc-dataseed1.binance.org`)
      },
      network_id: 56,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    mumbai: {
      provider: () => {
        if (!mnemonic.trim()) {
          throw new Error(
            'Please enter a private key with funds, you can use the default one'
          );
        }
        return new HDWalletProvider(mnemonic, `wss://ws-matic-mumbai.chainstacklabs.com`)
      },
      network_id: 80001,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    polygon: {
      provider: () => {
        if (!mnemonic.trim()) {
          throw new Error(
            'Please enter a private key with funds, you can use the default one'
          );
        }
        return new HDWalletProvider(mnemonic, `wss://ws-matic-mainnet.chainstacklabs.com`)
      },
      network_id: 137,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    harmony: {
      provider: () => {
        if (!mnemonic.trim()) {
          throw new Error(
            'Please enter a private key with funds, you can use the default one'
          );
        }
        return new HDWalletProvider(mnemonic, `https://api.s0.t.hmny.io`)
      },
      gas: 0x7a1200,
      network_id: 1666600000,
      skipDryRun: true
    }
  },

  // Set default mocha options here, use special reporters, etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.1",    // Fetch exact version from solc-bin (default: truffle's version)
      docker: false,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
       optimizer: {
         enabled: true,
         runs: 800
       }
      }
    }
  },
};
