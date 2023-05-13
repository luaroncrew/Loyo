// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Shop.sol";
import "../src/ShopAggregator.sol";

contract ShopTest is Test {
    Shop public shop;

    function setUp() public {
        shop = new Shop(
            "Test Shop",
            "TSH",
            "https://testshop.com",
            "123 Test Street",
            "1234567890"
        );
    }

    function testRegisterUser() public {
        shop.registerUser(msg.sender, 100);
        assertEq(shop.balanceOf(msg.sender), 100);
    }

    function testDeleteUser() public {
        shop.registerUser(msg.sender, 100);
        shop.deleteUser(msg.sender);
        assertEq(shop.balanceOf(msg.sender), 0);
    }

    function testUpdateMetadata() public {
        shop.updateMetadata(
            "https://newtestshop.com",
            "456 Test Street",
            "9876543210"
        );
        assertEq(shop.shopWebsite(), "https://newtestshop.com");
        assertEq(shop.shopAddress(), "456 Test Street");
        assertEq(shop.shopPhoneNumber(), "9876543210");
    }

    function testCreditUser() public {
        shop.creditUser(msg.sender, 200);
        assertEq(shop.balanceOf(msg.sender), 200);
    }
}
