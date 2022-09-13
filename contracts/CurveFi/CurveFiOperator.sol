// SPDX-License-Identifier: M.I.T.
pragma solidity ^0.8.9;

import { ICurveFiPool } from "./ICurveFiPool.sol";
import { ICurveFiPoolRegister } from "./ICurveFiPoolRegister.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

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
    using SafeERC20 for IERC20;
    mapping(address => uint256) public PoolAddresstoStandard;
    ICurveFiPoolRegister CurveFiPoolRegister = ICurveFiPoolRegister(0x90E00ACe148ca3b23Ac1bC8C240C2a7Dd9c2d7f5);
    uint256[] tokenBalancesBefore;

    event TransactionDone(bool _done);

    /// param _amountTIndexes: List of Amounts of Different Coins to Deposit. Ex: [2 DAI, 4 USDC, 3 USDT].
    /// param minLPTokenMintAmount: Minimum amount of L.P. Tokens to mint from the deposit.
    /// return Returns the Minimum Amount of L.P. tokens received in exchange for the deposited tokens.
    /// @dev More Info Here: https://resources.curve.fi/lp/depositing/
    /// @dev For the Inputs, Instert the uint256[N] correspondent to the Pool that you are Going to use.
    function addLiquidity(address curveFiPool, uint256[] calldata _amountTIndexes) external {
        address LPTokenAddress = CurveFiPoolRegister.get_lp_token(curveFiPool);
        //(1)-User's Underlaying ERC-20 Tokens are Transferred to the Operator S.C.:
        uint256 maxNumber = CurveFiPoolRegister.get_n_coins(curveFiPool)[0];
        for (uint256 i = 0; i < maxNumber; i++) {
            if (_amountTIndexes[i] > 0) {
                address currentCoinAddress = CurveFiPoolRegister.get_coins(curveFiPool)[i];
                IERC20(currentCoinAddress).safeTransferFrom(msg.sender, address(this), _amountTIndexes[i]);
                IERC20(currentCoinAddress).safeApprove(curveFiPool, _amountTIndexes[i]);
            }
        }

        //-L.P. Tokens Amount Currently in the Operator Before the User Adds Liquidity:
        uint256 LPTInOperator = IERC20(LPTokenAddress).balanceOf(address(this));

        //(2)-CurveFi Pool add_liquidity Function is Called From the Operator S.C.:
        //-Example of the Function in the Curve S.C.s:_ def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256):
        if (maxNumber == 2) {
            ICurveFiPool(curveFiPool).add_liquidity([_amountTIndexes[0], _amountTIndexes[1]], 1);
        } else if (maxNumber == 3) {
            ICurveFiPool(curveFiPool).add_liquidity([_amountTIndexes[0], _amountTIndexes[1], _amountTIndexes[2]], 1);
        } else if (maxNumber == 4) {
            ICurveFiPool(curveFiPool).add_liquidity(
                [_amountTIndexes[0], _amountTIndexes[1], _amountTIndexes[2], _amountTIndexes[3]],
                1
            );
        }

        //(3)-CurveFi L.P. ERC-20 Tokens are Transferred From the Operator S.C. to the User:
        uint256 LPTokensAmountToReceive = (IERC20(LPTokenAddress).balanceOf(address(this)) - LPTInOperator);
        IERC20(LPTokenAddress).safeTransfer(msg.sender, LPTokensAmountToReceive);
    }

    /// @notice Withdraw coins from the pool in an imbalanced amount.
    /// param _amounts: List of Amounts of Different Coins to Withdraw. Ex: [3 USDT, 2 DAI, 4 USDC].
    /// param _max_burn_amount: Minimum amount of L.P. Tokens to burn in the Withdraw.
    /// return Returns actual amount of the L.P. Tokens burned in the Withdrawal.
    /// @dev More Info Here: https://curve.readthedocs.io/exchange-pools.html#StableSwap.remove_liquidity_imbalance
    /// @dev RemoveLiquidity Function for Standars 1, 2, 3, 4, 5 and 6.
    function removeLiquidity(address curveFiPool) external {
        address LPTokenAddress = CurveFiPoolRegister.get_lp_token(curveFiPool);
        //(1)-User's L.P. ERC-20 Tokens are Transferred to the Operator S.C.:
        uint256 userLPTokensAmount = IERC20(LPTokenAddress).balanceOf(msg.sender);

        IERC20(LPTokenAddress).safeTransferFrom(msg.sender, address(this), userLPTokensAmount);
        IERC20(LPTokenAddress).safeApprove(curveFiPool, userLPTokensAmount);

        //(2)-CurveFi Pool remove_liquidity Function is Called From the Operator S.C.:
        //-Example of the Function in the Curve S.C.s:_ def remove_liquidity(_amount: uint256, _min_amounts: uint256[3]):
        uint256 maxNumber = CurveFiPoolRegister.get_n_coins(curveFiPool)[0];
        uint256[] storage _tokenBalancesBefore = tokenBalancesBefore;
        for (uint256 i = 0; i < maxNumber; i++) {
            address currentCoinAddress = CurveFiPoolRegister.get_coins(curveFiPool)[i];
            _tokenBalancesBefore.push(IERC20(currentCoinAddress).balanceOf(address(this)));
        }
        if (maxNumber == 2) {
            ICurveFiPool(curveFiPool).remove_liquidity(userLPTokensAmount, [uint256(1), uint256(1)]);
        } else if (maxNumber == 3) {
            ICurveFiPool(curveFiPool).remove_liquidity(userLPTokensAmount, [uint256(1), uint256(1), uint256(1)]);
        } else if (maxNumber == 4) {
            ICurveFiPool(curveFiPool).remove_liquidity(
                userLPTokensAmount,
                [uint256(1), uint256(1), uint256(1), uint256(1)]
            );
        }

        //(3)-Underlaying ERC-20 Tokens are Transferred From the Operator S.C. to the User:
        for (uint256 i = 0; i < maxNumber; i++) {
            address currentCoinAddress = CurveFiPoolRegister.get_coins(curveFiPool)[i];
            uint256 currentCoinAmount = (IERC20(currentCoinAddress).balanceOf(address(this)) - _tokenBalancesBefore[i]);
            IERC20(currentCoinAddress).safeApprove(msg.sender, currentCoinAmount);
            IERC20(currentCoinAddress).safeTransfer(msg.sender, currentCoinAmount);
        }
    }

    /// @notice Function Perform an Exchange between 2 ERC-20 Tokens in the MetaPool.
    /// @notice Index values can be found via the coins public getter method.
    /// @param _amountIn:  Amount of TokenIn being exchanged.
    /// @dev More Info Here: https://curve.readthedocs.io/exchange-pools.html#id14
    function exchangeTokens(
        address tokenIn,
        address tokenOut,
        uint256 _amountIn
    ) external {
        address curveFiPool = CurveFiPoolRegister.find_pool_for_coins(tokenIn, tokenOut);
        (int128 tokenInIndex, int128 tokenOutIndex, bool unusedBool) = CurveFiPoolRegister.get_coin_indices(
            curveFiPool,
            tokenIn,
            tokenOut
        );

        //(1)-User's In Exchange ERC-20 Tokens are Transferred to the Operator S.C.:
        IERC20(tokenIn).safeTransferFrom(msg.sender, address(this), _amountIn);
        IERC20(tokenIn).safeApprove(curveFiPool, _amountIn);

        //(2)-CurveFi Pool exchange Function is Called From the Operator S.C.:
        //-Example of the Function in the Curve S.C.s:_ def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256): nonpayable
        uint256 tokenOutAmount = ICurveFiPool(curveFiPool).get_dy(tokenInIndex, tokenOutIndex, _amountIn);
        ICurveFiPool(curveFiPool).exchange(tokenInIndex, tokenOutIndex, _amountIn, tokenOutAmount);

        //(3)-Out Exchange ERC-20 Tokens are Transferred From the Operator S.C. to the User:
        IERC20(tokenOut).safeTransfer(msg.sender, tokenOutAmount);
    }
}
