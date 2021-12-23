from brownie import accounts, Registry, propNFT, Subscription, network
import os

def deploy_registry():
    account = get_account()
    # account.deploy(Registry, amount=100000000000)
    Registry.deploy({"amount": 100000000000000000, "gas_limit": 8000000, "from": account})
    # Registry.deploy({"from": account, "gas_limit": 8000000, "amount": 10000000})

def deploy_nft():
    account = get_account()
    # account.deploy(propNFT, amount = 100000000000)
    propNFT.deploy({"from": account})
    # propNFT.deploy({"from": account, "gas_limit":  8000000, "amount": 10000000})
    

def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.load("testacc")

def main():

    deploy_registry()
    deploy_nft()
    
    