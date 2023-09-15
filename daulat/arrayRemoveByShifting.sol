// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ShiftingThenDelete {
    uint256[] public arr;

    function remove(uint256 _index)
        public
        returns(uint256[] memory)
        
        
    {
        require(_index < arr.length, "Index out of bounds");
        require(arr.length > 0, "Array is empty");

        // Swap the element to be removed by the elements in front of it and do that recursively then pop 
        for(uint256 i = _index; i < arr.length -1 ; i++){
            arr[i] = arr[i+1];
        }
    
        // Decrease the array's length to remove the last element
        arr.pop();

        uint256[] memory newArray = new uint256[](arr.length);
        for (uint256 i = 0; i < arr.length; i++) {
            newArray[i] = arr[i];
        }

        return newArray;
    }

    function changeArrayState(uint256[] memory _arr) public {
        arr = _arr;
    }

    //   swap the element you want to delete with the last element in the array and then pop ... since delete arr[i]
    // wont delete but just change the value to zero and maintain the length of the array

    function removeByReplacingWithLastIndex(uint256 _index)
        public
        returns (uint256[] memory)
    {
        require(_index < arr.length, "Index out of bounds");
        require(arr.length > 0, "Array is empty");

        arr[_index] = arr[arr.length - 1];
        arr.pop();
        uint256[] memory newArray = new uint256[](arr.length);
        for (uint256 i = 0; i < newArray.length; i++) {
            newArray[i] = arr[i];
        }

        return newArray;
    }

    function getArray() public view returns (uint256[] memory) {
        return arr;
    }
}
