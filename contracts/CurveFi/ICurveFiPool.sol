// SPDX-License-Identifier: M.I.T.
pragma solidity ^0.8.9;

interface ICurveFiPool {
    //-Events:

    event TokenExchange(
        address indexed buyer,
        int128 sold_id,
        uint256 tokens_sold,
        int128 bought_id,
        uint256 tokens_bought
    );

    event AddLiquidity(
        address indexed provider,
        uint256[] token_amounts,
        uint256[] fees,
        uint256 invariant,
        uint256 token_supply
    );

    event RemoveLiquidity(address indexed provider, uint256[] token_amounts, uint256[] fees, uint256 token_supply);

    event RemoveLiquidityOne(address indexed provider, uint256 token_amount, uint256 coin_amount);

    event RemoveLiquidityImbalance(
        address indexed provider,
        uint256[] token_amounts,
        uint256[] fees,
        uint256 invariant,
        uint256 token_supply
    );

    event CommitNewAdmin(uint256 indexed deadline, address indexed admin);

    event NewAdmin(address indexed admin);

    event CommitNewFee(uint256 indexed deadline, uint256 fee, uint256 admin_fee);

    event NewFee(uint256 fee, uint256 admin_fee);

    event RampA(uint256 old_A, uint256 new_A, uint256 initial_time, uint256 future_time);

    event StopRampA(uint256 A, uint256 t);

    //-Functions:

    function get_virtual_price() external returns (uint256 out);

    function calc_token_amount(uint256[2] calldata _amounts, bool _is_deposit) external view returns (uint256);

    function calc_token_amount(uint256[3] calldata _amounts, bool _is_deposit) external view returns (uint256);

    function calc_token_amount(uint256[4] calldata _amounts, bool _is_deposit) external view returns (uint256);

    function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount) external;

    function add_liquidity(uint256[3] calldata amounts, uint256 min_mint_amount) external;

    function add_liquidity(uint256[4] calldata amounts, uint256 min_mint_amount) external;

    function get_dy(
        int128 i,
        int128 j,
        uint256 dx
    ) external returns (uint256 out);

    function get_dy_underlying(
        int128 i,
        int128 j,
        uint256 dx
    ) external returns (uint256 out);

    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy
    ) external;

    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy,
        uint256 deadline
    ) external;

    function exchange_underlying(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy
    ) external;

    function exchange_underlying(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy,
        uint256 deadline
    ) external;

    function remove_liquidity(uint256 _amount, uint256[2] calldata min_amounts) external;

    function remove_liquidity(uint256 _amount, uint256[3] calldata min_amounts) external;

    function remove_liquidity(uint256 _amount, uint256[4] calldata min_amounts) external;

    function remove_liquidity_imbalance(uint256[2] calldata amounts, uint256 deadline) external;

    function commit_new_parameters(
        int128 amplification,
        int128 new_fee,
        int128 new_admin_fee
    ) external;

    function apply_new_parameters() external;

    function revert_new_parameters() external;

    function commit_transfer_ownership(address _owner) external;

    function apply_transfer_ownership() external;

    function revert_transfer_ownership() external;

    function withdraw_admin_fees() external;

    function coins(int128 index) external returns (address out);

    function coins(uint256 index) external returns (address out);

    function underlying_coins(int128 index) external returns (address out);

    function balances(int128 index) external returns (uint256 out);

    function A() external returns (int128 out);

    function fee() external returns (uint256 out);

    function admin_fee() external returns (uint256 out);

    function owner() external returns (address out);

    function admin_actions_deadline() external returns (uint256 out);

    function transfer_ownership_deadline() external returns (uint256 out);

    function future_A() external returns (int128 out);

    function future_fee() external returns (int128 out);

    function future_admin_fee() external returns (int128 out);

    function future_owner() external returns (address out);
}
