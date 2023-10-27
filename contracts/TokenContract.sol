// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenContract is ERC20, Ownable {
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
}
