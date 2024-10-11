//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract Bank {
    mapping(address => uint) public deposits;

    function deposit() public payable {
        deposits[msg.sender] += msg.value;
    }
}
