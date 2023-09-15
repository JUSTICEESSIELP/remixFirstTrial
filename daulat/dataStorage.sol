// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ArrayContract {
    uint[] public arr;
    mapping(uint => address) numberToAddress;
    struct MyStruct{
        uint foo;
    }

    mapping(uint => MyStruct) allMyStruct;

    function manipulate() view public {
      
    }

}