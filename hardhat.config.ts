// Get the environment configuration from .env file
//
// To make use of automatic environment setup:
// - Duplicate .env.example file and name it .env
// - Fill in the environment variables
import 'dotenv/config'
import "@nomicfoundation/hardhat-ignition-ethers"
import { HttpNetworkAccountsUserConfig } from 'hardhat/types'
import "@nomicfoundation/hardhat-verify";

// Set your preferred authentication method
//
// If you prefer using a mnemonic, set a MNEMONIC environment variable
// to a valid mnemonic
const MNEMONIC = process.env.MNEMONIC

// If you prefer to be authenticated using a private key, set a PRIVATE_KEY environment variable
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const BASESCAN_KEY = process.env.BASESCAN_KEY;
const ETHERSCAN_KEY = process.env.ETHERSCAN_KEY;
const LINEASCAN_KEY = process.env.LINEASCAN_KEY;

const accounts: HttpNetworkAccountsUserConfig | undefined = MNEMONIC
    ? { mnemonic: MNEMONIC }
    : PRIVATE_KEY
      ? [PRIVATE_KEY]
      : undefined

if (accounts == null) {
    console.warn(
        'Could not find MNEMONIC or PRIVATE_KEY environment variables. It will not be possible to execute transactions in your example.'
    )
}

const config = {
    solidity: {
        compilers: [
            {
                version: '0.8.24',
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 200,
                    },
                },
            },
        ],
    },
    networks: {
        sepolia: {
            url: process.env.RPC_URL_SEPOLIA || 'https://rpc.sepolia.org/',
            accounts,
        },
        linea_testnet: {
            url: process.env.RPC_URL_LINEA_SEPOLIA || 'https://59141.rpc.thirdweb.com',
            accounts,
        },
        base_testnet: {
            url: process.env.RPC_URL_BASE_SEPOLIA || 'https://sepolia.base.org',
            accounts,
        },
        fuji: {
            url: process.env.RPC_URL_FUJI || 'https://rpc.ankr.com/avalanche_fuji',
            accounts,
        },
        ethereum: {
            url: process.env.RPC_URL_ETHEREUM || 'https://rpc.ankr.com/eth',
            accounts,
        },
        linea: {
            url: process.env.RPC_URL_LINEA || 'https://1rpc.io/linea',
            accounts
        }
    },
    namedAccounts: {
        deployer: {
            default: 0, // wallet address of index[0], of the mnemonic in .env
        },
    },
    etherscan: {
        apiKey: {
            sepolia: ETHERSCAN_KEY,
            linea_testnet: LINEASCAN_KEY,
            base_testnet: BASESCAN_KEY,
            ethereum: ETHERSCAN_KEY,
            mainnet: ETHERSCAN_KEY,
            linea: LINEASCAN_KEY
        },
        customChains: [
            {
              network: "linea_testnet",
              chainId: 59141,
              urls: {
                apiURL: "https://api-sepolia.lineascan.build/api",
                browserURL: "https://sepolia.lineascan.build/"
              }
            },
            {
                network: "linea",
                chainId: 59144,
                urls: {
                    apiURL: "https://api.lineascan.build/api",
                    browserURL: "https://lineascan.build/"
                }
            }
          ]
    },
    sourcify: {
        enabled: false
    }
}

export default config
