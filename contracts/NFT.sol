//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract propNFT is ERC721, Ownable {
    uint256 public tokenCounter;
    address private Validator;

    mapping (uint256 => bool) private tokenColleteralizaion;
    mapping (uint256 => string) _tokenURIs;
    mapping (uint256 => uint256) _idToValue; //mapping from token Id to its calculated price

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

    function _setTokenURI(uint256 tokenId, string memory _uri) internal existingToken(tokenId) {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721 transfer caller is nor owner not approved");
        _tokenURIs[tokenId] = _uri;
    }
    
    function isOwner(uint256 tokenId) public view existingToken(tokenId) returns(address){
        return ownerOf(tokenId);
    }

    //who will mint? we or the customer? validateSender or onlyOwner?
    function mintNFT(string memory _uri) public validateSender returns(uint256){
        uint256 newItemId = tokenCounter;
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, _uri);
        tokenCounter ++;

        tokenColleteralizaion[newItemId] = false; //by default the token is not used as collateral
        return newItemId;
    }
    
    function gettokenURI(uint256 tokenId) public view existingToken(tokenId) returns(string memory) {
        string memory _uri = _tokenURIs[tokenId];
        return _uri;
    }
    //when a customer uses its NFT as a collateral, he should call this:
    //do we want to allow to collateralize only a certain amount?
    function _collateralize (uint256 tokenId, uint256 collateralization_amount, address lender) public existingToken(tokenId) {
	    uint256 value = _requireCollateralValue(tokenId);
        
        require (value > collateralization_amount, "Token not worth enough");
        emit TokenCollateralized(tokenId, collateralization_amount);
        tokenColleteralizaion[tokenId] = true;
        transferFrom(ownerOf(tokenId), lender, tokenId); //transfer token to lender
     }


    function _checkCollateralization (uint256 tokenId) public view existingToken(tokenId) onlyOwner() returns(bool) {
        return tokenColleteralizaion[tokenId];
    }

    //function called by the customer when he wants to use his NFT as collateral
    //should calculate the value of the NFT
    function _requireCollateralValue (uint256 tokenId) private existingToken(tokenId) returns(uint256) {
            emit priceCalculation(tokenId);
            return _idToValue[tokenId];
    }

    function burnNFT(uint256 tokenId) public existingToken(tokenId) { //_burn already checks that msg.sender = owner
        _burn(tokenId);
        //do we leave the token in the mappings..?
        delete tokenColleteralizaion[tokenId];
        delete _tokenURIs[tokenId];
        delete _idToValue[tokenId];
    }
    
}
