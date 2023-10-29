// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/Uniswap.sol";

contract TokenContract is ERC20, Ownable {
    
    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant DAI_TOKEN =
        0x6B175474E89094C44Da98b954EedeAC495271d0F;

    uint8 public burnPercentage = 2; //0.2%
    uint8 public taxPercentage = 8; //0.8%

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _amount
    ) ERC20(_name, _symbol) {
        _mint(msg.sender, _amount * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function calFee(
        uint256 amount,
        uint8 percentage
    ) internal pure returns (uint256) {
        require(percentage <= 1000, "Percentage should be 1000 or less");
        return (amount * percentage) / 1000;
    }

    function setBurnPercentage(uint8 newFee) public onlyOwner {
        burnPercentage = newFee * 10;
    }

    function setTaxPercentage(uint8 newFee) public onlyOwner {
        taxPercentage = newFee * 10;
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _amount
    ) internal virtual override {
        uint256 taxAmount = calFee(_amount, taxPercentage);
        uint256 burnAmount = calFee(_amount, burnPercentage);
        _burn(_from, burnAmount);
        super._transfer(_from, address(this), taxAmount);
        super._transfer(_from, _to, _amount - (burnAmount + taxAmount));
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
}
