//Main Land Registry Contract

pragma solidity  >=0.8.0;

contract  Registry {

    struct Property {
        uint id;
        string country;
        string region;
        uint zipCode;
        string city;
        string street;
        string streetnum;
        string addressAdditional;
        string houseType;
        uint sqm;
        uint floor;
    }

    struct Owner {
        uint id;
        string firstName;
        string lastName;
        string gender;  //We accomodate more than 2 genders, so do not use a bool here
        string codiceFisc;
        string docType;
        string docNumber;
         
    }
	
	


    mapping (address => Owner) owners;
    mapping (Property => Owner) owned_properties;

    uint public propertycount;
    address private Validator;
	
    modifier ValidateSender {
        require(msg.sender == Validator);
        _;
    }
	
	constructor() public {
        Validator = msg.sender;
    }
	

    // Shaurya
    event PropertyRegistered {  
    
    }

    // Shaurya
    event OwnerRegistered {

    }

    Property[] public properties;
    Owner[] public owners;


    function OwnerInformation(uint _id, string memory _firstName, string memory _lastName, string memory _gender, string memory _codiceFiscale, string memory _docType, string memory _docNumber) public ValidateSender {
        owners.push(Owner(_id, _firstName, _lastName, _gender, _codiceFiscale, _docType, _docNumber));
    }

    //ownership is verified before construction is called
    function FirstRegistration(uint _id, uint _areaSqm, uint _floor, uint _zipCode, string memory _country, string memory _region, string memory _city, string memory _street, string memory _streetNumber, string memory _adressAdditional, string memory _houseType) public ValidateSender { // Add property to 
        properties.push(Property(_id, _areaSqm, _floor, _zipCode, _country, _region, _city, _street, _streetNumber, _adressAdditional, _houseType));
    }



    function Transfer () public ValidateSender { //Change in ownership - Shaurya 

    // ensure that no NFT is open against the property

    }


    function Update () public {  //Change in one of the Property variables - Shaurya

    }

    function Notify () public { //Notify customer here or in python via telegram bot


    }

    function Remove () public { //Remove the property if property  - Jakob to do


    }









}



