require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("hardhat-gas-reporter");
require("solidity-coverage");
require("dotenv").config();

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: "bsctestnet",
  networks: {
    bsctestnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      chainId: 97,
      gasPrice: 20000000000,
      accounts: [process.env.MNEMONIC],
    },
    bscmainnet: {
      url: "https://bsc-dataseed.binance.org/",
      chainId: 56,
      gasPrice: 20000000000,
      accounts: [process.env.MNEMONIC],
    },

  },
  etherscan: {
    apiKey: process.env.BSCSCAN_API_KEY,
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 20000
  },
  solidity: {
    compilers: [
      {
        version: "0.6.0",
        settings: {
          optimizer: {
              enabled: true,
              runs: 800,
            },
        }
      },
      {
        version: "0.6.6",
        settings: {
          optimizer: {
              enabled: true,
              runs: 800,
            },
        }
      },
      {
        version: "0.8.3",
        settings: {
          optimizer: {
              enabled: true,
              runs: 800,
            },
        }
      }
    ]
  }
};
