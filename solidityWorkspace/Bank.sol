//SPDX-License-Identifier: MIT
/*
• 通过 Metamask 向Bank合约存款（转账ETH）
• 在Bank合约记录每个地址存款⾦额
• ⽤数组记录存款⾦额前 3 名
• 编写 Bank合约 withdraw(), 实现只有管理员提取出所有的 ETH

• 理解合约作为⼀个账号、也可以持有资产
• msg.value / 如何传递 Value
• 回调函数的理解（receive/fallback）
• Payable 关键字理解
• Mapping 、数组使⽤
*/
pragma solidity >=0.8.0;

contract Bank {
    mapping(address => uint) public balances;

    function get(address key) public view returns (uint) {
        return balances[key];
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
