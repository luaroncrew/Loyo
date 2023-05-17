// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Shop.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ShopAggregator is Ownable {
    address[] public shops;

    function addShop(
        string memory name,
        string memory symbol,
        string memory shopWebsite,
        string memory shopAddress,
        string memory shopPhoneNumber,
        address shopOwner
    ) public onlyOwner {
        Shop newShop = new Shop(
            name,
            symbol,
            shopWebsite,
            shopAddress,
            shopPhoneNumber
        );
        newShop.transferOwnership(shopOwner);
        shops.push(address(newShop));
    }

    function getAllShops() public view returns (address[] memory) {
        return shops;
    }

    function removeShop(address shopAddress) public onlyOwner {
        for (uint i = 0; i < shops.length; i++) {
            if (shops[i] == shopAddress) {
                shops[i] = shops[shops.length - 1];
                shops.pop();
                return;
            }
        }
    }
}
