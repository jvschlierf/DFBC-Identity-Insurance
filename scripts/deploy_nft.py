from brownie import accounts, Registry, propNFT, Subscription, network
# import os

def deploy_registry():
    account = get_account()
    print(network.show_active())
    Registry.deploy({"from": account})
    Subscription.deploy({"from": account})

def deploy_nft():
    account = get_account()
    print(network.show_active())
    # publish_source = True if os.getenv("ETHERSCAN_TOKEN") else False
    propNFT.deploy({"from": account})

def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.load("testacc")

# def main():
#     deploy_registry()