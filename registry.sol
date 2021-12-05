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
        bool insured;
        bool hasNFT; 
    }

    mapping (address => Owner) owners;
    mapping (Property => Owner) owned_properties;

    uint public propertycount;



    function FirstRegistration (string country, string region, uint zipCode, string city, string street, string streetnum, string addressAdditional, string houseType, uint sqm, uint floor) public { // Add property to 
       
        propertycount++;
        uint id = registeredProperties
        properties[id] = Property (country, region, zipCode, city, street, addressAdditional, );
        owned_properties[Property] = msg.sender;
        // emit AddingLand(landsCount);
        Verify(id);
    }

    function Transfer ()private { //Change in ownership

    }

    function Verify (uint id) private { //Pull update from Oracle (in regular intervals) from the actual public registry

    }

    function Update () public {  //Change in one of the Property variables

    }

    function Notify () public { //If verify function has detected fraud, notify customer


    }

    function Remove () public { 


    }









}



