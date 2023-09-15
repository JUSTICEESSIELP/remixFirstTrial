// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract FunctionsContract {
// return multiple values from a function

// you cannot use mapping as in input to a function 


    error InsufficientBalance(uint balance, uint withdrawAmount);

    function testCustomError(uint _withdrawAmount) public view {
        uint bal = address(this).balance;
        if (bal < _withdrawAmount) {
            revert InsufficientBalance({balance: bal, withdrawAmount: _withdrawAmount});
        }
    }



}