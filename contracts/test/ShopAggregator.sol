// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Shop.sol";
import "../src/ShopAggregator.sol";

contract ShopAggregatorTest is Test {
    ShopAggregator public shopAggregator;

    function setUp() public {
        shopAggregator = new ShopAggregator();
    }

    function testAddShop() public {
        shopAggregator.addShop("Test Shop", "TSH", "https://testshop.com", "123 Test Street", "1234567890", msg.sender);
        assertEq(shopAggregator.shops(0), address(shopAggregator));
    }

    function testGetAllShops() public {
        assertEq(shopAggregator.getAllShops().length, 1);
    }

    function testRemoveShop() public {
        address shopAddress = shopAggregator.shops(0);
        shopAggregator.removeShop(shopAddress);
        assertEq(shopAggregator.getAllShops().length, 0);
    }
}
