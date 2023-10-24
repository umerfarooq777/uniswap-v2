//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PairV2 {
    function balanceOf(address owner) external view returns (uint) {}

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast)
    {}
}
