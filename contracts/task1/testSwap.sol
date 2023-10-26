// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/Uniswap.sol";

contract TestUniswap {
  address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

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
    
    uint[] memory amountOutMins = IUniswapV2Router(UNISWAP_V2_ROUTER).getAmountsOut(_amountIn, path);

    return amountOutMins[1];
  }


  function getAmountInMin(
    address _tokenIn,
    address _tokenOut,
    uint _amountOut
  ) external view returns (uint) {
    address[] memory path = new address[](2);
      path[0] =  _tokenOut;
      path[1] = _tokenIn;
    
    uint[] memory amountInMins = IUniswapV2Router(UNISWAP_V2_ROUTER).getAmountsIn(_amountOut, path);

    return amountInMins[1];
  }
}