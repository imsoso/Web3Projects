pragma solidity ^0.8.0;

contract DataStorage {
    string private data;

    function setData(string memory newData) public {
        data = newData;
    }

    function getData() public view returns (string memory) {
        return data;
    }
}

contract DataConsumer {
    address private dataStorageAddress;

    constructor(address _dataStorageAddress) {
        dataStorageAddress = _dataStorageAddress;
    }

    function getDataByABI() public returns (string memory) {
        bytes4 selector = bytes4(keccak256("getData()"));
        bytes memory payload = abi.encode(selector);
        (bool success, bytes memory data) = dataStorageAddress.call(payload);
        require(success, "call function failed");
        return abi.decode(data, (string));
    }

    function setDataByABI1(string calldata newData) public returns (bool) {
        bytes memory payload = abi.encodeWithSignature(
            "setData(string)",
            newData
        );
        (bool success, ) = dataStorageAddress.call(payload);

        return success;
    }

    function setDataByABI2(string calldata newData) public returns (bool) {
        bytes4 selector = bytes4(keccak256("setData(string)"));
        bytes memory payload = abi.encodeWithSelector(selector, newData);
        (bool success, ) = dataStorageAddress.call(payload);

        return success;
    }

    function setDataByABI3(string calldata newData) public returns (bool) {
        bytes memory payload = abi.encodeCall(DataStorage.setData, newData);
        (bool success, ) = dataStorageAddress.call(payload);
        return success;
    }
}

// contract Callee {
//     function getData() public pure returns (uint256) {
//         return 42;
//     }
// }

// // contract Caller {
//     function callGetData(address callee) public view returns (uint256 data) {
//         /// 构造调用数据 (getData 函数的函数选择器)
//         bytes memory dataToCall = abi.encodeWithSignature("getData()");

//         // 使用 staticcall 调用 Callee 合约的 getData 函数
//         (bool success, bytes memory result) = callee.staticcall(dataToCall);

//         // 检查调用是否成功
//         require(success, "staticcall function failed");

//         // 将返回的字节数据解码为 uint256
//         data = abi.decode(result, (uint256));
//     }
// }

// contract Caller {
//     function sendEther(address to, uint256 value) public returns (bool) {
//         // 使用 call 发送 ether
//         (bool success, ) = to.call{value: value}("");
//         require(success, "sendEther failed");

//         return success;
//     }

//     receive() external payable {}
// }

// contract Callee {
//     uint256 value;

//     function getValue() public view returns (uint256) {
//         return value;
//     }

//     function setValue(uint256 value_) public payable {
//         require(msg.value > 0);
//         value = value_;
//     }
// }

// contract Caller {
//     function callSetValue(address callee, uint256 value) public returns (bool) {
//         bytes memory dataToCall = abi.encodeWithSignature(
//             "setValue(uint256)",
//             value
//         );
//         (bool success, ) = callee.call{value: 1 ether}(dataToCall);

//         require(success, "call function failed");
//         return success;
//     }
// }

contract Callee {
    uint256 public value;

    function setValue(uint256 _newValue) public {
        value = _newValue;
    }
}

contract Caller {
    uint256 public value;

    function delegateSetValue(address callee, uint256 _newValue) public {
        bytes memory dataToCall = abi.encodeWithSignature(
            "setValue(uint256)",
            _newValue
        );
        (bool success, ) = callee.delegatecall(dataToCall);

        require(success, "delegate call failed");
    }
}
