import { ethers } from "hardhat";
import { TestToken__factory } from "../typechain/factories/TestToken__factory";
import { TestToken } from "../typechain";

async function main(): Promise<void> {

    // deployer
    const [ deployer ] = await ethers.getSigners();

    // factory
    const tokenFactory: TestToken__factory = new TestToken__factory(deployer);

    // token
    const testToken: TestToken = await tokenFactory.deploy();

    // print
    console.log(`TestToken deployed to: ${testToken.address}`);

}

main()
    .then(() => process.exit(0))
    .catch((error: Error) => {
        console.error(error);
        process.exit(1);
    });
