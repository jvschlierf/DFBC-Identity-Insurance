import requests
import os
from pathlib import Path
from dotenv import load_dotenv
import json
import csv
import os
import time

load_dotenv()

#Pinata API
# API_Key = 'ccbebfd0bead0305d402'
# API_Secret = '0246b9b984a25470d524a988d70f276d621d49a9c58f299283bd8bf8e4563bf5'
# JWT = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySW5mb3JtYXRpb24iOnsiaWQiOiI2YWYyOGIxMS03OGIyLTRkYjEtYTI1Yy1hNWJiYjQ0NmQ5NTIiLCJlbWFpbCI6ImJlYS5ndWlkb3R0aUBsaWJlcm8uaXQiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicGluX3BvbGljeSI6eyJyZWdpb25zIjpbeyJpZCI6IkZSQTEiLCJkZXNpcmVkUmVwbGljYXRpb25Db3VudCI6MX1dLCJ2ZXJzaW9uIjoxfSwibWZhX2VuYWJsZWQiOmZhbHNlfSwiYXV0aGVudGljYXRpb25UeXBlIjoic2NvcGVkS2V5Iiwic2NvcGVkS2V5S2V5IjoiY2NiZWJmZDBiZWFkMDMwNWQ0MDIiLCJzY29wZWRLZXlTZWNyZXQiOiIwMjQ2YjliOTg0YTI1NDcwZDUyNGE5ODhkNzBmMjc2ZDYyMWQ0OWE5YzU4ZjI5OTI4M2JkOGJmOGU0NTYzYmY1IiwiaWF0IjoxNjM5OTMxMTAyfQ.WgnOW9731uvFsgR7kDxkJ_WtBLX5Sl5UDoE1JQxW6RE'

PINATA_BASE_URL = 'https://api.pinata.cloud/'

ENDPOINT = 'pinning/pinFileToIPFS'
HEADERS = {'pinata_api_key': os.getenv('PINATA_API_KEY'),
           'pinata_secret_api_key': os.getenv('PINATA_API_SECRET')}


def write_metadata(property_id, property_address_country, property_address_region,
                    property_address_city, property_address_street,
                    property_address_streetnum, cap, property_type, floors, property_size):

    with open('sample_jsonURI.json') as j:
        jsonfile = json.loads(json.load(j))

        #update metadata
        jsonfile['attributes'][0]['id'] = property_id
        jsonfile['attributes'][0]['country'] = property_address_country
        jsonfile['attributes'][0]['region'] = property_address_region
        jsonfile['attributes'][0]['city'] = property_address_city
        jsonfile['attributes'][0]['street'] = property_address_street
        jsonfile['attributes'][0]['number'] = property_address_streetnum
        jsonfile['attributes'][0]['cap'] = cap
        jsonfile['attributes'][0]['property_type'] = property_type
        jsonfile['attributes'][0]['floors'] = floors
        jsonfile['attributes'][0]['size'] = property_size
        
        jsonfile.close()

#Function that creates a json file with the metadata in the proper format
def create_URI(property_id, property_address_country, property_address_region,
                property_address_city, property_address_street,
                property_address_streetnum, cap, property_type, floors, property_size):
                
    filename = "metadata_property_{}".format(property_id)
    item = {'filename': 'filename'}

    # storing all uplaoded metadata URIs
    fileWriter = open('uploadedNFT.csv','a', encoding="utf-8")

    if not os.path.exists('uploadedNFT.csv'):
        fieldnames = ['filename','ipfsHash', 'URI']
        dictWriter = csv.DictWriter(fileWriter, fieldnames)
        dictWriter.writeheader()
   
    #load the sample json file
    write_metadata(property_id, property_address_country, property_address_region,\
                    property_address_city, property_address_street,\
                    property_address_streetnum, cap, property_type, floors, property_size)

    #Create the URI
    response = requests.post(PINATA_BASE_URL + ENDPOINT,
                                 files={"file": (filename, open('sample_jsonURI.json'))},
                                 headers=HEADERS)
    retry=0
    while(resp.status_code != 200 and retry < 3):
        retry +=1
        print("attempt {}...".format(retry+1),end='',flush=True)
        time.sleep(15)
        resp = requests.post(PINATA_BASE_URL + ENDPOINT,
                                files={"file": (filename, open('sample_jsonURI.json'))},
                                headers=HEADERS)

    if(resp.status_code == 200):

        print(f"{filename} upload successful")

        ipfs_hash = response.json()['IpfsHash']
        token_uri = "https://ipfs.io/ipfs/{}?filename={}".format(ipfs_hash, filename)

        item['ipfsHash'] = ipfs_hash
        item['URI'] = token_uri
        fileWriter.write(item)
        fileWriter.close()

        return token_uri

    else:
        print(f"{filename} upload failed.")




