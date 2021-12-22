from brownie import accounts, Registry, propNFT, Subscription, network


def deploy_registry():
    account = get_account()
    Registry.deploy({"from": account})
    propNFT.deploy({"from": account})
    Subscription.deploy({"from": account})
   


def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.load("testacc")


def main():
    deploy_registry()