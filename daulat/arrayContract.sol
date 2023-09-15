// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ArrayContract {

 uint[] public arr;
 mapping(address => uint256) public addressToAmount;

 function example() view external{
     uint256[] memory a = new uint256[](5);
   
    a[0] = 1;
    a[1]= 2;
    a[2] = 3;
    a[3] = 4;
    a[4] = 5;
 }

 

//  or you can run a loop
function getBalancesOfMultipleUsers (address[] memory _users) view external returns(uint256[] memory){
    uint256[] memory balances = new uint256[](_users.length);
    for(uint256 i = 0; i<_users.length; i++){
         balances[i] = addressToAmount[_users[i]];
         return balances;


    }
   

}


 

}