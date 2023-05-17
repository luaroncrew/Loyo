// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ShopAggregator.sol";

contract ShopAggregatorScript is Script {
    function setUp() public {}

    function run() public {
        // DO NOT USE THE REAL PRIVATE KEY
        uint256 deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        vm.broadcast(deployerPrivateKey);
        new ShopAggregator();
        vm.stopBroadcast();
    }
}
