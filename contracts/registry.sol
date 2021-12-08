//Main Land Registry Contract

pragma solidity  >= 0.8.0;

contract  Registry {

    struct Property {
        uint propId;
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
        address id;
        string firstName;
        string lastName;
        string gender;  //We accomodate more than 2 genders, so do not use a bool here
        string codiceFisc;
        string docType;
        string docNumber;
        bool isVerified;
    }


    // mapping ()
    mapping(uint => Property) public properties;
    mapping(Owner => bool) public verifiedUsers;

	modifier verifiedUser(address _user) {
	    require(verifiedUsers[_user]);
	    _;
	}
    
    function FirstRegistration (uint _propId,
        string country,
        string region,
        uint zipCode,
        string city,
        string street,
        string streetnum,
        string addressAdditional,
        string houseType;
        uint sqm,
        uint floor) verifiedUser(_owner) public { // Add property to 

        properties[]
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



