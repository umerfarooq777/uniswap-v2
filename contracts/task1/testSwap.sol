// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/Uniswap.sol";

contract TestUniswap1 {
    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant FACTORY =
        0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;

    event Log(string message, uint indexed val);

    function getPoolTokems(
        address _tokenA,
        address _tokenB
    )
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast)
    {
        address _poolAddress = getPoolAddress(_tokenA, _tokenB);
        return IUniswapV2Pair(_poolAddress).getReserves();
    }

    function getPoolAddress(
        address _tokenA,
        address _tokenB
    ) public view returns (address pair) {
        return IUniswapV2Factory(FACTORY).getPair(_tokenA, _tokenB);
    }

    function swap(
        address _tokenIn,
        address _tokenOut,
        uint _amountIn,
        uint _amountOutMin,
        address _to
    ) external {
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn);
        IERC20(_tokenIn).approve(UNISWAP_V2_ROUTER, _amountIn);

        address[] memory path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;

        IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForTokens(
            _amountIn,
            _amountOutMin,
            path,
            _to,
            block.timestamp
        );
    }

    function getAmountOutMin(
        address _tokenIn,
        address _tokenOut,
        uint _amountIn
    ) external view returns (uint) {
        address[] memory path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;

        uint[] memory amountOutMins = IUniswapV2Router(UNISWAP_V2_ROUTER)
            .getAmountsOut(_amountIn, path);

        return amountOutMins[1];
    }

    function getAmountInMin(
        address _tokenIn,
        address _tokenOut,
        uint _amountOut
    ) external view returns (uint) {
        address[] memory path = new address[](2);
        path[0] = _tokenOut;
        path[1] = _tokenIn;

        uint[] memory amountInMins = IUniswapV2Router(UNISWAP_V2_ROUTER)
            .getAmountsIn(_amountOut, path);

        return amountInMins[1];
    }

    function creatUniswapPair(
        address _tokenA,
        address _tokenB
    ) external returns (address) {
        address pair = IUniswapV2Factory(FACTORY).createPair(_tokenA, _tokenB);

        return pair;
    }

    function addLiquidity(
        address _tokenA,
        address _tokenB,
        uint _amountA,
        uint _amountB
    ) external {
        IERC20(_tokenA).transferFrom(msg.sender, address(this), _amountA);
        IERC20(_tokenB).transferFrom(msg.sender, address(this), _amountB);

        IERC20(_tokenA).approve(UNISWAP_V2_ROUTER, _amountA);
        IERC20(_tokenB).approve(UNISWAP_V2_ROUTER, _amountB);

        (uint amountA, uint amountB, uint liquidity) = IUniswapV2Router(
            UNISWAP_V2_ROUTER
        ).addLiquidity(
                _tokenA,
                _tokenB,
                _amountA,
                _amountB,
                0,
                0,
                msg.sender,
                block.timestamp
            );

        emit Log("amountA", amountA);
        emit Log("amountB", amountB);
        emit Log("liquidity", liquidity);
    }

    function removeLiquidity(address _tokenA, address _tokenB) external {
        address pair = IUniswapV2Factory(FACTORY).getPair(_tokenA, _tokenB);

        uint liquidity = IERC20(pair).balanceOf(msg.sender);
        IERC20(pair).approve(UNISWAP_V2_ROUTER, liquidity);

        (uint amountA, uint amountB) = IUniswapV2Router(UNISWAP_V2_ROUTER)
            .removeLiquidity(
                _tokenA,
                _tokenB,
                liquidity,
                0,
                0,
                msg.sender,
                block.timestamp
            );

        emit Log("amountA", amountA);
        emit Log("amountB", amountB);
        emit Log("liquidity Removed", liquidity);
    }
}
