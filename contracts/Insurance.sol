// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Insurance{

    address payable us; // the address where we get the fees
    address payable customer;
    uint256 public amount;
    string public customer_name;
    string public property_address;
    address public owner;
    uint256 public payout;
    bool payout_flag;

    constructor (address payable _first, address payable _second, string memory _customer, string memory _property_address, uint256 _payout) public {
        us = _first;
        owner = msg.sender;
        customer = _second;
        amount = 0;
        customer_name = _customer;
        property_address = _property_address;
        payout = _payout;
        payout_flag = false;
    }

    receive() external payable{
        require(msg.sender == customer && msg.value > 0);
        amount += msg.value;
    }


    function pay_out() public {
        require(msg.sender == owner && payout_flag == true);
        uint256 payout_amt = payout;
        payout = 0;
        amount -= payout_amt;
        (bool success, ) = customer.call{value : payout_amt}("");
        require(success, "Transfer failed.");
    }

    function set_flag() public{
        require(msg.sender == owner);
		payout_flag = true;
    }

}