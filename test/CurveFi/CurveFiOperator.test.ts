import { assert } from "chai";
import { ethers } from "hardhat";
const { DAI, DAI_WHALE, USDC, USDC_WHALE, USDT, USDT_WHALE } = require("../ParametersConfig.js");
let daiToken: any, usdcToken: any, usdtToken: any, LPtoken: any, operator: any, admin: any, user1: any;

describe("CurveFinance Pool S.Contract", function () {
  const DAI_INDEX = 0;
  const USDC_INDEX = 1;
  const USDT_INDEX = 2;
  const DECIMALS = 6;//-(Decimals for USDC and USDT. DAI has 18 Decimals).
  const CURVEFI_POOL_ADDRESS = "0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7";
  const LP_TOKEN = "0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490";

  before(async () => {
    admin = await ethers.getImpersonatedSigner(USDC_WHALE);
    user1 = await ethers.getImpersonatedSigner(DAI_WHALE);

    daiToken = await ethers.getContractAt("IERC20", DAI, admin);
    usdcToken = await ethers.getContractAt("IERC20", USDC, admin);
    usdtToken = await ethers.getContractAt("IERC20", USDT, admin);

    LPtoken = await ethers.getContractAt("IERC20", LP_TOKEN, admin);

    let CurveFiOperator = await ethers.getContractFactory("CurveFiOperator");
    operator = await CurveFiOperator.deploy();
  });

  it("CurveFi Pool Adds Liquidity", async () => {
    let user1DAIBalanceBefore = await daiToken.balanceOf(user1.address);
    let user1USDCBalanceBefore = await usdcToken.balanceOf(user1.address);
    let user1USDTBalanceBefore = await usdtToken.balanceOf(user1.address);
    let user1LPTokensBefore = await LPtoken.balanceOf(user1.address);

    console.log(`--- Before Adds Liquidity ---`);
    console.log(`User1 DAI: ${user1DAIBalanceBefore}`);
    console.log(`User1 USDC: ${user1USDCBalanceBefore}`);
    console.log(`User1 USDT: ${user1USDTBalanceBefore}`);
    console.log(`User1 L.P.Tokens: ${user1LPTokensBefore}`);

    await daiToken.connect(user1).approve(operator.address, ethers.utils.parseUnits("90", 18));
    await usdcToken.connect(user1).approve(operator.address, ethers.utils.parseUnits("100", DECIMALS));
    await usdtToken.connect(user1).approve(operator.address, ethers.utils.parseUnits("95", DECIMALS));

    await operator
      .connect(user1)
      .addLiquidity(CURVEFI_POOL_ADDRESS,
      [ethers.utils.parseUnits("90", 18),
      ethers.utils.parseUnits("100", DECIMALS),
      ethers.utils.parseUnits("95", DECIMALS)]);

    let user1DAIBalanceAfter = await daiToken.balanceOf(user1.address);
    let user1USDCBalanceAfter = await usdcToken.balanceOf(user1.address);
    let user1USDTBalanceAfter = await usdtToken.balanceOf(user1.address);
    let user1LPTokensAfter = await LPtoken.balanceOf(user1.address);

    console.log(`--- After Adds Liquidity ---`);
    console.log(`User1 DAI: ${user1DAIBalanceAfter}`);
    console.log(`User1 USDC: ${user1USDCBalanceAfter}`);
    console.log(`User1 USDT: ${user1USDTBalanceAfter}`);
    console.log(`User1 L.P.Tokens: ${user1LPTokensAfter}`);

    /**-User 1 Balances After Adding DAI 90, USDC 100 and USDT 95 of Liquidity
    and Receiving his L.P. Tokens:*/
    assert((user1DAIBalanceAfter).lt(user1DAIBalanceBefore));
    assert((user1USDCBalanceAfter).lt(user1USDCBalanceBefore));
    assert((user1USDTBalanceAfter).lt(user1USDTBalanceBefore));
    assert((user1LPTokensAfter).gt(user1LPTokensBefore));
    /**-NOTE:_ If you Change the BlockNumber "15269796" from the "hardhat.config.ts",
     * the Numbers will Change.*/
  });

  it("CurveFi Pool Removes Liquidity", async () => {
    let user1DAIBalanceBefore = await daiToken.balanceOf(user1.address);
    let user1USDCBalanceBefore = await usdcToken.balanceOf(user1.address);
    let user1USDTBalanceBefore = await usdtToken.balanceOf(user1.address);
    let user1LPTokensBefore = await LPtoken.balanceOf(user1.address);

    console.log(`--- Before Removes Liquidity ---`);
    console.log(`User1 DAI: ${user1DAIBalanceBefore}`);
    console.log(`User1 USDC: ${user1USDCBalanceBefore}`);
    console.log(`User1 USDT: ${user1USDTBalanceBefore}`);
    console.log(`User1 L.P.Tokens: ${user1LPTokensBefore}`);

    await LPtoken.connect(user1).approve(operator.address, user1LPTokensBefore);

    await operator.connect(user1)
    .removeLiquidity(CURVEFI_POOL_ADDRESS);

    let user1DAIBalanceAfter = await daiToken.balanceOf(user1.address);
    let user1USDCBalanceAfter = await usdcToken.balanceOf(user1.address);
    let user1USDTBalanceAfter = await usdtToken.balanceOf(user1.address);
    let user1LPTokensAfter = await LPtoken.balanceOf(user1.address);

    console.log(`--- After Removes Liquidity ---`);
    console.log(`User1 DAI: ${user1DAIBalanceAfter}`);
    console.log(`User1 USDC: ${user1USDCBalanceAfter}`);
    console.log(`User1 USDT: ${user1USDTBalanceAfter}`);
    console.log(`User1 L.P.Tokens: ${user1LPTokensAfter}`);

    /**-User 1 Balances After Removing all his DAI, USDC and USDT Liquidity
    and Burning his 278,913654414532411523 L.P. Tokens:*/
    assert((user1DAIBalanceAfter).gt(user1DAIBalanceBefore));
    assert((user1USDCBalanceAfter).gt(user1USDCBalanceBefore));
    assert((user1USDTBalanceAfter).gt(user1USDTBalanceBefore));
    assert((user1LPTokensAfter).lt(user1LPTokensBefore));
    /**-NOTE:_ If you Change the BlockNumber "15269796" from the "hardhat.config.ts",
     * the Numbers will Change.*/
  });

  it("CurveFi Pool Exchanges Tokens", async () => {
    let user1USDCBalanceBefore = await usdcToken.balanceOf(user1.address);
    let user1USDTBalanceBefore = await usdtToken.balanceOf(user1.address);

    console.log(`--- Before Exchanges ---`);
    console.log(`User1 USDC: ${user1USDCBalanceBefore}`);
    console.log(`User1 USDT: ${user1USDTBalanceBefore}`);

    await usdcToken.connect(user1).approve(operator.address, ethers.utils.parseUnits("1000", DECIMALS));

    await operator.connect(user1)
    .exchangeTokens(
      USDC,
      USDT,
      ethers.utils.parseUnits("1000", DECIMALS)
      );

      let user1USDCBalanceAfter = await usdcToken.balanceOf(user1.address);
      let user1USDTBalanceAfter = await usdtToken.balanceOf(user1.address);

      console.log(`--- After Exchanges ---`);
      console.log(`User1 USDC: ${user1USDCBalanceAfter}`);
      console.log(`User1 USDT: ${user1USDTBalanceAfter}`);

      //-User 1 Balances After Exchanging USDC 1.000 for USDT:
      assert((user1USDCBalanceAfter).lt(user1USDCBalanceBefore));
      assert((user1USDTBalanceAfter).gt(user1USDTBalanceBefore));
      /**-NOTE:_ If you Change the BlockNumber "15269796" from the "hardhat.config.ts",
     * the Numbers will Change.*/
  });
});
