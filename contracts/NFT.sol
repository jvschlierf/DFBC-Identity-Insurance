//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
//import "./Registry.sol"; - Solidity memory limit

contract propNFT is ERC721 { //Registry
    uint256 public tokenCounter;
    address private Validator;

    mapping (uint256 => bool) private tokenColleteralizaion;
    mapping (uint256 => string) _tokenURIs;

    event TokenCollateralized(uint256 tokenId, uint256 amount);
    event priceCalculation(uint256 tokenId);

    constructor () ERC721("propNFT", "NFT") { 
        tokenCounter = 0;
        Validator = msg.sender;
    }

    modifier existingToken(uint256 tokenId) {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _;
    }

    modifier validateSender {
        require(msg.sender == Validator, "Permission denied");
        _;
    }

    //URIs are generated through the python script create_URI.py
    function _setTokenURI(uint256 tokenId, string memory _uri) internal validateSender existingToken(tokenId) {
        // require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721 transfer caller is nor owner not approved");
        _tokenURIs[tokenId] = _uri;
    }
    
    function isOwner(uint256 tokenId) public view existingToken(tokenId) returns(address){
        return ERC721.ownerOf(tokenId);
    }

    // We (the company) mint the NFTs
    function mintNFT(string memory _uri, address _owner) public validateSender returns(uint256){
        uint256 newItemId = tokenCounter;
        _safeMint(_owner, newItemId);
        _setTokenURI(newItemId, _uri);
        tokenCounter ++;

        tokenColleteralizaion[newItemId] = false; //by default the token is not used as collateral
        return newItemId;
    }
    
    function gettokenURI(uint256 tokenId) public view existingToken(tokenId) returns(string memory) {
        string memory _uri = _tokenURIs[tokenId];
        return _uri;
    }
    
    //when a customer uses its NFT as a collateral, WE should call this.
    //the value is calculated through. theML model
    function _collateralize (uint256 tokenId, uint256 collateralization_amount, uint256 value) public validateSender existingToken(tokenId) {
	    require(tokenColleteralizaion[tokenId] == false, "Token already used as collateral");        
        require ((8*value)/10 > collateralization_amount, "Token not worth enough"); //set a threshold for the collateral amount
        
        emit TokenCollateralized(tokenId, collateralization_amount);
        tokenColleteralizaion[tokenId] = true;
     }


    function _checkCollateralization (uint256 tokenId) public view existingToken(tokenId) returns(bool) {
    	require(msg.sender == isOwner(tokenId), "Ownable: caller is not the owner");
        return tokenColleteralizaion[tokenId];
    }


    //function called by the customer when he wants to use his NFT as collateral
    //when the event priceCalculation(tokenId) is triggered, we assume that it
    //connects to the predict_price.py which returns the predicted value of the NFT
    //assume we have this function connected to the python code (price calculation ML model)
    function _requireCollateralValue (uint256 tokenId) public existingToken(tokenId)  { // returns(uint256)
            emit priceCalculation(tokenId); 
                    
                    // value = get_nft_value()
                    //when triggered, this event connects to the ML model
                    //and calculates the value of the token that is returned here:
            // return value; 
    }


    function burnNFT(uint256 tokenId) public existingToken(tokenId) { //_burn already checks that msg.sender = owner
        _burn(tokenId);
        delete tokenColleteralizaion[tokenId];
        delete _tokenURIs[tokenId];
    }    
    
    
}
