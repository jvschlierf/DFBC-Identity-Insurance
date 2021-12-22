//Main Land Registry Contract
//SPDX-License-Identifier: UNLICENSED

pragma solidity  ^0.8.0;

//import "./ownable.sol"; //this is a standard file from OpenZeppelin used for transferring or used for validating 
                        //also used as function modiers so that only an owner of a contract can call a function and make changes
                        //need to integerate it with our land registry contract especially the Transfer function

import "./Registry.sol";
contract Subscription is Registry { 

    address [] public subscribersList;
    mapping (address => uint) subscribersID;
    uint subscribers_count;


    constructor() {
        subscribers_count = 1;
    } 

    uint subscription_price = 10; //at current market value ~$3.7 

    event OwnerSubscribed(address owner_address);
    event OwnerUnubscribed(address owner_address);
    event OwnerSubExpired(address owner_address, string message);
    event lowBalance(string first_name, string last_name);
    
    function subscribe() public isRegistered {
        require(ownerPropertyCount[msg.sender] > 0, "Please register a property before subscribing to this service.");
        subscribersList.push(msg.sender);
        subscribersID[msg.sender] = subscribers_count;
        subscribers_count ++;
        emit OwnerSubscribed(msg.sender);       
    }


    function unsubscribe() public isRegistered {
        uint sub_id = subscribersID[msg.sender];
        subscribersID[subscribersList[subscribersList.length -1]] = sub_id;
        subscribersList[sub_id -1 ] = subscribersList[subscribersList.length -1];
        subscribersList.pop();
        subscribers_count --;
        emit OwnerUnubscribed(msg.sender);
    }   

    function sub_expired(address to_unsub) public validateSender{
        uint sub_id = subscribersID[to_unsub];
        subscribersID[subscribersList[subscribersList.length -1]] = sub_id;
        subscribersList[sub_id - 1] = subscribersList[subscribersList.length -1];
        subscribersList.pop();
        subscribers_count --;
        emit OwnerSubExpired(to_unsub,"Subscription was cancelled due to insufficient funds");

    }

    function subscription_payments () public validateSender { //Function to call once monthly to receive subscription payments
        for (uint i=0; i < subscribersList.length; i++) {
            if(customerBalance[subscribersList[i]] < subscription_price) {  
                    sub_expired(subscribersList[i]);
                } else if(customerBalance[subscribersList[i]] < subscription_price * 2){
                    uint owner_id = address_to_owner[subscribersList[i]]-1;
                    emit lowBalance(owners[owner_id].firstName,owners[owner_id].lastName);
                    customerBalance[subscribersList[i]] -= subscription_price;
                    revenue += subscription_price;
                } else {
                    customerBalance[subscribersList[i]] -= subscription_price;
                    revenue += subscription_price;
                }
        }
    }

    function changePriceSubscription(uint _new_price_subscription) public validateSender {
        subscription_price = _new_price_subscription;
    }

    function showSubsriptionPrice () public view returns (uint) {
        return subscription_price;
    }

    function show_sub_count () public view returns (uint) {
        return subscribers_count - 1;
    }
}



