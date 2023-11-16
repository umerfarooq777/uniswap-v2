// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";

// import "hardhat/console.sol";

contract DEFTOKEN is ERC20, Ownable {
    address public UNISWAP_V2_ROUTER; //0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
    address public FACTORY; //0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f

    address public constant WETH_ADDRESS =
        0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;

    IUniswapV2Factory factoryContract;
    IUniswapV2Router02 v2UniswapContract;

    uint256 public burnPercentage = 2; //0.2%
    uint256 public taxPercentage = 8; //0.8%

    mapping(address => bool) private isTaxExcluded;

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
        FACTORY = _factoryAddress;
        factoryContract = IUniswapV2Factory(FACTORY);
        UNISWAP_V2_ROUTER = _v2RouterAddress;
        v2UniswapContract = IUniswapV2Router02(UNISWAP_V2_ROUTER);
        factoryContract.createPair(address(this), WETH_ADDRESS);
    }

    function getPoolAddress() public view returns (address pair) {
        return factoryContract.getPair(address(this), WETH_ADDRESS);
    }

    function addressIsExcluded(address _add) public view returns (bool res) {
        return isTaxExcluded[_add];
    }

    function getLPTokens(address _LPprovider) public view returns (uint256) {
        address pairAddress = getPoolAddress();
        return IUniswapV2Pair(pairAddress).balanceOf(_LPprovider);
    }

    function getPoolReserves()
        public
        view
        returns (
            //!========will be removed
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        )
    {
        address _poolAddress = getPoolAddress();
        return IUniswapV2Pair(_poolAddress).getReserves();
    }

    function calFee(
        uint256 amount,
        uint256 percentage
    ) internal pure returns (uint256) {
        require(amount>=1000,"amount cant be less than 1000");
        return (amount * percentage) / 1000;
    }

    function setBurnPercentage(uint256 newFee) public onlyOwner {
        require(newFee > 0 && newFee <= 250, "can't be 0 or greater than 250");
        require(newFee != burnPercentage, "can't be old value");
        burnPercentage = newFee;
    }

    function setTaxPercentage(uint256 newFee) public onlyOwner {
        require(newFee > 0 && newFee <= 250, "can't be 0 or greater than 250");
        require(newFee != taxPercentage, "can't be old value");
        taxPercentage = newFee;
    }

    function setIsTaxExcluded(
        address[] memory _newAddressess,
        bool _access
    ) public onlyOwner {
        for (uint i; i < _newAddressess.length; i++) {
            if (isTaxExcluded[_newAddressess[i]] != _access) {
                isTaxExcluded[_newAddressess[i]] = _access;
            }
        }
    }

    function getTransferedTokenAmount(
        uint256 _amount
    ) internal view returns (uint256 transferedAmount) {
        uint256 taxAmount = 0;
        uint256 burnAmount = 0;
        if (!isTaxExcluded[_msgSender()]) {
            taxAmount = calFee(_amount, taxPercentage);
            burnAmount = calFee(_amount, burnPercentage);
        }
        return
            !isTaxExcluded[_msgSender()]
                ? _amount - (burnAmount + taxAmount)
                : _amount;
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

    function getInputAmount(
        uint256 _amountOut,
        address _tokenOut
    ) public view returns (uint[] memory amounts) {
        address[] memory path = new address[](2);
        if (_tokenOut != address(this) && _tokenOut != WETH_ADDRESS) {
            revert("invalid token in address");
        } else if (_tokenOut == address(this)) {
            //!===== Work In Progress
            path[0] = WETH_ADDRESS; //output token
            path[1] = address(this);
        } else {
            path[0] = address(this); //output token
            path[1] = WETH_ADDRESS;
        }
        return v2UniswapContract.getAmountsIn(_amountOut, path);
    }

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

    function addLiquidityETHToPool(uint256 _amountA) external payable {
        require(_amountA > 0, "Insufficient Token amount");
        require(
            balanceOf(_msgSender()) >= _amountA,
            "Insufficient user token balance"
        );
        IERC20(address(this)).transferFrom(
            _msgSender(),
            address(this),
            _amountA
        );

        uint256 transferedAmount = getTransferedTokenAmount(_amountA);

        if (allowance(address(this), UNISWAP_V2_ROUTER) == 0) {
            IERC20(address(this)).approve(UNISWAP_V2_ROUTER, type(uint256).max);
        }
        (, , uint liquidity) = v2UniswapContract.addLiquidityETH{
            value: msg.value
        }(address(this), transferedAmount, 0, 0, msg.sender, block.timestamp);
        emit LiquidityAdded(_msgSender(), liquidity, block.timestamp);
    }

    function removeLiquidityETHToPool(uint256 _amountLP) external {
        address pairAddress = getPoolAddress();
        require(_amountLP > 0, "Insufficient LP Token amount");
        require(
            IUniswapV2Pair(pairAddress).balanceOf(_msgSender()) >= _amountLP,
            "Insufficient User LP Token Balance"
        );
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

    function withDrawTaxCollection() external onlyOwner {
        require(
            balanceOf(address(this)) > 0,
            "Insufficient Tax Token collected"
        );

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WETH_ADDRESS;

        uint[] memory amounts = v2UniswapContract.swapExactTokensForETH(
            balanceOf(address(this)),
            0, //The amount of ETH to receive.
            path,
            address(this),
            block.timestamp
        );

        emit TokenSwaped(
            address(this),
            WETH_ADDRESS,
            amounts[amounts.length - 1],
            address(this),
            balanceOf(address(this)),
            block.timestamp
        );
    }

    function swapTokenWithEth(uint256 _tokenAmount) external {
        require(_tokenAmount > 0, "Insufficient Token amount");
        require(
            balanceOf(_msgSender()) >= _tokenAmount,
            "Insufficient user token balance"
        );
        IERC20(address(this)).transferFrom(
            _msgSender(),
            address(this),
            _tokenAmount
        );

        uint256 transferedAmount = getTransferedTokenAmount(_tokenAmount);

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WETH_ADDRESS;

        uint[] memory amounts = getReturnAmount(transferedAmount, path[0]);

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
            amounts[amounts.length - 1],
            address(this),
            transferedAmount,
            block.timestamp
        );
    }

    function swapEthWithToken() external payable {
        require(msg.value > 0, "Insufficient funds tranfered");

        address[] memory path = new address[](2);
        path[0] = WETH_ADDRESS;
        path[1] = address(this);
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
            amounts[amounts.length - 1],
            WETH_ADDRESS,
            msg.value,
            block.timestamp
        );
    }

    receive() external payable {}

    fallback() external payable {}
}
//0xA4DeF42d5dFB3833294DB7D9305ADF9d11d1E840 1st deploy goerli | subgraph https://api.studio.thegraph.com/query/57860/def-token/0.0.1
//0xBFdEdA659797Ef1A567F9Dc650cBb3948B1432b7 2nd deploy