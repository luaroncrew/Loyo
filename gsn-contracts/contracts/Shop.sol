// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@opengsn/contracts/src/ERC2771Recipient.sol";

contract Shop is ERC20, Ownable, ERC2771Recipient {
    string public shopWebsite;
    string public shopAddress;
    string public shopPhoneNumber;

    constructor(
        string memory name,
        string memory symbol,
        string memory _shopWebsite,
        string memory _shopAddress,
        string memory _shopPhoneNumber,
        address _forwarder
    ) ERC20(name, symbol) {
        shopWebsite = _shopWebsite;
        shopAddress = _shopAddress;
        shopPhoneNumber = _shopPhoneNumber;
        _setTrustedForwarder(_forwarder);
    }

    function registerUser(address user, uint256 amount) public {
        _mint(user, amount);
    }

    function deleteUser(address user) public {
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

    function creditUser(address user, uint256 amount) public {
        _mint(user, amount);
    }

    function _msgData()
        internal
        view
        override(ERC2771Recipient, Context)
        returns (bytes calldata ret)
    {
        return ERC2771Recipient._msgData();
    }

    function _msgSender()
        internal
        view
        override(ERC2771Recipient, Context)
        returns (address ret)
    {
        return ERC2771Recipient._msgSender();
    }
}
