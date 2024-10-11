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
• 管理员=合约创造者
*/
pragma solidity >=0.8.0;

contract Bank {
    address  owner;
    constructor()  {
       owner = msg.sender;
    }

    mapping(address => uint) internal balances;

    function CheckBalance(address key) public view returns (uint) {
        return balances[key];
    }

    function withdraw() public {
        if msg.sender == owner {
            uint balance = balances[msg.sender];
            balances[msg.sender] = 0;

            (bool success, ) = msg.sender.call{value: balance}("");
            require(success, "Failed to send Ether");
        } else {
            
        }

    }

    event Received(address, uint);
    receive() external payable {
        balances[msg.sender] += msg.value;
        getTop3Amounts(balances[msg.sender]);
        emit Received(msg.sender, msg.value);
    }

    event FallBacked(address, uint);
    fallback() external payable {
        emit FallBacked(msg.sender, msg.value);
    }

    int[3] top3Amounts;

    function getTop3Amounts(uint value) internal {
        int newValue = int(value);
        for (uint i = 0; i < top3Amounts.length; i++) {
            if (newValue > top3Amounts[i]) {
                for (uint j = top3Amounts.length - 1; j > i; j--) {
                    top3Amounts[j] = top3Amounts[j - 1];
                }
                top3Amounts[i] = newValue;
                break;
            }
        }
    }

    function Top3Balance() public view returns (int[3] memory) {
        return top3Amounts;
    }
}

