//Main Land Registry Contract
//SPDX-License-Identifier: UNLICENSED

pragma solidity  ^0.8.0;

//import "./ownable.sol"; //this is a standard file from OpenZeppelin used for transferring or used for validating 
                        //also used as function modiers so that only an owner of a contract can call a function and make changes
                        //need to integerate it with our land registry contract especially the Transfer function

import "./Registry.sol";
contract Subscription is Registry { 

    address [] public subscribersList;
    mapping (address => bool) subscribers;
    mapping (address => bool) eversubscribed;
    mapping (address => int) subscribersID;


    constructor() {
   
    } 

    uint subscription_price = 10; //at current market value ~$3.7 

    event OwnerSubscribed(address owner_address);
    event OwnerUnubscribed(address owner_address);
    event lowBalance(string first_name, string last_name);
    
    function subscribe() public isRegistered {
        require(ownerPropertyCount[msg.sender] > 0, "Please register a property before subscribing to this service.");
        if (eversubscribed[msg.sender]) {
            subscribers[msg.sender] = true;
            emit OwnerSubscribed(msg.sender);
        }
        else {
            subscribers[msg.sender] = true;
            emit OwnerSubscribed(msg.sender);
            subscribersList.push(msg.sender);
            eversubscribed[msg.sender] = true;
        }
        
    }


    function unsubscribe() public isRegistered {
        subscribers[msg.sender] = false;
        emit OwnerUnubscribed(msg.sender);
    }   

    function subscription_payments () public validateSender { //Function to call once monthly to receive subscription payments
        for (uint i=0; i < subscribersList.length; i++) {
            if(subscribers[subscribersList[i]] == true) {
                if(customerBalance[subscribersList[i]] < subscription_price) {  
                    subscribers[subscribersList[i]] = false;
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
    }

    function changePriceSubscription(uint _new_price_subscription) public validateSender {
        subscription_price = _new_price_subscription;
    }

    function showSubsriptionPrice () public view returns (uint) {
        return subscription_price;
    }

}



