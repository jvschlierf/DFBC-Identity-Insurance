//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
// credits: https://ethereum.org/en/developers/tutorials/how-to-write-and-deploy-an-nft/#connect-to-ethereum
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/escrow/Escrow.sol";
import "NFT.sol";



contract NftCollateral {


    event LoanRepayed(uint256 id, address lender, address repayer);    
    
    IERC721(_tokenAddress).transferFrom(msg.sender, address(this), _tokenId);

}