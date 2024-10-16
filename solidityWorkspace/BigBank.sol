// SPDX-License-Identifier: MIT
/* 
编写 IBank 接口及BigBank 合约，使其满足 Bank 实现 IBank， BigBank 继承自 Bank ， 同时 BigBank 有附加要求：
要求存款金额 >0.001 ether（用modifier权限控制）
BigBank 合约支持转移管理员

编写一个 Admin 合约， Admin 合约有自己的 Owner ，同时有一个取款函数 adminWithdraw(IBank bank) , adminWithdraw 中会调用 IBank 接口的 withdraw 方法从而把 bank 合约内的资金转移到 Admin 合约地址。
BigBank 和 Admin 合约 部署后，把 BigBank 的管理员转移给 Admin 合约地址，模拟几个用户的存款，然后
Admin 合约的Owner地址调用 adminWithdraw(IBank bank) 把 BigBank 的资金转移到 Admin 地址。
*/
pragma solidity >=0.8.0;
import "./Bank.sol";

contract BigBank is Bank {
    modifier leastEther() {
        require(msg.value >= 0.001 ether);
        _;
    }

    function Deposit() external payable leastEther {
        balances[msg.sender] += msg.value;
    }

    function transferAdminPrivilege(address newAdmin) external {
        owner = newAdmin;
    }

    function withdraw() external override {
        require(msg.sender == owner, "Only admin can withdraw");
        uint balance = address(this).balance;
        (bool success, ) = owner.call{value: balance}("");
        require(success, "Failed to send Ether");
    }
}

contract Admin {
    address owner;
    constructor() {
        owner = msg.sender;
    }

    function adminWithdraw(BigBank bank) external {
        require(msg.sender == owner, "Only admin can withdraw");
        bank.withdraw();
    }

    event Received(address, uint);
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    event FallBacked(address, uint);
    fallback() external payable {
        emit FallBacked(msg.sender, msg.value);
    }
}
