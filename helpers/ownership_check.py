import json
from web3 import Web3
import threading
import pandas as pd

def check_ownership(URL,contract,abi): # all inputs are strings
    #connect to the contract
    web3 = Web3(Web3.HTTPProvider(URL))
    web3.eth.defaultAccount = web3.eth.accounts[0]
    abi = json.loads(abi)
    address = web3.toChecksumAddress(contract)
    contract = web3.eth.contract(address = address, abi = abi)
    registry = pd.read_csv('LandRegistry.csv')
    
    #retreive info
    sub_count = contract.functions.show_sub_count().call()
        
    #modify format of indirizzo to have just the address plus civic number
    split = registry['indirizzo'].str.split(',',expand=True)
    split = split.fillna('')
    split[2] = split[2] + split[3]
    split = split.drop(3,axis=1)
    registry[['Città','Zona','indirizzo']] = split
    
    #check
    notify_list = [] 
    for i in range(sub_count):
        owner_address = contract.functions.subscribersList(i).call()
        owner_first_name, owner_last_name = contract.functions.findOwner(owner_address).call()
        owner_name = owner_first_name + ' ' + owner_last_name
        owned_properties = contract.functions.find_properties(owner_address).call()
        for x in owned_properties:
            prop_address = contract.functions.properties(x-1).call()[7] + ' ' + contract.functions.properties(x-1).call()[8]
            p = registry.loc[registry.indirizzo == prop_address]
            if p.Owner.values != owner_name:
                notify_list.append((owner_name,x)) #add both the owner_name and the property id where the mismatch has been found 
            # if we have their email or contact info in the registry contract we can append 
            # that instead of the owner name
    return notify_list

<<<<<<< HEAD
def check_ownership_single_customer(URL,contract,abi,address): # all inputs are strings
=======


def check_ownership_single_customer(URL,contract,abi,owner_address): # all inputs are strings
>>>>>>> 9f2f4c1a27cdda98a0eabca422e42c4adf7ee559
    #connect to the contract
    web3 = Web3(Web3.HTTPProvider(URL))
    web3.eth.defaultAccount = web3.eth.accounts[0]
    abi = json.loads(abi)
    address = web3.toChecksumAddress(contract)
    contract = web3.eth.contract(address = address, abi = abi)
    registry = pd.read_csv('LandRegistry.csv')
    
    #modify format of indirizzo to have just the address plus civic number
    split = registry['indirizzo'].str.split(',',expand=True)
    split = split.fillna('')
    split[2] = split[2] + split[3]
    split = split.drop(3,axis=1)
    registry[['Città','Zona','indirizzo']] = split
    
    #check
    notify = [] #initialize list of property ids that will be returned
    owner_first_name, owner_last_name = contract.functions.findOwner(owner_address).call()
    owner_name = owner_first_name + ' ' + owner_last_name
    owned_properties = contract.functions.find_properties(owner_address).call()
    for x in owned_properties:
        prop_address = contract.functions.properties(x-1).call()[7] + ' ' + contract.functions.properties(x-1).call()[8]
        p = registry.loc[registry.indirizzo == prop_address]
        if p.Owner.values != owner_name:
            notify.append(x) #append the property id for which a mismatch has been found
    return notify
<<<<<<< HEAD
	
=======


>>>>>>> 9f2f4c1a27cdda98a0eabca422e42c4adf7ee559
#function for that loops check_onwership every 7 days 

t = None

def loop():
    global t
    to_notify = check_ownership(URL,address,abi)
    #have some function to send the alert to the customers in the to_notify list
    t = threading.Timer(86400)
    t.start()
    
    
# to stop the loop just call t.cancel()