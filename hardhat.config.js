require("@nomiclabs/hardhat-waffle");
require('hardhat-abi-exporter');
require('dotenv').config({ path: __dirname + '/.env' })
require("@nomiclabs/hardhat-etherscan");
require('hardhat-contract-sizer');

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */


module.exports = {
    solidity: {
        compilers: [
            {
                version: "0.8.20",
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 100,
                    },
                },
            },
            {

                version: "0.8.19",
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 100,
                    },
                },
            },

            {
                version: "0.8.17",
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 100,
                    },
                },
            },
            {

                version: "0.7.6",
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 100,
                    },
                },
            },]
    },
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            chainId: 1337,
            gasPrice: 225000000000,
            forking: {
                // url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_API_MAINNET}`, //eth
                //  url: `https://arb-mainnet.g.alchemy.com/v2/${process.env.ALCHEMY_API_ARBI_MAINNET}`, //arbitrum
                url: `https://eth-goerli.g.alchemy.com/v2/${process.env.ALCHEMY_API_GOERLI}`, //goerli
                //   url: `https://bsc-dataseed1.binance.org/`, //bsc testnet 
                // url : "https://wiser-wider-valley.bsc.discover.quiknode.pro/050ea5d25ccade9d764fac15bd4709b810d543a1/" //bsc
            },
        },
        goerli: {
            url: `https://eth-goerli.g.alchemy.com/v2/${process.env.ALCHEMY_API_GOERLI}`,
            accounts: [`0x${process.env.PRIVATE_KEY}`],
        },
        testnet: {
            url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
            chainId: 97,
            gasPrice: 21000000000,
            accounts: [`0x${process.env.PRIVATE_KEY}`],
        },
        mainnet: {
            url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_API_MAINNET}`,
            accounts: [`0x${process.env.PRIVATE_KEY}`],
        },
        arbigoerli: {
            url: `https://arb-goerli.g.alchemy.com/v2/${process.env.ALCHEMY_API_ARBI_GOERLI}`,
            accounts: [`0x${process.env.PRIVATE_KEY}`],
        },
        arbitrum: {
            url: `https://arb-mainnet.g.alchemy.com/v2/${process.env.ALCHEMY_API_ARBI_MAINNET}`,
            accounts: [`0x${process.env.PRIVATE_KEY}`],
        },
    },
    contractSizer: {
        alphaSort: true,
        disambiguatePaths: false,
        runOnCompile: true,
        strict: true,
        only: [':Staking$', ':HESTOKEN$'],
    },
    etherscan: {
        // Your API key for Etherscan
        apiKey: `${process.env.ETHERSCAN_API_KEY}`,
        // Your API key for Arbiscan
        // apiKey: `${process.env.ARBISCAN_API_KEY}`
    },
    mocha: {
        timeout: 1000000
    }
};