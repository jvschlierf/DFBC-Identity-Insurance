# Blockchain-based land registry

<img src="https://img.shields.io/badge/Ethereum-20232A?style=for-the-badge&logo=ethereum&logoColor=white">

## Project Description:
Conventional land registry systems can be unreliable when it comes to checking the ownership of the property, which opens up an opportunity for malicious behaviour by people selling property that does not belong to them. Property-related fraud might not be as common as other kinds of fraud, but it is definetely one of the most painful and costly for the property owners who have to go through a legal process to revert the already happened transfer of ownership.  

Our mission is to protect owners from property fraud by **storing proof of ownership on the blockchain** and tracking changes in the official off-chain land registry. We expect an introduction of Central Bank Digital Coin (CBDC) in the near future and the following migration of land registry onto the blockchain. Anticipating those changes we aim to become **the first official land registry and a platform which will enable quick and secure property ownership transfers.**

## Our services:
* Notification in case a change in the off-chain land registry is detected. The owner will be asked to confirm the transfer of ownership. 
* Property market where onwers of properties listed on the platform are verified through the public ledger. The platform will connect property buyers and sellers and ensure secure deals.
* In addition, verified owners can have a NFT on a property issued to them, which can be used as a collateral for loans in CBDC
* Notification service is subscription-based with regular monthly payments.

## Scenario:
We imagine this project two work in two scenarios, aiding in the transition from the first to the second: 

### Scenario 1: 
Cryptographic Coin wallets have become much more ubiquitous, potentially through the use of CBDC. The land registry is still managed through the existing government-run entities, with the existing downsides, especially high costs and potential for fraud. In this scenario, we serve clients by a) registering their property on the blockchain, after checking with the current off-chain registry to verify that they are the owners and then consequently b) check the public registry every week to ensure that they are still entered there as the accredited owner. In the case the ownership has changed, we notify the customers, so that they can take appropriate measures to combat any potential fraud that may have occured. While this happens, Customers are getting more used to blockchain.

### Scenario 2:
In this second scenario, our service has replaced the traditional registry, and properties are now registered solely on the blockchain. Transfers are performed on the chain, reducing transaction costs greatly. Owner can issue NFTs issued against their property, which can serve as collateral to be used in mortgage- or other loans issued by both peers & traditional lenders such as banks.


## Tech Stack Used:
Frontend:
* Telegram Bot
* React Framework

Backend:
* Ethereum Blockchain
* Solidity
* [Infura](https:https://infura.io) to connect to Etherium network
* [Ropsten](https://faucet.ropsten.be/) testnetwork
* [Pinata](https://app.pinata.cloud/) for storing NFT metadata
* [Brownie](https://eth-brownie.readthedocs.io/en/stable/toctree.html) to compile and deploy contracts
* [Metamask](https://metamask.io/index.html) to manage wallets
