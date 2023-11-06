// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// import "../interfaces/Uniswap.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";

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
        _mint(address(this), 10 * 10 ** decimals());
        IUniswapV2Factory(FACTORY).createPair(address(this), WETH_ADDRESS);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function getPoolAddress() public view returns (address pair) {
        return IUniswapV2Factory(FACTORY).getPair(address(this), WETH_ADDRESS);
    }

    function getLPTokens(address _LPprovider) public view returns (uint256) {
        address pairAddress = getPoolAddress();
        return IUniswapV2Pair(pairAddress).balanceOf(_LPprovider);
    }

    function getPoolReserves()
        public
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast)
    {
        address _poolAddress = getPoolAddress();
        return IUniswapV2Pair(_poolAddress).getReserves();
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
        require(_amountA > 0, "Insufficient Token amount");
        IERC20(address(this)).transferFrom(
            _msgSender(),
            address(this),
            _amountA
        );
        uint256 taxAmount = calFee(_amountA, taxPercentage);
        uint256 burnAmount = calFee(_amountA, burnPercentage);
        uint256 transferedAmount = _amountA - (burnAmount + taxAmount);
        if (allowance(address(this), UNISWAP_V2_ROUTER) == 0) {
            IERC20(address(this)).approve(UNISWAP_V2_ROUTER, type(uint256).max);
        }
        IUniswapV2Router02(UNISWAP_V2_ROUTER).addLiquidityETH{value: msg.value}(
            address(this),
            transferedAmount,
            0,
            0,
            msg.sender,
            block.timestamp
        );
    }

    function removeLiquidityETHToPool(uint256 _amountLP) external {
        address pairAddress = getPoolAddress();
        IUniswapV2Pair(pairAddress).transferFrom(
            _msgSender(),
            address(this),
            _amountLP
        );
        if (
            IUniswapV2Pair(pairAddress).allowance(
                pairAddress,
                UNISWAP_V2_ROUTER
            ) == 0
        ) {
            IUniswapV2Pair(pairAddress).approve(
                UNISWAP_V2_ROUTER,
                type(uint256).max
            );
        }
        IUniswapV2Router02(UNISWAP_V2_ROUTER)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                address(this),
                _amountLP, //liquidity
                0,
                0,
                msg.sender,
                block.timestamp
            );
    }

    function ApproveMaxTokens() external {
        approve(address(this), type(uint256).max);
    }

    function ApproveMaxLPTokens() external {
        address pairAddress = getPoolAddress();
        IUniswapV2Pair(pairAddress).approve(msg.sender, type(uint256).max);
    }

    function withDrawTaxCollection() external onlyOwner {
        require(balanceOf(address(this)) > 0, "Insufficient Tax collected");
        if (allowance(address(this), UNISWAP_V2_ROUTER) == 0) {
            IERC20(address(this)).approve(UNISWAP_V2_ROUTER, type(uint256).max);
        }
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WETH_ADDRESS;
        IUniswapV2Router02(UNISWAP_V2_ROUTER)
            .swapExactTokensForETHSupportingFeeOnTransferTokens(
                balanceOf(address(this)),
                0, //The amount of ETH to receive.
                path,
                address(this),
                block.timestamp
            );
    }

    function swapTokenWithEth(uint256 _tokenAmount) external {
        require(_tokenAmount > 0, "Insufficient Token amount");
        require(balanceOf(_msgSender()) > 0, "Insufficient user token balance");
        IERC20(address(this)).transferFrom(
            _msgSender(),
            address(this),
            _tokenAmount
        );
        uint256 taxAmount = calFee(_tokenAmount, taxPercentage);
        uint256 burnAmount = calFee(_tokenAmount, burnPercentage);
        uint256 transferedAmount = _tokenAmount - (burnAmount + taxAmount);
        if (allowance(address(this), UNISWAP_V2_ROUTER) == 0) {
            IERC20(address(this)).approve(UNISWAP_V2_ROUTER, type(uint256).max);
        }

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WETH_ADDRESS;
        IUniswapV2Router02(UNISWAP_V2_ROUTER)
            .swapExactTokensForETHSupportingFeeOnTransferTokens(
                transferedAmount,
                0, //The amount of ETH to receive.
                path,
                _msgSender(),
                block.timestamp
            );
    }

    function swapEthWithToken() external payable {
        require(msg.value > 0, "Insufficient funds tranfered");

        if (allowance(address(this), UNISWAP_V2_ROUTER) == 0) {
            IERC20(address(this)).approve(UNISWAP_V2_ROUTER, type(uint256).max);
        }

        address[] memory path = new address[](2);
        path[0] = WETH_ADDRESS;
        path[1] = address(this);
        IUniswapV2Router02(UNISWAP_V2_ROUTER).swapExactETHForTokens{
            value: msg.value
        }(
            0, //The minimum amount of output tokens that must be received for the transaction not to revert.
            path,
            _msgSender(),
            block.timestamp
        );
    }

    receive() external payable {}

    fallback() external payable {}
}

//98999999999999999000 LP 1st
// 90000000000000000000 LP 2nd after 8999999999999999000 LP remove from pool
