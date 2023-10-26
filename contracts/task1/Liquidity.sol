// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/Uniswap.sol";

contract TestUniswapLiquidity {
  address private constant FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
  address private constant ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

  event Log(string message, uint val);

  function creatUniswapPair(
    address _tokenA,
    address _tokenB
  ) external returns(address){
    
    address pair = IUniswapV2Factory(FACTORY).createPair(_tokenA, _tokenB);


    emit Log("amountA", amountA);
    emit Log("amountB", amountB);
    emit Log("liquidity", liquidity);
    return pair
  }
  
  function addLiquidity(
    address _tokenA,
    address _tokenB,
    uint _amountA,
    uint _amountB
  ) external {
    IERC20(_tokenA).transferFrom(msg.sender, msg.sender, _amountA);
    IERC20(_tokenB).transferFrom(msg.sender, msg.sender, _amountB);

    IERC20(_tokenA).approve(ROUTER, _amountA);
    IERC20(_tokenB).approve(ROUTER, _amountB);

    (uint amountA, uint amountB, uint liquidity) = IUniswapV2Router(ROUTER).addLiquidity(
        _tokenA,
        _tokenB,
        _amountA,
        _amountB,
        1,
        1,
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
    IERC20(pair).approve(ROUTER, liquidity);

    (uint amountA, uint amountB) =
      IUniswapV2Router(ROUTER).removeLiquidity(
        _tokenA,
        _tokenB,
        liquidity,
        1,
        1,
        msg.sender,
        block.timestamp
      );

    emit Log("amountA", amountA);
    emit Log("amountB", amountB);
    emit Log("liquidity Removed", liquidity);
  }
}