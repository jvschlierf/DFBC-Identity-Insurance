// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.6;


contract Insurance{

    address payable us; // the address where we get the fees
    address payable customer;
    uint256 public amount;
    string public customer_name;
    string public property_address;
    address public owner;
    uint256 public payout;


    //mapping(address => uint) balance;

    constructor (address payable _first, address payable _second, string memory _customer, string memory _property_address, uint256 _payout) public {
        us = _first;
        owner = msg.sender;
        customer = _second;
        amount = 0;
        customer_name = _customer;
        property_address = _property_address;
        payout = _payout;
    }

    receive() external payable{
        require(msg.sender == customer && msg.value > 0);
        amount += msg.value;
    }


    function pay_out() public {
        require(msg.sender == owner);
        uint256 payout_amt = payout;
        payout = 0;
        amount -= payout_amt;
        (bool success, ) = customer.call{value : payout_amt}("");
        require(success, "Transfer failed.");
    }




}