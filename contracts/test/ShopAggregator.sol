// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Shop.sol";
import "../src/ShopAggregator.sol";

contract ShopAggregatorTest is Test {
    ShopAggregator public shopAggregator;
    address public shopAddress;

    function setUp() public {
        shopAggregator = new ShopAggregator();
        shopAggregator.addShop(
            "Test Shop",
            "TSH",
            "https://testshop.com",
            "123 Test Street",
            "1234567890",
            msg.sender,
            address(0)
        );
        shopAddress = shopAggregator.shops(0);
    }

    function testAddShop() public {
        assertEq(shopAddress, address(Shop(shopAddress)));
    }

    function testGetAllShops() public {
        address[] memory shops = shopAggregator.getAllShops();
        assertEq(shops.length, 1);
        assertEq(shops[0], shopAddress);
    }

    function testRemoveShop() public {
        shopAggregator.removeShop(shopAddress);
        address[] memory shops = shopAggregator.getAllShops();
        assertEq(shops.length, 0);
    }
}
