// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol';

contract Reserve3ERC721A is ERC721A, Ownable, ReentrancyGuard {

    uint256 public lastMint;
    IUniswapV3Pool public liquidityPool;
    uint256 public mintCost;
    uint256 public liquidityAddThreshold = 1 ether;

    mapping(address => uint) public balances;

    event AddLiquidity(uint256 amount, address pool);
    event ChangeLiquidityThreshold(uint256 amount);
    event ChangePool(address newPool);
    event CollectLP(uint256 timestamp);
    event Mint(address mintedBy, uint256 quantity);
    event Withdraw(address withdrawnBy, uint256 amount);

    modifier restrictMint {
        if (totalSupply() >= 333_333) {
            require(block.timestamp > lastMint + 360, "Supply limited to 10 mints per hour");
        }
        _;
    }

    constructor(
        address _liquidityPool) 
    ERC721A("Reserve3 NFT", "R3N") {
        mintCost = 0.1 ether;
        liquidityPool = IUniswapV3Pool(_liquidityPool);
    }

    function _addLiquidity() internal {
        uint256 amount = balances[address(this)];
        balances[address(this)] = 0;
        
        //calculate how much to swap

        //add liquidity

        //emit event
        emit AddLiquidity(amount, address(liquidityPool));
    }

    function change(address _liquidityPool) external onlyOwner {
        //extract assets out of old pool
        //**************************** */

        //set new pool
        liquidityPool = IUniswapV3Pool(_liquidityPool);

        //emit event
        emit ChangePool(_liquidityPool);

        //add liquidity to new pool
        _addLiquidity();
    }

    function collect() external onlyOwner {
        liquidityPool.collect(address(this), 0, type(int24).max, type(uint128).max, type(uint128).max);
    }

    function mint(uint256 quantity) external payable nonReentrant restrictMint {
        require(msg.value == mintCost * quantity, "Tx value must match mint cost * value");
        if (totalSupply() >= 50_000) {
            require(quantity == 1, "Supply limited to 10 mints per hour");
        }
        _mint(msg.sender, quantity);
        lastMint = block.timestamp;
        
        //deduct platform fee - 1%
        uint256 platformFee = msg.value / 100;
        balances[owner()] += platformFee;
        
        //credit contract investment balance
        balances[address(this)] += msg.value - platformFee;

        //Add liquidity when threshold has been reached
        if (balances[address(this)] > liquidityAddThreshold) {
            _addLiquidity();
        }
    }

    function setLiquidityAddThreshold(uint256 value) external onlyOwner {
        //change threshold
        liquidityAddThreshold = value;

        //emit event
        emit ChangeLiquidityThreshold(value);
    }

    function withdraw() external payable nonReentrant {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "You do not have any distributions due");

        //transfer balance to sender
        payable(msg.sender).transfer(amount);
        balances[msg.sender] = 0;

        //emit event
        emit Withdraw(msg.sender, amount);
    }
}