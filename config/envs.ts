require("dotenv").config();

const envConfig = {
    crypto: {
        ALCHEMY_KEY: process.env.ALCHEMY_KEY || "",
        ETHERSCAN_KEY: process.env.ETHERSCAN_KEY || "",
        PRIVATE_KEY: process.env.PRIVATE_KEY || "",
    },
}

export { envConfig };
