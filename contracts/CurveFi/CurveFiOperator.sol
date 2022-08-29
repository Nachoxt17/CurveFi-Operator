// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import { ICurveFiPool } from "./ICurveFiPool.sol";
import { IERC20Modified } from "../IERC20Modified.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Curve Finance Pool Operator Example.
/// @author Ignacio Ceaglio for 10Clouds.

/*
 * @notice Curve Finance Allows you to Exchange Similar Value Tokens with Minimum Loss, differently from
 * other De.Fi. Protocols in which the Difference of Value between two USD Stablecoins can be considerable.
 */

/*
 * - CurveFi Pool Smart Contract Address: 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7
 * - Underlaying Tokens Available in the CurveFiYPool(https://etherscan.io/address/0xbebc44782c7db0a1a60cb6fe97d0b483032ff1c7#readContract#F8):
 * Index 0: DAI - 0x6B175474E89094C44Da98b954EedeAC495271d0F
 * Index 1: USDC - 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
 * Index 2: USDT - 0xdAC17F958D2ee523a2206206994597C13D831ec7
 * Liquidity Pool Token: 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490
 */

/*
 * - List of NOT KILLED CurveFi Pools as of 8/12/2022:
 *
 * - Standard 1. Function Parameters:
 * coins(uint256 index).
 * add_liquidity(uint256[3] memory amounts, uint256 min_mint_amount).
 * remove_liquidity(uint256 _amount, uint256[3] calldata min_amounts).
 * exchange(int128 i, int128 j, uint256 dx, uint256 min_dy).
 * - List:
 * 3Pool for DAI/USDC/USDT: 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7
 * AAVE: 0xDeBF20617708857ebe4F679508E7b7863a8A8EeE
 * IronBank: 0x2dded6Da1BF5DBdF597C45fcFaa3194e53EcfeAF
 *
 *
 *
 * - Standard 2. Function Parameters:
 * coins(uint256 index).
 * add_liquidity(uint256[2] memory amounts, uint256 min_mint_amount).
 * remove_liquidity(uint256 _amount, uint256[2] calldata min_amounts).
 * exchange(int128 i, int128 j, uint256 dx, uint256 min_dy).
 * - List:
 * EURS: 0x0Ce6a5fF5217e38315f87032CF90686C96627CAA
 * hBTC/wBTC: 0x4CA9b3063Ec5866A4B82E437059D2C43d1be596F
 * Link: 0xF178C0b5Bb7e7aBF4e12A4838C7b7c5bA2C623c0
 * sAAVE: 0xEB16Ae0052ed37f479f7fe63849198Df1765a733
 *
 *
 *
 * - Standard 3. Function Parameters:
 * coins(uint256 index).
 * add_liquidity({payableAmount (ether)} uint256[2] memory amounts, uint256 min_mint_amount).
 * remove_liquidity(uint256 _amount, uint256[2] calldata min_amounts).
 * exchange({payableAmount (ether)} int128 i, int128 j, uint256 dx, uint256 min_dy).
 * - List:
 * ETH/ankrETH StableSwap: 0xA96A65c051bF88B4095Ee1f2451C2A9d43F53Ae2
 * rETH: 0xF9440930043eb3997fc70e1339dBb11F341de7A8
 * sETH: 0xc5424B857f758E906013F3555Dad202e4bdB4567
 * stETH: 0xDC24316b9AE028F1497c275EB9192a3Ea0f67022
 *
 *
 *
 * - Standard 4. Function Parameters:
 * coins(int128 index).
 * add_liquidity(uint256[4] memory amounts, uint256 min_mint_amount).
 * remove_liquidity(uint256 _amount, uint256[4] calldata min_amounts).
 * exchange(int128 i, int128 j, uint256 dx, uint256 min_dy).
 * - List:
 * sUSD: 0xA5407eAE9Ba41422680e2e00537571bcC53efBfD
 *
 *
 *
 * - Standard 5. Function Parameters:
 * coins(int128 index).
 * add_liquidity(uint256[3] memory amounts, uint256 min_mint_amount).
 * remove_liquidity(uint256 _amount, uint256[3] calldata min_amounts).
 * exchange(int128 i, int128 j, uint256 dx, uint256 min_dy).
 * - List:
 * sBTC: 0x7fC77b5c7614E1533320Ea6DDc2Eb61fa00A9714
 * USDT: 0x52EA46506B9CC5Ef470C5bf89f17Dc28bB35D85C
 *
 *
 *
 * - Standard 6. Function Parameters:
 * coins(int128 index).
 * add_liquidity(uint256[2] memory amounts, uint256 min_mint_amount).
 * remove_liquidity(uint256 _amount, uint256[2] calldata min_amounts).
 * exchange(int128 i, int128 j, uint256 dx, uint256 min_dy).
 * - List:
 * Compound: 0xA2B47E3D5c44877cca798226B7B8118F9BFb7A56
 * rentBTC: 0x93054188d876f558f4a66B2EF1d97d16eDf0895B
 */

