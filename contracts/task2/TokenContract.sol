// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/Uniswap.sol";

contract TokenContract2 is ERC20, Ownable {
    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    address private constant FACTORY =
        0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private constant WETH_ADDRESS =
        0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;

    uint8 public burnPercentage = 2; //0.2%
    uint8 public taxPercentage = 8; //0.8%

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _amount
    ) ERC20(_name, _symbol) Ownable(msg.sender) {
        _mint(msg.sender, _amount * 10 ** decimals());
        IUniswapV2Factory(FACTORY).createPair(address(this), WETH_ADDRESS);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function getPoolAddress() public view returns (address pair) {
        return IUniswapV2Factory(FACTORY).getPair(address(this), WETH_ADDRESS);
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

    // function _transfer(
    //     address _from,
    //     address _to,
    //     uint256 _amount
    // ) internal override virtual  {
    //     uint256 taxAmount = calFee(_amount, taxPercentage);
    //     uint256 burnAmount = calFee(_amount, burnPercentage);
    //     _burn(_from, burnAmount);
    //     super._transfer(_from, address(this), taxAmount);
    //     super._transfer(_from, _to, _amount - (burnAmount + taxAmount));
    // }

    function addLiquidityETHToPool(uint _amountA) external payable {
        if (allowance(_msgSender(), UNISWAP_V2_ROUTER) == 0) {
            approve(UNISWAP_V2_ROUTER, type(uint56).max);
        }
        IUniswapV2Router(UNISWAP_V2_ROUTER).addLiquidityETH{value: msg.value}(
            address(this),
            _amountA,
            0,
            0,
            msg.sender,
            block.timestamp
        );
    }

    function removeLiquidityETHToPool(uint _amountA) external {
        IUniswapV2Router(UNISWAP_V2_ROUTER).removeLiquidityETH(
            address(this),
            _amountA, //liquidity
            0,
            0,
            msg.sender,
            block.timestamp
        );
    }

    function ApproveMaxTokens() external {
        approve(UNISWAP_V2_ROUTER, type(uint56).max);
    }

    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20) {
        super._update(from, to, value);
    }
}
