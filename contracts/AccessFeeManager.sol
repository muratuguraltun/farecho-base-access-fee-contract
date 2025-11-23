// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AccessFeeManager {
    address public owner;
    uint256 public constant ACCESS_PRICE = 0.00005 ether;

    event AccessPaid(address indexed user, uint256 amount);
    event Withdraw(address indexed to, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function payAccess() external payable {
        require(msg.value == ACCESS_PRICE, "Must pay exactly 0.00005 ETH");
        emit AccessPaid(msg.sender, msg.value);
    }

    function withdrawAll() external {
        require(msg.sender == owner, "Not owner");
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance");
        payable(owner).transfer(balance);
        emit Withdraw(owner, balance);
    }
}
