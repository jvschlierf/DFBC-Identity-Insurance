//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
// credits: https://ethereum.org/en/developers/tutorials/how-to-write-and-deploy-an-nft/#connect-to-ethereum
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Registry.sol"; //so that to inherit the property struct to use for the metadata of the coin


contract propNFT is ERC721, Ownable {
    uint256 public tokenCounter;
    uint256 colleteralizedAmount;
    uint256 totalPrice;
    
    // struct Property {
	// 	address _owner;
	// 	uint sqm; 
	// 	string _address;
	// 	uint value;
	// } ----------- maybe we will creare a mapping with struct later
	

    mapping (uint256 => bool) private tokenColleteralizaion;
    mapping (uint256 => uint256) private tokenPrice;
    mapping(uint256 => string) private tokenURIs;
    mapping (uint256 => Property ) private;
    
    event TokenIssued (address owner, uint tokenId);
    event TokenCollateralized (uint tokenId, uint amount);
    event TokenPriceSet (uint tokenId, uint amount);


    constructor () ERC721("propNFT", "NFT") {
        tokenCounter = 0;
    }

    function mintNFT(string memory tokenURI) public returns (uint256) {
        uint256 newItemId = tokenCounter;
	tokenCounter = tokenCounter + 1;
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        tokenColleteralizaion[newItemId] = false; //by default the token is not used as collateral
        emit TokenIssued (msg.sender, newItemId);
        return newItemId;
	
	//add also the token price
    }

    // function tokenURI(uint256 _tokenId) external view returns (string memory);
    
    function _setTokenURI(uint256 tokenId, string memory tokenURI) internal {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        tokenURIs[tokenId] = tokenURI;
    }


    //when a customer uses its NFT as a collateral, he should call this:
    function _collateralize (unit256 _tokenId, uint256 amount) public {
        require(msg.sender == ownerOf(tokenId), "The caller is not the owner of the token");
	tokenColleteralizaion[_tokenId] = true;
    	emit TokenCollateralized(_tokenId, amount);
     }

	//to be connected with the ML model
    function _setPrice(uint256 tokenId, uint256 price) public {
        tokenPrice[tokenId] = price;
        emit TokenPriceSet (tokenId, price);
    }

    function _checkPrice(uint256 tokenId) public view returns (uint256) {
        return tokenPrice[tokenId];
    }

    function _checkCollateralization (uint256 tokenId) public view returns (uint256) {
        return tokenColleteralizaion[tokenId];
    }

}

