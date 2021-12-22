from brownie import accounts, Registry, propNFT, Subscription, network
# import os

def deploy_registry():
    account = get_account()
    # account.deploy(Registry, amount=100000000000)
    # Subscription.deploy({"from": account})
    Registry.deploy({"from": account, "amout": 100000000000})

def deploy_nft():
    account = get_account()
    # publish_source = True if os.getenv("ETHERSCAN_TOKEN") else False
    # account.deploy(propNFT, amount=100000000000)
    propNFT.deploy({"from": account, "amout": 100000000000})
    

def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.load("testacc")

def main():

    deploy_nft()
    deploy_registry()
    
    