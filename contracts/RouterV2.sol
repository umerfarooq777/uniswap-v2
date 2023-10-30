//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract RouterV2 {
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity) {}

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts) {}

    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts) {}

    function getAmountsIn(
        uint amountOut,
        address[] memory path
    ) public view returns (uint[] memory amounts) {}

    function getAmountsOut(
        uint amountIn,
        address[] memory path
    ) public view returns (uint[] memory amounts) {}
}
