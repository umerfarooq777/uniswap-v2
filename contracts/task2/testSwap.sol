// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/Uniswap.sol";

contract TestUniswap2 {
    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant FACTORY =
        0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;

    function getPoolTokens(
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

    function swapExactTokensForTokensHandle(
        uint _amountIn,
        uint _amountOutMin,
        address[] memory path,
        address _to,
        uint256 _time
    ) external {
        address _tokenIn = path[0];
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn);
        IERC20(_tokenIn).approve(UNISWAP_V2_ROUTER, _amountIn);

        // address[] memory path = new address[](2);
        // path[0] = _tokenIn;
        // path[1] = _tokenOut;

        IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForTokens(
            _amountIn,
            _amountOutMin,
            path,
            _to,
            _time
        );
    }

    function getAmountsOut(
        address _tokenIn,
        address _tokenOut,
        uint _amountIn
    ) external view returns (uint[] memory amounts) {
        address[] memory path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;

        return
            IUniswapV2Router(UNISWAP_V2_ROUTER).getAmountsOut(_amountIn, path);
    }

    function getAmountsIn(
        address _tokenIn,
        address _tokenOut,
        uint _amountOut
    ) external view returns (uint[] memory amounts) {
        address[] memory path = new address[](2);
        path[0] = _tokenOut;
        path[1] = _tokenIn;

        return
            IUniswapV2Router(UNISWAP_V2_ROUTER).getAmountsIn(_amountOut, path);
    }

    function creatUniswapPair(
        address _tokenA,
        address _tokenB
    ) external returns (address) {
        address pair = IUniswapV2Factory(FACTORY).createPair(_tokenA, _tokenB);

        return pair;
    }

    function addLiquidityToPool(
        address _tokenA,
        address _tokenB,
        uint _amountA,
        uint _amountB
    ) external {
        IERC20(_tokenA).transferFrom(msg.sender, address(this), _amountA);
        IERC20(_tokenB).transferFrom(msg.sender, address(this), _amountB);

        if (IERC20(_tokenA).allowance(address(this), UNISWAP_V2_ROUTER) == 0) {
            ApproveMaxTokens(_tokenA);
        }

        if (IERC20(_tokenB).allowance(address(this), UNISWAP_V2_ROUTER) == 0) {
            ApproveMaxTokens(_tokenB);
        }
        // IERC20(_tokenA).approve(UNISWAP_V2_ROUTER, _amountA);
        // IERC20(_tokenB).approve(UNISWAP_V2_ROUTER, _amountB);

        // (uint amountA, uint amountB, uint liquidity) =
        IUniswapV2Router(UNISWAP_V2_ROUTER).addLiquidity(
            _tokenA,
            _tokenB,
            _amountA,
            _amountB,
            0,
            0,
            msg.sender,
            block.timestamp
        );
    }

    function ApproveMaxTokens(address _tokenAddress) internal {
        IERC20(_tokenAddress).approve(UNISWAP_V2_ROUTER, type(uint56).max);
    }

    function removeLiquidity(address _tokenA, address _tokenB) external {
        address pair = IUniswapV2Factory(FACTORY).getPair(_tokenA, _tokenB);

        uint liquidity = IERC20(pair).balanceOf(msg.sender);
        IERC20(pair).approve(UNISWAP_V2_ROUTER, liquidity);

        // (uint amountA, uint amountB) =
        IUniswapV2Router(UNISWAP_V2_ROUTER).removeLiquidity(
            _tokenA,
            _tokenB,
            liquidity,
            0,
            0,
            msg.sender,
            block.timestamp
        );
    }

    function withDrawTaxAsEth(address _token) external view returns (address) {
        IERC20Ownable(_token)._checkOwner();
        return IERC20Ownable(_token).owner();
        // uint collectedTax = IERC20(_token).balanceOf(_token);
        // IERC20(_token).approve(UNISWAP_V2_ROUTER, collectedTax);
    }
}
