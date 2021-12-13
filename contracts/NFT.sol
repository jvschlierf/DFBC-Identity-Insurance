//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
// credits: https://ethereum.org/en/developers/tutorials/how-to-write-and-deploy-an-nft/#connect-to-ethereum
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract propNFT is ERC721, Ownable {
    uint256 public tokenCounter;
    uint256 colleteralizedAmount;
    uint256 totalPrice;
    enum NFTStatus {
        UNCOLLATERALIZED,
        COLLATERALIZED
    }
    
    // struct Property {
	// 	address _owner;
	// 	uint sqm; 
	// 	string _address;
	// 	uint value;
	// } ----------- maybe we will creare a mapping with struct later
	

	mapping (uint256 => address) public _tokenToOwner; // althigh in ERC721 we already have a maaping _owners. check if this is necessary
    mapping (uint256 => uint256) public _tokenColleteralizaion;
    mapping (uint256 => uint256) public _tokenPrice;
    event TokenIssued (address owner, uint tokenId);
    event TokenCollateralized (uint tokenId, uint amount);
    event TokenPriceSet (uint tokenId, uint amount);


    constructor () public ERC721("propNFT", "NFT") {
        tokenCounter = 0;
    }

    function mintNFT(string memory _tokenURI) public returns (uint256) {
        uint256 _newItemId = tokenCounter;
        _safeMint(msg.sender, _newItemId);
        _setTokenURI(_newItemId, tokenURI);
        _tokenColleteralizaion[_newItemId] = 0;
        _tokenToOwner[_newItemId] = msg.sender;      
        tokenCounter = tokenCounter + 1;
        return _newItemId;
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory);

    // TODO: modifier verifyCollateralized {

    // }

    // TODO: function _collateralize (unit256 _tokenId) public 

    function _setPrice(uint256 _tokenId, uint256 price) public {
        _tokenPrice[_tokenId] = price;
    }

    function _checkPrice(uint256 _tokenId) public view returns (uint256) {
        return _tokenPrice[_tokenId];
    }

    function _checkCollateralization (uint256 _tokenId) public view returns (uint256) {
        return _tokenColleteralizaion[_tokenId];
    }

}

