// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";

// import "hardhat/console.sol";

contract TokenContract2 is ERC20, Ownable {
    address public UNISWAP_V2_ROUTER;
    address public FACTORY;

    address public constant WETH_ADDRESS =
        0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;

    IUniswapV2Factory factoryContract;
    IUniswapV2Router02 v2UniswapContract;

    uint8 public burnPercentage = 2; //0.2%
    uint8 public taxPercentage = 8; //0.8%
    mapping(address => bool) isTaxExcluded;
    event LiquidityAdded(
        address indexed _from,
        uint256 _mintedLiquidity,
        uint256 _time
    );
    event LiquidityRemoved(
        address indexed _from,
        uint256 _removedLiquidity,
        uint256 _time
    );
    event TokenSwaped(
        address indexed _swaper,
        address _tokenRecieved,
        uint256 _amountRecieved,
        address _tokenSent,
        uint256 _amountSent,
        uint256 _time
    );

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _amount,
        address _factoryAddress,
        address _v2RouterAddress
    ) ERC20(_name, _symbol) Ownable(msg.sender) {
        _mint(msg.sender, _amount * 10 ** decimals());
        _mint(address(this), 10 * 10 ** decimals());
        isTaxExcluded[address(this)] = true;
        isTaxExcluded[_msgSender()] = true;
        isTaxExcluded[UNISWAP_V2_ROUTER] = true;
        FACTORY = _factoryAddress;
        UNISWAP_V2_ROUTER = _v2RouterAddress;
        factoryContract = IUniswapV2Factory(_factoryAddress);
        v2UniswapContract = IUniswapV2Router02(_v2RouterAddress);
        factoryContract.createPair(address(this), WETH_ADDRESS);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function getPoolAddress() public view returns (address pair) {
        return factoryContract.getPair(address(this), WETH_ADDRESS);
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

    function getReturnAmount(
        uint256 _amountIn,
        address _tokenIn
    ) public view returns (uint[] memory amounts) {
        address[] memory path = new address[](2);
        if (_tokenIn != address(this) && _tokenIn != WETH_ADDRESS) {
            revert("invalid token in address");
        } else if (_tokenIn == address(this)) {
            path[0] = address(this);
            path[1] = WETH_ADDRESS; //output token
        } else {
            path[0] = WETH_ADDRESS;
            path[1] = address(this); //output token
        }
        return v2UniswapContract.getAmountsOut(_amountIn, path);
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
        uint256 taxAmount = 0;
        uint256 burnAmount = 0;
        if (!isTaxExcluded[_msgSender()]) {
            taxAmount = calFee(_amount, taxPercentage);
            burnAmount = calFee(_amount, burnPercentage);
            super.transfer(address(this), taxAmount);
            _burn(_msgSender(), burnAmount);
        }

        super.transfer(
            _to,
            !isTaxExcluded[_msgSender()]
                ? _amount - (burnAmount + taxAmount)
                : _amount
        );
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) public override returns (bool) {
        uint256 taxAmount = 0;
        uint256 burnAmount = 0;
        if (!isTaxExcluded[_from]) {
            taxAmount = calFee(_amount, taxPercentage);
            burnAmount = calFee(_amount, burnPercentage);
            _burn(_from, burnAmount);
            super.transferFrom(_from, address(this), taxAmount);
        }
        super.transferFrom(
            _from,
            _to,
            !isTaxExcluded[_from] ? _amount - (burnAmount + taxAmount) : _amount
        );
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

        uint256 taxAmount = 0;
        uint256 burnAmount = 0;
        if (!isTaxExcluded[_msgSender()]) {
            taxAmount = calFee(_amountA, taxPercentage);
            burnAmount = calFee(_amountA, burnPercentage);
        }
        uint256 transferedAmount = !isTaxExcluded[_msgSender()]
            ? _amountA - (burnAmount + taxAmount)
            : _amountA;
        if (allowance(address(this), UNISWAP_V2_ROUTER) == 0) {
            IERC20(address(this)).approve(UNISWAP_V2_ROUTER, type(uint256).max);
        }
        // (uint amountToken, uint amountETH, uint liquidity)=v2UniswapContract.addLiquidityETH{value: msg.value}(
        (, , uint liquidity) = v2UniswapContract.addLiquidityETH{
            value: msg.value
        }(address(this), transferedAmount, 0, 0, msg.sender, block.timestamp);
        emit LiquidityAdded(_msgSender(), liquidity, block.timestamp);
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
        v2UniswapContract.removeLiquidityETHSupportingFeeOnTransferTokens(
            address(this),
            _amountLP, //liquidity
            0,
            0,
            msg.sender,
            block.timestamp
        );

        emit LiquidityRemoved(_msgSender(), _amountLP, block.timestamp);
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
        uint256 oldBalance = _msgSender().balance;
        v2UniswapContract.swapExactTokensForETHSupportingFeeOnTransferTokens(
            balanceOf(address(this)),
            0, //The amount of ETH to receive.
            path,
            _msgSender(),
            block.timestamp
        );

        emit TokenSwaped(
            _msgSender(),
            WETH_ADDRESS,
            _msgSender().balance - oldBalance,
            address(this),
            balanceOf(address(this)),
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

        uint256 taxAmount = 0;
        uint256 burnAmount = 0;
        if (!isTaxExcluded[_msgSender()]) {
            taxAmount = calFee(_tokenAmount, taxPercentage);
            burnAmount = calFee(_tokenAmount, burnPercentage);
        }
        uint256 transferedAmount = !isTaxExcluded[_msgSender()]
            ? _tokenAmount - (burnAmount + taxAmount)
            : _tokenAmount;
        if (allowance(address(this), UNISWAP_V2_ROUTER) == 0) {
            IERC20(address(this)).approve(UNISWAP_V2_ROUTER, type(uint256).max);
        }

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WETH_ADDRESS;
        uint256 oldBalance = _msgSender().balance;

        v2UniswapContract.swapExactTokensForETHSupportingFeeOnTransferTokens(
            transferedAmount,
            0, //The amount of ETH to receive.
            path,
            _msgSender(),
            block.timestamp
        );

        emit TokenSwaped(
            _msgSender(),
            WETH_ADDRESS,
            _msgSender().balance - oldBalance,
            address(this),
            transferedAmount,
            block.timestamp
        );
    }

    function swapEthWithToken() external payable returns (uint[] memory) {
        require(msg.value > 0, "Insufficient funds tranfered");

        if (allowance(address(this), UNISWAP_V2_ROUTER) == 0) {
            IERC20(address(this)).approve(UNISWAP_V2_ROUTER, type(uint256).max);
        }

        address[] memory path = new address[](2);
        path[0] = WETH_ADDRESS;
        path[1] = address(this);
        uint256 oldBalance = balanceOf(_msgSender());
        uint[] memory amounts = v2UniswapContract.swapExactETHForTokens{
            value: msg.value
        }(
            0, //The minimum amount of output tokens that must be received for the transaction not to revert.
            path,
            _msgSender(),
            block.timestamp
        );
        emit TokenSwaped(
            _msgSender(),
            address(this),
            balanceOf(_msgSender()) - oldBalance,
            WETH_ADDRESS,
            msg.value,
            block.timestamp
        );
        // console.log("amounts",amounts);
        return amounts;
    }

    receive() external payable {}

    fallback() external payable {}
}

//98999999999999999000 LP 1st
// 90000000000000000000 LP 2nd after 8999999999999999000 LP remove from pool
