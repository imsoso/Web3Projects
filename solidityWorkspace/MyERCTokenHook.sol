// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./MyERCToken.sol";
/* 
扩展 ERC20 合约 ，添加一个有hook 功能的转账函数，如函数名为：transferWithCallback ，在转账时，如果目标地址是合约地址的话，调用目标地址的 tokensReceived() 方法。

继承 TokenBank 编写 TokenBankV2，支持存入扩展的 ERC20 Token，用户可以直接调用 transferWithCallback 将 扩展的 ERC20 Token 存入到 TokenBankV2 中。

（备注：TokenBankV2 需要实现 tokensReceived 来实现存款记录工作）
*/

contract MyERCTokenHook is BaseERC20 {
    // 转帐, recipient 可能是合约或者用户
    function transferWithCallback(
        address _to,
        uint256 _value
    ) external returns (bool) {
        require(
            balances[msg.sender] >= _value,
            "ERC20: transfer amount exceeds balance"
        );
        bool success = transfer(_to, _value);
        require(success, "transfer fail");
        // 是否是合约
        if (isContract(_to)) {
            // 调用目标合约的 tokensReceived() 方法
            (success, ) = _to.call(
                abi.encodeWithSignature(
                    "tokensReceived(address,uint256)",
                    msg.sender,
                    _value
                )
            );
            require(success, "tokensReceived fail");
        }

        return true;
    }

    function isContract(address addr) public view returns (bool) {
        return addr.code.length != 0;
    }
}