//-Addresses Source: https://curve.readthedocs.io/ref-addresses.html#base-pools

contract CurveFiOperator is Ownable {
    mapping(address => uint256) public PoolAddresstoStandard;

    constructor() {
        PoolAddresstoStandard[0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7] = 1;
        PoolAddresstoStandard[0xDeBF20617708857ebe4F679508E7b7863a8A8EeE] = 1;
        PoolAddresstoStandard[0x2dded6Da1BF5DBdF597C45fcFaa3194e53EcfeAF] = 1;
        PoolAddresstoStandard[0x0Ce6a5fF5217e38315f87032CF90686C96627CAA] = 2;
        PoolAddresstoStandard[0x4CA9b3063Ec5866A4B82E437059D2C43d1be596F] = 2;
        PoolAddresstoStandard[0xF178C0b5Bb7e7aBF4e12A4838C7b7c5bA2C623c0] = 2;
        PoolAddresstoStandard[0xEB16Ae0052ed37f479f7fe63849198Df1765a733] = 2;
        PoolAddresstoStandard[0xA96A65c051bF88B4095Ee1f2451C2A9d43F53Ae2] = 3;
        PoolAddresstoStandard[0xF9440930043eb3997fc70e1339dBb11F341de7A8] = 3;
        PoolAddresstoStandard[0xc5424B857f758E906013F3555Dad202e4bdB4567] = 3;
        PoolAddresstoStandard[0xDC24316b9AE028F1497c275EB9192a3Ea0f67022] = 3;
        PoolAddresstoStandard[0xA5407eAE9Ba41422680e2e00537571bcC53efBfD] = 4;
        PoolAddresstoStandard[0x7fC77b5c7614E1533320Ea6DDc2Eb61fa00A9714] = 5;
        PoolAddresstoStandard[0x52EA46506B9CC5Ef470C5bf89f17Dc28bB35D85C] = 5;
        PoolAddresstoStandard[0xA2B47E3D5c44877cca798226B7B8118F9BFb7A56] = 6;
        PoolAddresstoStandard[0x93054188d876f558f4a66B2EF1d97d16eDf0895B] = 6;
    }

    function getLPTokensAmount(address LPTokenAddress) public view returns (uint256) {
        return IERC20Modified(LPTokenAddress).balanceOf(address(this));
    }

    function setPoolStandard(address poolAddress, uint256 poolStandard) public onlyOwner {
        require(poolStandard >= 1 || poolStandard <= 6, "Wrong Standard Number");
        PoolAddresstoStandard[poolAddress] = poolStandard;
    }

    function deletePool(address poolAddress) public onlyOwner {
        delete PoolAddresstoStandard[poolAddress];
    }

    /// param _amountTIndexes: List of Amounts of Different Coins to Deposit. Ex: [2 DAI, 4 USDC, 3 USDT].
    /// param minLPTokenMintAmount: Minimum amount of L.P. Tokens to mint from the deposit.
    /// return Returns the Minimum Amount of L.P. tokens received in exchange for the deposited tokens.
    /// @dev More Info Here: https://resources.curve.fi/lp/depositing/
    /// @dev AddLiquidity Function for Standars 1, 2, 3, 4, 5 and 6.
    /// @dev For the Inputs, Instert the uint256[N] correspondent to the Pool that you are Going to use,
    /// and Leave the Rest of uint256[N] full of Zeros Inside (Ex:_ "[0, 0, 0, 0]").
    function addLiquidity(
        address curveFiPool,
        address LPTokenAddress,
        uint256[2] calldata _amountTIndexes236,
        uint256[3] calldata _amountTIndexes15,
        uint256[4] calldata _amountTIndexes4
    ) external {
        uint256 poolStandard = PoolAddresstoStandard[curveFiPool];
        require(poolStandard >= 1 || poolStandard <= 6, "Wrong Standard Number");

        if (poolStandard == 1 || poolStandard == 5) {
            addLiquidity15(curveFiPool, LPTokenAddress, _amountTIndexes15);
        } else if (poolStandard == 2 || poolStandard == 3 || poolStandard == 6) {
            addLiquidity236(curveFiPool, LPTokenAddress, _amountTIndexes236);
        } else if (poolStandard == 4) {
            addLiquidity4(curveFiPool, LPTokenAddress, _amountTIndexes4);
        }
    }

    /// @param _amountTIndexes: List of Amounts of Different Coins to Deposit. Ex: [2 DAI, 4 USDC, 3 USDT].
    /// param minLPTokenMintAmount: Minimum amount of L.P. Tokens to mint from the deposit.
    /// return Returns the Minimum Amount of L.P. tokens received in exchange for the deposited tokens.
    /// @dev More Info Here: https://resources.curve.fi/lp/depositing/depositing-into-the-y-pool
    /// @dev AddLiquidity Function for Standars 1 and 5.
    function addLiquidity15(
        address curveFiPool,
        address LPTokenAddress,
        uint256[3] calldata _amountTIndexes
    ) internal {
        uint256 poolStandard = PoolAddresstoStandard[curveFiPool];
        require(poolStandard == 1 || poolStandard == 5, "Wrong Standard Number");
        //(1)-User's Underlaying ERC-20 Tokens are Transferred to the Operator S.C.:
        //depositLiquidityInOperator(curveFiPool, _amountTIndexes);
        int128 j;
        for (uint256 i = 0; i < 3; i++) {
            if (_amountTIndexes[i] > 0) {
                address currentCoinAddress;
                if (poolStandard == 1) {
                    currentCoinAddress = ICurveFiPool(curveFiPool).coins(i);
                } else if (poolStandard == 5) {
                    currentCoinAddress = ICurveFiPool(curveFiPool).coins(j);
                }
                IERC20Modified(currentCoinAddress).transferFrom(msg.sender, address(this), _amountTIndexes[i]);
                IERC20Modified(currentCoinAddress).approve(curveFiPool, _amountTIndexes[i]);
                j++;
            }
        }

        //(2)-CurveFi Pool add_liquidity Function is Called From the Operator S.C.:
        //-Example of the Function in the Curve S.C.s:_ def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256):
        ICurveFiPool(curveFiPool).add_liquidity(_amountTIndexes, 1);

        //(3)-CurveFi L.P. ERC-20 Tokens are Transferred From the Operator S.C. to the User:
        uint256 LPTokensAmount = getLPTokensAmount(LPTokenAddress);
        IERC20Modified(LPTokenAddress).approve(msg.sender, LPTokensAmount);
        IERC20Modified(LPTokenAddress).transfer(msg.sender, LPTokensAmount);
    }

    /// @param _amountTIndexes: List of Amounts of Different Coins to Deposit. Ex: [2 DAI, 4 USDC, 3 USDT].
    /// param minLPTokenMintAmount: Minimum amount of L.P. Tokens to mint from the deposit.
    /// return Returns the Minimum Amount of L.P. tokens received in exchange for the deposited tokens.
    /// @dev More Info Here: https://resources.curve.fi/lp/depositing/depositing-into-the-y-pool
    /// @dev AddLiquidity Function for Standars 2, 3 and 6.
    function addLiquidity236(
        address curveFiPool,
        address LPTokenAddress,
        uint256[2] calldata _amountTIndexes
    ) internal {
        uint256 poolStandard = PoolAddresstoStandard[curveFiPool];
        require(poolStandard == 2 || poolStandard == 3 || poolStandard == 6, "Wrong Standard Number");
        //(1)-User's Underlaying ERC-20 Tokens are Transferred to the Operator S.C.:
        //depositLiquidityInOperator(curveFiPool, _amountTIndexes);
        int128 j;
        for (uint256 i = 0; i < 2; i++) {
            if (_amountTIndexes[i] > 0) {
                address currentCoinAddress;
                if (poolStandard == 2 || poolStandard == 3) {
                    currentCoinAddress = ICurveFiPool(curveFiPool).coins(i);
                } else if (poolStandard == 6) {
                    currentCoinAddress = ICurveFiPool(curveFiPool).coins(j);
                }
                IERC20Modified(currentCoinAddress).transferFrom(msg.sender, address(this), _amountTIndexes[i]);
                IERC20Modified(currentCoinAddress).approve(curveFiPool, _amountTIndexes[i]);
                j++;
            }
        }

        //(2)-CurveFi Pool add_liquidity Function is Called From the Operator S.C.:
        //-Example of the Function in the Curve S.C.s:_ def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256):
        ICurveFiPool(curveFiPool).add_liquidity(_amountTIndexes, 1);

        //(3)-CurveFi L.P. ERC-20 Tokens are Transferred From the Operator S.C. to the User:
        uint256 LPTokensAmount = getLPTokensAmount(LPTokenAddress);
        IERC20Modified(LPTokenAddress).approve(msg.sender, LPTokensAmount);
        IERC20Modified(LPTokenAddress).transfer(msg.sender, LPTokensAmount);
    }

    /// @param _amountTIndexes: List of Amounts of Different Coins to Deposit. Ex: [2 DAI, 4 USDC, 3 USDT].
    /// param minLPTokenMintAmount: Minimum amount of L.P. Tokens to mint from the deposit.
    /// return Returns the Minimum Amount of L.P. tokens received in exchange for the deposited tokens.
    /// @dev More Info Here: https://resources.curve.fi/lp/depositing/depositing-into-the-y-pool
    /// @dev AddLiquidity Function for Standar 4.
    function addLiquidity4(
        address curveFiPool,
        address LPTokenAddress,
        uint256[4] calldata _amountTIndexes
    ) internal {
        uint256 poolStandard = PoolAddresstoStandard[curveFiPool];
        require(poolStandard == 4, "Wrong Standard Number");
        //(1)-User's Underlaying ERC-20 Tokens are Transferred to the Operator S.C.:
        int128 j;
        for (uint256 i = 0; i < 4; i++) {
            if (_amountTIndexes[i] > 0) {
                address currentCoinAddress = ICurveFiPool(curveFiPool).coins(j);
                IERC20Modified(currentCoinAddress).transferFrom(msg.sender, address(this), _amountTIndexes[i]);
                IERC20Modified(currentCoinAddress).approve(curveFiPool, _amountTIndexes[i]);
                j++;
            }
        }

        //(2)-CurveFi Pool add_liquidity Function is Called From the Operator S.C.:
        //-Example of the Function in the Curve S.C.s:_ def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256):
        ICurveFiPool(curveFiPool).add_liquidity(_amountTIndexes, 1);

        //(3)-CurveFi L.P. ERC-20 Tokens are Transferred From the Operator S.C. to the User:
        uint256 LPTokensAmount = getLPTokensAmount(LPTokenAddress);
        IERC20Modified(LPTokenAddress).approve(msg.sender, LPTokensAmount);
        IERC20Modified(LPTokenAddress).transfer(msg.sender, LPTokensAmount);
    }

    /// @notice Withdraw coins from the pool in an imbalanced amount.
    /// param _amounts: List of Amounts of Different Coins to Withdraw. Ex: [3 USDT, 2 DAI, 4 USDC].
    /// param _max_burn_amount: Minimum amount of L.P. Tokens to burn in the Withdraw.
    /// return Returns actual amount of the L.P. Tokens burned in the Withdrawal.
    /// @dev More Info Here: https://curve.readthedocs.io/exchange-pools.html#StableSwap.remove_liquidity_imbalance
    /// @dev RemoveLiquidity Function for Standars 1, 2, 3, 4, 5 and 6.
    function removeLiquidity(address curveFiPool, address LPTokenAddress) external {
        uint256 poolStandard = PoolAddresstoStandard[curveFiPool];
        require(poolStandard >= 1 || poolStandard <= 6, "Wrong Standard Number");
        //(1)-User's L.P. ERC-20 Tokens are Transferred to the Operator S.C.:
        uint256 userLPTokensAmount = IERC20Modified(LPTokenAddress).balanceOf(msg.sender);

        IERC20Modified(LPTokenAddress).transferFrom(msg.sender, address(this), userLPTokensAmount);
        IERC20Modified(LPTokenAddress).approve(curveFiPool, userLPTokensAmount);

        //(2)-CurveFi Pool remove_liquidity Function is Called From the Operator S.C.:
        uint256 oneUint256 = 1;

        //-Example of the Function in the Curve S.C.s:_ def remove_liquidity(_amount: uint256, _min_amounts: uint256[3]):
        uint256 maxNumber;
        if (poolStandard == 1 || poolStandard == 5) {
            maxNumber = 3;
            ICurveFiPool(curveFiPool).remove_liquidity(userLPTokensAmount, [oneUint256, oneUint256, oneUint256]);
        } else if (poolStandard == 2 || poolStandard == 3 || poolStandard == 6) {
            maxNumber = 2;
            ICurveFiPool(curveFiPool).remove_liquidity(userLPTokensAmount, [oneUint256, oneUint256]);
        } else if (poolStandard == 4) {
            maxNumber = 4;
            ICurveFiPool(curveFiPool).remove_liquidity(
                userLPTokensAmount,
                [oneUint256, oneUint256, oneUint256, oneUint256]
            );
        }

        //(3)-Underlaying ERC-20 Tokens are Transferred From the Operator S.C. to the User:
        int128 j;
        for (uint256 i = 0; i < maxNumber; i++) {
            address currentCoinAddress;
            if (poolStandard >= 1 && poolStandard <= 3) {
                currentCoinAddress = ICurveFiPool(curveFiPool).coins(i);
            } else if (poolStandard >= 4 && poolStandard <= 6) {
                currentCoinAddress = ICurveFiPool(curveFiPool).coins(j);
            }
            uint256 currentCoinAmount = IERC20Modified(currentCoinAddress).balanceOf(address(this));
            IERC20Modified(currentCoinAddress).approve(msg.sender, currentCoinAmount);
            IERC20Modified(currentCoinAddress).transfer(msg.sender, currentCoinAmount);
            j++;
        }
    }

    /// @notice Function Perform an Exchange between 2 ERC-20 Tokens in the MetaPool.
    /// @notice Index values can be found via the coins public getter method.
    /// @param _tokenInIndexInt:  Index value for the coin to send in Int128.
    /// @param _tokenOutIndexInt:  Index value for the coin to receive in Int128.
    /// @param _tokenInIndexUint:  Index value for the coin to send in Uint256.
    /// @param _tokenOutIndexUint:  Index value for the coin to receive in Uint256.
    /// @param _amountIn:  Amount of TokenIn being exchanged.
    /// @dev More Info Here: https://curve.readthedocs.io/exchange-pools.html#id14
    /// @dev ExchangeTokens Function for Standars 1, 2, 3, 4, 5 and 6.
    function exchangeTokens(
        address curveFiPool,
        int128 _tokenInIndexInt,
        int128 _tokenOutIndexInt,
        uint256 _tokenInIndexUint,
        uint256 _tokenOutIndexUint,
        uint256 _amountIn
    ) external {
        uint256 poolStandard = PoolAddresstoStandard[curveFiPool];
        require(poolStandard >= 1 && poolStandard <= 6, "Wrong Standard Number");

        //(1)-User's In Exchange ERC-20 Tokens are Transferred to the Operator S.C.:
        address tokenInAddress;
        if (poolStandard >= 1 && poolStandard <= 3) {
            tokenInAddress = ICurveFiPool(curveFiPool).coins(_tokenInIndexUint);
        } else if (poolStandard >= 4 && poolStandard <= 6) {
            tokenInAddress = ICurveFiPool(curveFiPool).coins(_tokenInIndexInt);
        }

        IERC20Modified(tokenInAddress).transferFrom(msg.sender, address(this), _amountIn);
        IERC20Modified(tokenInAddress).approve(curveFiPool, _amountIn);

        //(2)-CurveFi Pool exchange Function is Called From the Operator S.C.:
        //-Example of the Function in the Curve S.C.s:_ def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256): nonpayable
        ICurveFiPool(curveFiPool).exchange(_tokenInIndexInt, _tokenOutIndexInt, _amountIn, 1);

        //(3)-Out Exchange ERC-20 Tokens are Transferred From the Operator S.C. to the User:
        address tokenOutAddress = ICurveFiPool(curveFiPool).coins(_tokenOutIndexUint);
        uint256 tokenOutAmount = IERC20Modified(tokenOutAddress).balanceOf(address(this));
        IERC20Modified(tokenOutAddress).transfer(msg.sender, tokenOutAmount);
    }
}
