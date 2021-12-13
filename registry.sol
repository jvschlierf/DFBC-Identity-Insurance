//Main Land Registry Contract

pragma solidity  ^0.8.0;

contract  Registry {

    struct Property {
        //uint id; id generated inside the function First Registration
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
        //uint id; id generated inside the function OwnerInformation
        string firstName;
        string lastName;
        string gender;  //We accomodate more than 2 genders, so do not use a bool here
        string codiceFisc;
        string docType;
        string docNumber;
         
    }

    mapping (address => uint) ownerPropertyCount; //in case owner has more than 1 property
    mapping (uint => address) propertyToOwner;

    uint public propertycount;
    address private Validator;
	
    modifier ValidateSender {
        require(msg.sender == Validator);
        _;
    }
	
	constructor() public {
        Validator = msg.sender;
    }
	
    //keccak256(abi.encodePacked(_str)) -> this creates a unique hash based on arguments passed, might be required if we want a unique identifier for a property/owner

    // Creating events of new property and owner
    event NewPropertyRegistered (uint id, uint areaSqm, uint floor, uint zipCode, string country, string region, string city, string street, string streetNumber, string adressAdditional, string houseType);
    event NewOwnerCreated (uint id, string firstName, string lastName, string gender, string codiceFiscale, string docType, string docNumber);
    
    //declaring arrays of the two structs created above
    Property[] public properties; 
    Owner[] public owners;

    function OwnerInformation(string memory _firstName, string memory _lastName, string memory _gender, string memory _codiceFiscale, string memory _docType, string memory _docNumber) public ValidateSender {
        owners.push(Owner(_firstName, _lastName, _gender, _codiceFiscale, _docType, _docNumber));
        uint id = owners.push(Owner(_firstName, _lastName, _gender, _codiceFiscale, _docType, _docNumber)) - 1;
        emit NewOwnerCreated(id, _firstName, _lastName, _gender, _codiceFiscale, _docType, _docNumber);
    }
    //ownership is verified before construction is called
    function FirstRegistration(uint _areaSqm, uint _floor, uint _zipCode, string memory _country, string memory _region, string memory _city, string memory _street, string memory _streetNumber, string memory _addressAdditional, string memory _houseType) public ValidateSender { // Add property to 
        properties.push(Property(_areaSqm, _floor, _zipCode, _country, _region, _city, _street, _streetNumber, _addressAdditional, _houseType));
        uint id = properties.push(Property(_id, _areaSqm, _floor, _zipCode, _country, _region, _city, _street, _streetNumber, _addressAdditional, _houseType)) - 1;
        emit NewPropertyRegistered(id, _areaSqm, _floor, _zipCode, _country, _region, _city, _street, _streetNumber, _addressAdditional, _houseType);
        propertyToOwner[id] = msg.sender;   //using the mapping
        ownerPropertyCount[msg.sender]++;   //using the mapping   
    }



    function Transfer () public ValidateSender { //Change in ownership - Shaurya - could be loaned from existing repos that we found?

    // ensure that no NFT is open against the property

    }


    function Update () public {  //Change in one of the Property variables - Shaurya - maybe infeasible. Work around could be to simply add another property for the difference in floorspace (assumed to be positive), and treat as 2 separate properties

    }

    function Notify () public { //Notify customer here or in python via telegram bot


    }

    function Remove () public { //Remove the property if property  - Jakob to do  - maybe impossible, consider removing


    }



}



