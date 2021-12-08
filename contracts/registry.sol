//Main Land Registry Contract

pragma solidity  >=0.8.0;

contract  Registry {

    struct Property {
        uint id;
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
        uint id;
        string firstName;
        string lastName;
        string gender;  //We accomodate more than 2 genders, so do not use a bool here
        string codiceFisc;
        string docType;
        string docNumber;
        
    }

    Property[] public properties;

    Owner[] public owners;

    // mapping ()

    function OwnerInformation(uint _id, string memory _firstName, string memory _lastName, string memory _gender, string memory _codiceFiscale, string memory _docType, string memory _docNumber) public {
        owners.push(Owner(_id, _firstName, _lastName, _gender, _codiceFiscale, _docType, _docNumber));
    }

    function FirstRegistration(uint _id, uint _areaSqm, uint _floor, uint _zipCode, string memory _country, string memory _region, string memory _city, string memory _street, string memory _streetNumber, string memory _adressAdditional, string memory _houseType) public { // Add property to 
        properties.push(Property(_id, _areaSqm, _floor, _zipCode, _country, _region, _city, _street, _streetNumber, _adressAdditional, _houseType))
        //Verify;
    }

    function Transfer() { //Change in ownership

    }

    function Verify() { //Pull update from Oracle (in regular intervals) from the actual public registry

    }

    function Update() {  //Change in one of the Property variables

    }

    function Notify() { //If verify function has detected fraud, notify customer


    }

    function Remove() { 


    }
}



