// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*
编写一个 TokenBank 合约，可以将自己的 Token 存入到 TokenBank， 和从 TokenBank 取出。

TokenBank 有两个方法：

deposit() : 需要记录每个地址的存入数量；
withdraw（）: 用户可以提取自己的之前存入的 token，管理员可以提取所有的token。
*/

contract TokenBank {
    address owner;
    constructor() {
        owner = msg.sender;
    }

    mapping(address => uint) internal balances;

    function withdraw() external virtual {
        uint balance = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    event Received(address, uint);
    receive() external payable {
        balances[msg.sender] += msg.value;
        emit Received(msg.sender, msg.value);
    }

    event FallBacked(address, uint);
    fallback() external payable {
        emit FallBacked(msg.sender, msg.value);
    }
}
