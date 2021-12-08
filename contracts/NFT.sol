//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
// credits: https://ethereum.org/en/developers/tutorials/how-to-write-and-deploy-an-nft/#connect-to-ethereum
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract propNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    Property[] public properties;
    mapping(uint => bool) _propertyExists; //check not to issue the same token twice
    
    struct Property {
		address _owner;
		uint sqm; 
		string _address;
		uint value;
	}
	
	//mapping PropertyID to owner
	mapping (uint => address) public tokenToOwner;
    mapping (ERC721 => address) public NFTtoOwner;

    
    constructor() ERC721("propNFT", "NFT") public {
    owner = msg.sender; // ?? 
    colleteralizedAmount float; // cumulative sum or percentage 
    totalAmout float; // house price 
    }

    function mintNFT(address memory recipient, string memory tokenURI) 
        public onlyOwner
        returns (uint256) 
        // _mint(owner, tokenId); //DEFINE OWNER
    {
    	//require property has not been taken yet
    	require(!_propertyExists[_color]); //read the value out of the mapping is false, (!false = true)
					  //i.e. property not taken
        _tokenIds.increment();
	    _propertyExists[tokenURI] = true;
        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
	
        return newItemId;
    }
}
    modifier verifyCollateralized {

    }