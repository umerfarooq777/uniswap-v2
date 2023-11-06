// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// import "../interfaces/Uniswap.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

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

    // function _update(
    //     address _from,
    //     address _to,
    //     uint256 _amount
    // )  override internal  {
    //     uint256 taxAmount = calFee(_amount, taxPercentage);
    //     uint256 burnAmount = calFee(_amount, burnPercentage);
    //     _burn(_from, burnAmount);
    //     super._update(_from, address(this), taxAmount);
    //     super._update(_from, _to, _amount - (burnAmount + taxAmount));
    // }
    function transfer(
        address _to,
        uint256 _amount
    ) public override returns (bool) {
        uint256 taxAmount = calFee(_amount, taxPercentage);
        uint256 burnAmount = calFee(_amount, burnPercentage);
        super.transfer(address(this), taxAmount);
        super.transfer(_to, (_amount - (burnAmount + taxAmount)));
        _burn(_msgSender(), burnAmount);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) public override returns (bool) {
        uint256 taxAmount = calFee(_amount, taxPercentage);
        uint256 burnAmount = calFee(_amount, burnPercentage);
        super.transferFrom(_from, address(this), taxAmount);
        super.transferFrom(_from, _to, _amount - (burnAmount + taxAmount));
        _burn(_from, burnAmount);
        return true;
    }

    //  function _update(address from, address to, uint256 value) internal override {
    //     //mint or burn condition
    //     if(from == address(0) || to == address(0) || to == address(this)) {
    //                 super._update(from, to, value);
    //         }

    //     if(from != address(0) && to != address(0) && to != address(this)){

    //     uint256 taxAmount = calFee(value, taxPercentage);
    //     uint256 burnAmount = calFee(value, burnPercentage);
    //     super._burn(from, burnAmount);
    //     super._update(from, address(this), taxAmount);
    //     super._update(from, to, value - (burnAmount + taxAmount));
    //     }

    // }

    function addLiquidityETHToPool(uint256 _amountA) external payable {
        IERC20(address(this)).transferFrom(
            _msgSender(),
            address(this),
            _amountA
        );
        if (allowance(address(this), UNISWAP_V2_ROUTER) == 0) {
            IERC20(address(this)).approve(UNISWAP_V2_ROUTER, type(uint56).max);
        }
        IUniswapV2Router02(UNISWAP_V2_ROUTER).addLiquidityETH{value: msg.value}(
            address(this),
            _amountA,
            0,
            0,
            msg.sender,
            block.timestamp
        );
    }

    function removeLiquidityETHToPool(uint256 _amountLP) external {
        address pairAddress = getPoolAddress();
        IERC20(pairAddress).transferFrom(
            _msgSender(),
            address(this),
            _amountLP
        );
        if (
            IERC20(pairAddress).allowance(address(this), UNISWAP_V2_ROUTER) == 0
        ) {
            IERC20(pairAddress).approve(UNISWAP_V2_ROUTER, type(uint56).max);
        }
        IUniswapV2Router02(UNISWAP_V2_ROUTER).removeLiquidityETH(
            address(this),
            _amountLP, //liquidity
            0,
            0,
            msg.sender,
            block.timestamp
        );
    }

    function ApproveMaxTokens() external {
        approve(address(this), type(uint56).max);
    }

    function withDrawTaxCollection() external onlyOwner {
        require(balanceOf(address(this)) > 0, "Insufficient Tax collected");
        if (allowance(address(this), UNISWAP_V2_ROUTER) == 0) {
            IERC20(address(this)).approve(UNISWAP_V2_ROUTER, type(uint56).max);
        }
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WETH_ADDRESS;
        IUniswapV2Router02(UNISWAP_V2_ROUTER).swapTokensForExactETH(
            0, //The amount of ETH to receive.
            balanceOf(address(this)),
            path,
            msg.sender,
            block.timestamp
        );
    }
}
