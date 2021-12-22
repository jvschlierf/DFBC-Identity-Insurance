from brownie import Registry, Subscription, propNFT, accounts, config


def read_registry():
    return Registry[-1]

def read_subscription():
    return Subscription[-1]

def read_nft():
    return propNFT[-1]