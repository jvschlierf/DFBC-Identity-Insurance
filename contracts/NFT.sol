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
	

	// mapping (uint256 => address) public _tokenToOwner; // althigh in ERC721 we already have a maaping _owners. check if this is necessary
    mapping (uint256 => uint256) private tokenColleteralizaion;
    mapping (uint256 => uint256) private tokenPrice;
    mapping (address => uint256) private OwnerToToken;
    mapping(uint256 => string) private tokenURIs;
    event TokenIssued (address owner, uint tokenId);
    event TokenCollateralized (uint tokenId, uint amount);
    event TokenPriceSet (uint tokenId, uint amount);


    constructor () ERC721("propNFT", "NFT") {
        tokenCounter = 0;
    }

    function mintNFT(string memory tokenURI) public returns (uint256) {
        uint256 newItemId = tokenCounter;
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        tokenColleteralizaion[newItemId] = 0;
        OwnerToToken[msg.sender] = newItemId;      
        tokenCounter = tokenCounter + 1;
        emit TokenIssued (msg.sender, newItemId);
        return newItemId;
    }

    // function tokenURI(uint256 _tokenId) external view returns (string memory);
    
    function _setTokenURI(uint256 tokenId, string memory tokenURI) internal {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        tokenURIs[tokenId] = tokenURI;
    }
    // TODO: modifier verifyCollateralized {

    // }

    // TODO: function _collateralize (unit256 _tokenId, uint256 amount) public {
    //     emit TokenCollateralized (_tokenId, amount)
    // }

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

