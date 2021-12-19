import requests
import os
from pathlib import Path
from dotenv import load_dotenv
load_dotenv()

#Pinata API
API_Key = 'ccbebfd0bead0305d402'
API_Secret = '0246b9b984a25470d524a988d70f276d621d49a9c58f299283bd8bf8e4563bf5'
JWT = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySW5mb3JtYXRpb24iOnsiaWQiOiI2YWYyOGIxMS03OGIyLTRkYjEtYTI1Yy1hNWJiYjQ0NmQ5NTIiLCJlbWFpbCI6ImJlYS5ndWlkb3R0aUBsaWJlcm8uaXQiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicGluX3BvbGljeSI6eyJyZWdpb25zIjpbeyJpZCI6IkZSQTEiLCJkZXNpcmVkUmVwbGljYXRpb25Db3VudCI6MX1dLCJ2ZXJzaW9uIjoxfSwibWZhX2VuYWJsZWQiOmZhbHNlfSwiYXV0aGVudGljYXRpb25UeXBlIjoic2NvcGVkS2V5Iiwic2NvcGVkS2V5S2V5IjoiY2NiZWJmZDBiZWFkMDMwNWQ0MDIiLCJzY29wZWRLZXlTZWNyZXQiOiIwMjQ2YjliOTg0YTI1NDcwZDUyNGE5ODhkNzBmMjc2ZDYyMWQ0OWE5YzU4ZjI5OTI4M2JkOGJmOGU0NTYzYmY1IiwiaWF0IjoxNjM5OTMxMTAyfQ.WgnOW9731uvFsgR7kDxkJ_WtBLX5Sl5UDoE1JQxW6RE'

PINATA_BASE_URL = 'https://api.pinata.cloud/'
endpoint = 'pinning/pinFileToIPFS'

headers = {'pinata_api_key': API_Key,
           'pinata_secret_api_key': API_Secret}

#Function that creates a json file with the metadata in the proper format
def create_URI(property_id, property_address_country, property_address_region,
                    property_address_city, property_address_street,
                    property_address_streetnum, property_addressAdditional):
    filename = "metadata_property_{}".format(property_id)
    
    #load the sample json file
    with open('sample_jsonURI.json') as j:
        jsonfile = json.loads(json.load(j))
    
        #update metadata
        jsonfile['attributes'][0]['id'] = property_id
        jsonfile['attributes'][0]['country'] = property_address_country
        jsonfile['attributes'][0]['region'] = property_address_region
        jsonfile['attributes'][0]['city'] = property_address_city
        jsonfile['attributes'][0]['street'] = property_address_street
        jsonfile['attributes'][0]['number'] = property_address_streetnum
        jsonfile['attributes'][0]['additional_info'] = property_addressAdditional

    #Create the URI
        response = requests.post(PINATA_BASE_URL + endpoint,
                                 files={"file": (filename, json.dumps(jsonfile))},
                                 headers=headers)

    ipfs_hash = response.json()['IpfsHash']
    filename = filepath.split("/")[-1:][0]
    image_uri = "https://ipfs.io/ipfs/{}?filename={}".format(ipfs_hash, filename)
    return image_uri
