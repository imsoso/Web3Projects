// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*
编写一个 TokenBank 合约，可以将自己的 Token 存入到 TokenBank， 和从 TokenBank 取出。

TokenBank 有两个方法：

deposit() : 需要记录每个地址的存入数量；
withdraw（）: 用户可以提取自己的之前存入的 token，管理员可以提取所有的token。
*/
import "./MyERCToken.sol";

contract TokenBank is BaseERC20 {
    address admin;
    BaseERC20 public token;

    mapping(address => uint) internal balances;

    constructor(BaseERC20 _token) {
        admin = msg.sender;
        token = _token;
    }

    function withdraw() external virtual {
        uint balance = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");
    }

    function deposit(uint256 amount) public {
        // 将用户的 token 转移到 TokenBank 合约中
        bool success = token.transferFrom(msg.sender, address(this), amount);
        require(success, "Token transfer failed");

        // 记录用户的存款
        balances[msg.sender] += amount;
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
