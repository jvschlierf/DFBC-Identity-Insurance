//Main Land Registry Contract
//SPDX-License-Identifier: UNLICENSED

pragma solidity  ^0.8.0;

//import "./ownable.sol"; //this is a standard file from OpenZapplin used for transferring or used for validating 
                        //also used as function modiers so that only an owner of a contract can call a function and make changes
                        //need to integerate it with our land registry contract especially the Transfer function


contract  Registry { //registry contract inheriting from the ownable contract

    struct Property {
        uint id; //id generated inside the function First Registration
        uint sqm;
        uint floor;
        uint zipCode;
        string country;
        string region;
        string city;
        string street;
        string streetnum;
        string addressAdditional;
        string houseType;

    }

    struct Owner {
        //address owner_addr; //id generated inside the function OwnerInformation
        uint id;        
        string firstName;
        string lastName;
        string gender;  //We accomodate more than 2 genders, so do not use a bool here
        string codiceFisc;
        string docType;
        string docNumber;
         
    }
    
    mapping (address => uint) private address_to_owner;
    mapping (address => uint) private ownerPropertyCount; //in case owner has more than 1 property
    mapping (uint => address) private propertyToOwner;
    mapping (address => uint) private customerBalance;

    uint public propertycount;
    uint private revenue; // our revenue that can be withdrawn as services have been performed
    address private Validator;
	
    modifier ValidateSender {
        require(msg.sender == Validator);
        _;
    }
	
	constructor() public payable{
        Validator = msg.sender;
    }

    uint counter_owners = 1; // 0 means owner is not registered
    uint counter_properties = 1;
    uint registration_price = 10000000000000000; //at current market value ~$37 
    uint subscription_price = 1000000000000000; //at current market value ~$3.7 
    uint transfer_price = 10000000000000000; //at current market value ~$37
	
    //keccak256(abi.encodePacked(_str)) -> this creates a unique hash based on arguments passed, might be required if we want a unique identifier for a property/owner

    // Creating events of new property and owner
    event NewPropertyRegistered (uint id, uint areaSqm, uint floor, uint zipCode, string country, string region, string city, string street, string streetNumber, string adressAdditional, string houseType);
    event NewOwnerCreated (address owner_address, uint id,  string firstName, string lastName, string gender, string codiceFiscale, string docType, string docNumber);
    event OwnershipTransferred (address new_owner, uint propert_id);

    //declaring arrays of the two structs created above
    Property[] public properties; // Do we use these at all?
    Owner[] public owners;
    address[] public listofaddresses;

    function registerOwner(string memory _firstName, string memory _lastName, string memory _gender, string memory _codiceFiscale, string memory _docType, string memory _docNumber) public payable {
        require (address_to_owner[msg.sender] == 0, "Address is already registered."); // checking if owner is already registered or not
        owners.push(Owner(counter_owners,_firstName, _lastName, _gender, _codiceFiscale, _docType, _docNumber));
        listofaddresses.push(msg.sender);
        emit NewOwnerCreated(msg.sender, counter_owners, _firstName, _lastName, _gender, _codiceFiscale, _docType, _docNumber);
        address_to_owner[msg.sender] = counter_owners;
        counter_owners ++;
        customerBalance[msg.sender] = 0;
    
    }
    //ownership is verified before construction is called
    function registerProperty(address _Owner, uint _areaSqm, uint _floor, uint _zipCode, string memory _country, string memory _region, string memory _city, string memory _street, string memory _streetNumber, string memory _addressAdditional, string memory _houseType) ValidateSender public payable  { // Add property to 
        require(customerBalance[_Owner] >= registration_price, "Balance too low to register property. Please increase your balance & try again.");
        properties.push(Property(counter_properties,_areaSqm, _floor, _zipCode, _country, _region, _city, _street, _streetNumber, _addressAdditional, _houseType));
        // Check for Customer Properties on 
        emit NewPropertyRegistered(counter_properties, _areaSqm, _floor, _zipCode, _country, _region, _city, _street, _streetNumber, _addressAdditional, _houseType);
        propertyToOwner[counter_properties] = _Owner;   //using the mapping
        ownerPropertyCount[_Owner]++;   //using the mapping   
        counter_properties ++;

        customerBalance[_Owner] -= registration_price; // after successful listing, deduct the fee from customers account balance
        revenue += registration_price;
    }

    receive () external payable {
        require (address_to_owner[msg.sender] != 0, "Please sign up first.");
        customerBalance[msg.sender] += msg.value; // increase the owners balance
    }



    function Transfer (uint _property_id, address _new_owner_address) public payable{ //Change in ownership  - DO WE NEED A VALIDATION IN HERE?
        require(msg.sender == propertyToOwner[_property_id], "Only Owners can transfer property. We do not have you as owner of this property.");  //First we check if the person transferring the property actually owns it or not
        require(customerBalance[msg.sender] >= transfer_price, "Balance too low to transfer property. Please increase your balance & try again.");
        propertyToOwner[_property_id] = _new_owner_address;
        ownerPropertyCount[_new_owner_address]++; // incresing new owner's property count
        ownerPropertyCount[msg.sender]--; // decreasing old owner's property count
        emit OwnershipTransferred (_new_owner_address, _property_id);
        //the old address would still be pointing to the property which has been transferred
        //so we can fill it with a value which the property id -> 'counter' is unlikely to reach
        //we can do this for any address which has relinquished control of a property
        address_to_owner[msg.sender] = 2**256 - 1;
        customerBalance[msg.sender] -= transfer_price; // after successful transfer, deduct the fee from customers account balance
        revenue += transfer_price;
        
    // ensure that no NFT is open against the property

    }

    // function check_owner (uint _property_id) public view returns(address){
    //     return (propertyToOwner[_property_id]);

    // }

    function Update (uint _id, uint _areaSqm, uint _floor, uint _zipCode, string memory _country, string memory _region, string memory _city, string memory _street, string memory _streetNumber, string memory _addressAdditional, string memory _houseType) public {  //Change in one of the Property variables - Shaurya - maybe infeasible. Work around could be to simply add another property for the difference in floorspace (assumed to be positive), and treat as 2 separate properties
        Property storage prop = properties[_id];
        prop.sqm = _areaSqm;
        prop.floor = _floor;
        prop.zipCode = _zipCode;
        prop.country = _country;
        prop.region = _region;
        prop.city = _city;
        prop.street = _street;
        prop.streetnum = _streetNumber;
        prop.addressAdditional = _addressAdditional;
        prop.houseType = _houseType;
    }

    function changePrices(uint _new_price_registration, uint _new_price_subscription, uint _new_price_transfers) public ValidateSender {
        registration_price = _new_price_registration;
        subscription_price = _new_price_subscription;
        transfer_price = _new_price_transfers;

    }


    function subscription_payments () public ValidateSender { //Function to call once monthly to receive subscription payments
        for (uint i=0; i< listofaddresses.length; i++) {
            customerBalance[listofaddresses[i]] -= subscription_price;
            revenue += subscription_price;
        }

    }

    function show_revenue () external ValidateSender returns (uint _revenue) { //Function to show realized revenue from sign up & subscription
        _revenue = revenue;
        return _revenue;
    }



    function Payment () ValidateSender public payable { 
        address payable deposit = payable(Validator);
        if (address(this).balance < 100000000000000000) {
            revenue -= 1000000000000000; // to prevent running out of money (for gas) in the contract, we save 0.001 ether if our balance is below 1 ether
        }
        deposit.transfer(revenue); // we pay out the generated revenues to our address
    }

    

}



