//Main Land Registry Contract
//SPDX-License-Identifier: UNLICENSED

pragma solidity  ^0.8.0;

//import "./ownable.sol"; //this is a standard file from OpenZapplin used for transferring or used for validating 
                        //also used as function modiers so that only an owner of a contract can call a function and make changes
                        //need to integerate it with our land registry contract especially the Transfer function

contract Subscription is Registry { 

    address [] public subscribersList;
    mapping (address => bool) subscribers;

    uint subscription_price = 10; //at current market value ~$3.7 

    event OwnerSubscribed(address owner_address);
    event OwnerUnubscribed(address owner_address);
    event lowBalance(address owner_address);
    
    function subscribe () public isRegistered {
        subscribers[msg.sender] = true;
        subscribersList.push(msg.sender);
         emit OwnerSubscribed(msg.sender);
    }

    function unsubscribe () public isRegistered {
        subscribers[msg.sender] = false;
        emit OwnerUnubscribed(msg.sender);
    }   

    function subscription_payments () public validateSender { //Function to call once monthly to receive subscription payments
        for (uint i=0; i< subscribersList.length; i++) {
            if(subscribers[i] == true) {
                if(customerBalance[listofaddresses[i]] < subscription_price) {  
                    subscribers[i] = false
                } else if(customerBalance[listofaddresses[i]] < subscription_price * 2){
                    emit lowBalance(i);
                    customerBalance[listofaddresses[i]].sub(subscription_price);
                    revenue.add(subscription_price);
                } else {
                    customerBalance[listofaddresses[i]].sub(subscription_price);
                    revenue.add(subscription_price);
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



