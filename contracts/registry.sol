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




    mapping ()



    function FirstRegistration { // Add property to 

        Verify;
    }

    function Transfer { //Change in ownership

    }

    function Verify { //Pull update from Oracle (in regular intervals) from the actual public registry

    }

    function Update {  //Change in one of the Property variables

    }

    function Notify { //If verify function has detected fraud, notify customer


    }

    function Remove { 


    }









}



