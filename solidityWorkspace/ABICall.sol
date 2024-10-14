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
