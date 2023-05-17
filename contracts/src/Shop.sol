// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Shop is ERC20, Ownable {
    string public shopWebsite;
    string public shopAddress;
    string public shopPhoneNumber;

    constructor(
        string memory name,
        string memory symbol,
        string memory _shopWebsite,
        string memory _shopAddress,
        string memory _shopPhoneNumber
    ) ERC20(name, symbol) {
        shopWebsite = _shopWebsite;
        shopAddress = _shopAddress;
        shopPhoneNumber = _shopPhoneNumber;
    }

    function registerUser(address user, uint256 amount) public onlyOwner {
        _mint(user, amount);
    }

    function deleteUser(address user) public onlyOwner {
        _burn(user, balanceOf(user));
    }

    function updateMetadata(
        string memory _shopWebsite,
        string memory _shopAddress,
        string memory _shopPhoneNumber
    ) public onlyOwner {
        shopWebsite = _shopWebsite;
        shopAddress = _shopAddress;
        shopPhoneNumber = _shopPhoneNumber;
    }

    function creditUser(address user, uint256 amount) public onlyOwner {
        _mint(user, amount);
    }
}
