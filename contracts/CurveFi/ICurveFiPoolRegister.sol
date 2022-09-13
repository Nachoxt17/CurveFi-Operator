// SPDX-License-Identifier: M.I.T.
pragma solidity ^0.8.9;

interface ICurveFiPoolRegister {
    function find_pool_for_coins(address _from, address _to) external returns (address out);

    function get_n_coins(address _pool) external returns (uint256[2] memory);

    function get_coins(address _pool) external returns (address[8] memory);

    function get_coin_indices(
        address _pool,
        address _from,
        address _to
    )
        external
        returns (
            int128,
            int128,
            bool
        );

    function get_lp_token(address arg0) external returns (address);
}
