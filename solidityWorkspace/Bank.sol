//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract Bank {
    mapping(address => uint) public deposits;
    mapping(address => uint) public balances;

    function deposit() public payable {
        deposits[msg.sender] += msg.value;
    }

    function update(uint newBalance) public {
        balances[msg.sender] = newBalance;
    }

    function get(address key) public view returns (uint) {
        return balances[key];
    }
}
