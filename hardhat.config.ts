import { HardhatUserConfig, NetworkUserConfig } from "hardhat/types";
import "@typechain/hardhat";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
require("dotenv").config();

import "hardhat-abi-exporter";
import "hardhat-contract-sizer";
import "hardhat-gas-reporter";
import "hardhat-spdx-license-identifier";

import { envConfig } from "./config/envs";
import { chainIds } from "./config/networks";


function createEthereumNetworkConfig(network: keyof typeof chainIds): NetworkUserConfig {
    const url: string = `https://eth-${network}.alchemyapi.io/v2/${envConfig.crypto.ALCHEMY_KEY}`;
    let networkConfig: NetworkUserConfig = {
        chainId: chainIds[network],
        url,
    };
    const pk: string = envConfig.crypto.PRIVATE_KEY;
    if (pk != "") {
        networkConfig.accounts = [pk];
    }
    return networkConfig;
}

const hardhatConfig: HardhatUserConfig = {
    defaultNetwork: "localhost",
    networks: {
        hardhat: {
            chainId: chainIds.hardhat,
            forking: {
                url: `https://eth-mainnet.alchemyapi.io/v2/${envConfig.crypto.ALCHEMY_KEY}`,
                blockNumber:
                15269796,
            },
        },
        localhost: {
            // used for local deployment
            url: "http://localhost:8545",
        },
        mainnet: createEthereumNetworkConfig("mainnet"),
        goerli: createEthereumNetworkConfig("goerli"),
        kovan: createEthereumNetworkConfig("kovan"),
        rinkeby: createEthereumNetworkConfig("rinkeby"),
        ropsten: createEthereumNetworkConfig("ropsten"),
    },
    solidity: {
        compilers: [
            {
                version: '0.5.12',
            },
            {
                version: '0.8.0',
            },
            {
                version: '0.8.4',
            },
            {
                version: '0.8.9',
            },
            {
                version: '^0.8.12',
            },
        ],
        settings: {
            outputSelection: {
                "*": {
                "*": ["storageLayout"]
                }
            }
        },
    },
    etherscan: {
        apiKey: envConfig.crypto.ETHERSCAN_KEY,
    },
    gasReporter: {
        enabled: true,
        showMethodSig: true,
        showTimeSpent: true,
    },
    abiExporter: {
        path: "./abis",
        runOnCompile: true,
        clear: true,
        flat: true,
        spacing: 2,
    },
    contractSizer: {
        alphaSort: true,
        runOnCompile: true,
        disambiguatePaths: false,
    },
    typechain: {
        outDir: "typechain",
        target: "ethers-v5",
    },
};

export default hardhatConfig;
