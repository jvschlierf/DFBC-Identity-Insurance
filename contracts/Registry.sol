//Main Land Registry Contract

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
    
    mapping (address => uint) address_to_owner;
    mapping (address => uint) ownerPropertyCount; //in case owner has more than 1 property
    mapping (uint => address) propertyToOwner;

    uint public propertycount;
    address private Validator;
	
    modifier ValidateSender {
        require(msg.sender == Validator);
        _;
    }
	
	constructor() public payable{
        Validator = msg.sender;
    }

    uint counter_owners = 0;
    uint counter = 0;
	
    //keccak256(abi.encodePacked(_str)) -> this creates a unique hash based on arguments passed, might be required if we want a unique identifier for a property/owner

    // Creating events of new property and owner
    event NewPropertyRegistered (uint id, uint areaSqm, uint floor, uint zipCode, string country, string region, string city, string street, string streetNumber, string adressAdditional, string houseType);
    event NewOwnerCreated (address owner_address, string firstName, string lastName, string gender, string codiceFiscale, string docType, string docNumber);
    
    //declaring arrays of the two structs created above
    Property[] public properties; 
    Owner[] public owners;

    function OwnerInformation(string memory _firstName, string memory _lastName, string memory _gender, string memory _codiceFiscale, string memory _docType, string memory _docNumber) public payable {
        owners.push(Owner(counter_owners,_firstName, _lastName, _gender, _codiceFiscale, _docType, _docNumber));
        //uint id = owners.push(Owner(_firstName, _lastName, _gender, _codiceFiscale, _docType, _docNumber)) - 1;
        
        emit NewOwnerCreated(counter_owners, _firstName, _lastName, _gender, _codiceFiscale, _docType, _docNumber);
        address_to_owner[msg.sender] = counter_owner;
        counter_owners ++;
    
    }
    //ownership is verified before construction is called
    function FirstRegistration(uint _areaSqm, uint _floor, uint _zipCode, string memory _country, string memory _region, string memory _city, string memory _street, string memory _streetNumber, string memory _addressAdditional, string memory _houseType) public payable  { // Add property to 
        properties.push(Property(counter,_areaSqm, _floor, _zipCode, _country, _region, _city, _street, _streetNumber, _addressAdditional, _houseType));
        //uint id = properties.push(Property(_areaSqm, _floor, _zipCode, _country, _region, _city, _street, _streetNumber, _addressAdditional, _houseType)) - 1;
        emit NewPropertyRegistered(counter, _areaSqm, _floor, _zipCode, _country, _region, _city, _street, _streetNumber, _addressAdditional, _houseType);
        propertyToOwner[counter] = msg.sender;   //using the mapping
        ownerPropertyCount[msg.sender]++;   //using the mapping   
        counter ++;
    }

    receive () external payable {
    }



    function Transfer (uint property_id, address new_owner_address) public payable{ //Change in ownership - Shaurya - could be loaned from existing repos that we found?
        require(msg.sender == propertyToOwner[property_id]);
        propertyToOwner[property_id] = new_owner_address;

    // ensure that no NFT is open against the property

    }

    function check_owner (uint property_id) public view returns(address){
        return (propertyToOwner[property_id]);
    }


    function Update (uint id, uint _areaSqm, uint _floor, uint _zipCode, string memory _country, string memory _region, string memory _city, string memory _street, string memory _streetNumber, string memory _addressAdditional, string memory _houseType) public {  //Change in one of the Property variables - Shaurya - maybe infeasible. Work around could be to simply add another property for the difference in floorspace (assumed to be positive), and treat as 2 separate properties
        Property storage prop = properties[id];
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


    function Payment () public { 
        

    }



}



