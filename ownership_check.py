import json
from web3 import Web3
import threading

def check_ownership(URL,contract,abi): # all inputs are strings
    #connect to the contract
    web3 = Web3(Web3.HTTPProvider(URL))
    web3.eth.defaultAccount = web3.eth.accounts[0]
    abi = json.loads(abi)
    address = web3.toChecksumAddress(contract)
    contract = web3.eth.contract(address = address, abi = abi)
    registry = pd.read_csv('LandRegistry.csv')
    
    #retreive info
    properties = contract.functions.properties().call()
    owners = contract.functions.owners().call()
    prop_to_owner = contract.functions.propertyToOwner().call()
    address_to_owner = contract.functions.address_to_owner().call()
        
    #modify format of indirizzo to have just the address plus civic number
    split = registry['indirizzo'].str.split(',',expand=True)
    split = split.fillna('')
    split[2] = split[2] + split[3]
    split = split.drop(3,axis=1)
    registry[['Città','Zona','indirizzo']] = split
    
    #find the entry for address in registry
    #and compare owner entry with name to see if they match
    prop = registry.loc[registry.indirizzo == address]
    
    #check
    notify_list = [] 
    for prop in properties:
        owner_address = prop_to_owner[prop.id]
        owner_name = owners[address_to_owner[owner_address]]
        prop_address = prop.street + ' ' + prop.streetnum
        p = registry.loc[registry.indirizzo == prop_address]
        if p.Owner.values != owner_name:
            notify_list.append(owner_name) 
            # if we have their email or contact info in the registry contract we can append 
            # that instead of the owner name
    
    return notify_list


#function for that loops check_onwership every 7 days 


t = None

def loop():
    global t
    to_notify = check_ownership(URL,address,abi)
    #have some function to send the alert to the customers in the to_notify list
    t = threading.Timer(86400)
    t.start()
    
    
# to stop the loop just call t.cancel()