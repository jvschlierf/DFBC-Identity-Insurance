//Main Land Registry Contract
//SPDX-License-Identifier: UNLICENSED

pragma solidity  ^0.8.0;

//import "./ownable.sol"; //this is a standard file from OpenZapplin used for transferring or used for validating 
                        //also used as function modiers so that only an owner of a contract can call a function and make changes
                        //need to integerate it with our land registry contract especially the Transfer function

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
//In Solidity 0.8+ you don't need to use SafeMath anymore, because the integer underflow/overflow check is performed on a lower level.

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

    mapping (address => uint) public address_to_owner;
    mapping (address => uint) private ownerPropertyCount; //in case owner has more than 1 property
    mapping (uint => address) private propertyToOwner;
    mapping (address => uint) public customerBalance;
	
    modifier validateSender {
        require(msg.sender == Validator, "Permission denied");
        _;
    }
	
    modifier isRegistered {
        require(address_to_owner[msg.sender] != 0, "You are not registered");
        _;
    }

	constructor()  payable {
        Validator = msg.sender;
    }

    //using SafeMath for uint;


    uint owner_id = 1; // 0 means owner is not registered
    uint property_id = 1;
    uint registration_price = 20; //at current market value ~$37 
    uint transfer_price = 5; //at current market value ~$37
	uint public revenue; // our revenue that can be withdrawn as services have been performed
    address private Validator;
    //keccak256(abi.encodePacked(_str)) -> this creates a unique hash based on arguments passed, might be required if we want a unique identifier for a property/owner
    
    // Creating events of new property and owner
    event NewPropertyRegistered (uint id, uint areaSqm, uint floor, uint zipCode, string country, 
                                string region, string city, string street, string streetNumber, 
                                string adressAdditional, string houseType);
    event NewOwnerCreated (address owner_address, uint id,  string firstName, string lastName, 
                            string gender, string codiceFiscale, string docType, string docNumber);
    event OwnershipTransferred (address new_owner, uint propert_id);

    //declaring arrays of the two structs created above
    Property[] public properties; // Do we use these at all?
    Owner[] public owners;
    address[] public addresses_list;

    function registerOwner(string memory _firstName, string memory _lastName, 
                            string memory _gender, string memory _codiceFiscale, 
                                string memory _docType, string memory _docNumber) public {
        require (address_to_owner[msg.sender] == 0, "Address is already registered."); // checking if owner is already registered or not
        owners.push(Owner(owner_id,_firstName, _lastName, _gender, 
                            _codiceFiscale, _docType, _docNumber));
        addresses_list.push(msg.sender);
        emit NewOwnerCreated(msg.sender, owner_id, _firstName, _lastName, _gender, 
                                _codiceFiscale, _docType, _docNumber);
        address_to_owner[msg.sender] = owner_id;
        owner_id ++;
        customerBalance[msg.sender] = 0;
    }

    //ownership is verified before construction is called
    function registerProperty(address _Owner, uint _areaSqm, uint _floor, uint _zipCode, 
                                string memory _country, string memory _region, string memory _city, 
                                string memory _street, string memory _streetNumber, string memory _addressAdditional, 
                                string memory _houseType) validateSender public { // Add property to 
        require(customerBalance[_Owner] >= registration_price, "Balance too low to register property. Please increase your balance & try again.");
        properties.push(Property(property_id,_areaSqm, _floor, _zipCode, _country, _region, _city, 
                                _street, _streetNumber, _addressAdditional, _houseType));
        // Check for Customer Properties on 
        emit NewPropertyRegistered(property_id, _areaSqm, _floor, _zipCode, _country, _region, _city, 
                                    _street, _streetNumber, _addressAdditional, _houseType);
        propertyToOwner[property_id] = _Owner;   //using the mapping
        ownerPropertyCount[_Owner]++;   //using the mapping   
        property_id ++;
        customerBalance[_Owner] -= registration_price; // after successful listing, deduct the fee from customers account balance
        revenue += registration_price;
    }


    receive () external payable isRegistered {
        customerBalance[msg.sender] += msg.value; // increase the owners balance
    }


    function Transfer (uint _property_id, address _new_owner_address) public { //Change in ownership  - DO WE NEED A VALIDATION IN HERE?
        require(msg.sender == propertyToOwner[_property_id], "Only Owners can transfer property. We do not have you as owner of this property.");  //First we check if the person transferring the property actually owns it or not
        require(customerBalance[_new_owner_address] >= transfer_price, "Balance of a new owner is too low to transfer property.");
        require(address_to_owner[_new_owner_address] != 0, "New owner is not registered");
        propertyToOwner[_property_id] = _new_owner_address;
        ownerPropertyCount[_new_owner_address]++; // incresing new owner's property count
        ownerPropertyCount[msg.sender]--; // decreasing old owner's property count
        emit OwnershipTransferred (_new_owner_address, _property_id);
        //the old address would still be pointing to the property which has been transferred
        //so we can fill it with a value which the property id -> 'counter' is unlikely to reach
        //we can do this for any address which has relinquished control of a property
        // address_to_owner[msg.sender] = 2**256 - 1; // we do not need it since the customer's still in db
        customerBalance[_new_owner_address] -= transfer_price; // after successful transfer, deduct the fee from customers account balance
        revenue += transfer_price;
        
    // ensure that no NFT is open against the property

    }

    // should we update all attributes within one function?
    function Update (uint _id, uint _areaSqm, uint _floor, uint _zipCode, string memory _country, 
                        string memory _region, string memory _city, string memory _street, 
                        string memory _streetNumber, string memory _addressAdditional, 
                        string memory _houseType) public {  //Change in one of the Property variables - Shaurya - maybe infeasible. Work around could be to simply add another property for the difference in floorspace (assumed to be positive), and treat as 2 separate properties
        Property storage prop = properties[_id-1];
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

    function changePriceRegistration(uint _new_price_registration) public validateSender {
        registration_price = _new_price_registration;
    }

    function changePriceTransfer(uint _new_price_transfers) public validateSender {
        transfer_price = _new_price_transfers;
    }

    function showOwnerBalance (address _owner) public view returns (uint) {
        return customerBalance[_owner];
    }

    function show_revenue () public view validateSender returns (uint) { //Function to show realized revenue from sign up & subscription
        return revenue;
    }

    function Payment () validateSender public payable { 
        address payable deposit = payable(Validator);
        require(address(this).balance > 10);
        uint payout = revenue - 10;
        revenue = 10;
        (bool success, ) = deposit.call{value : payout}("");
        require(success, "Transfer failed.");
        // if (address(this).balance < 1000000000000000) {  // == 0.01 ETH
        //     revenue -= 100000000000000; // to prevent running out of money (for gas) in the contract, we save 0.0001 ETH if our balance is below 0.01 ether
        // }
        // deposit.transfer(payout); // we pay out the generated revenues to our address
    }



    function showBalance () public view validateSender returns (uint) {
        return address(this).balance;
    }


    function showRegistrationPrice () public view returns (uint) {
        return registration_price;
    }

    function showTransferPrice () public view returns (uint) {
        return transfer_price;
    }

    function showOwnersCount () public view returns (uint) {
        return owners.length;
    }

    function showPropertyCount () public view returns (uint) {
        return properties.length;
    }  

    function findOwner(address _owner) public view validateSender returns (string memory,
                                                                           string memory) {
        uint ownerId = address_to_owner[_owner];
        return (owners[ownerId - 1].firstName, owners[ownerId - 1].lastName);
    }

    function countOwnerProperties(address _owner) public view returns (uint) {
        return ownerPropertyCount[_owner];
    }

    function findPropertyOwner(uint _id) public view returns (string memory, 
                                                              string memory, 
                                                              address) {
        address owner_address = propertyToOwner[_id];
        uint ownerId = address_to_owner[owner_address];
        return (owners[ownerId - 1].firstName, owners[ownerId - 1].lastName, owner_address);
    }      

}



