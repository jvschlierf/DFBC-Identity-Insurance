import requests
import os
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()

PINATA_BASE_URL = 'https://api.pinata.cloud/'
endpoint = 'pinning/pinFileToIPFS'

headers = {'pinata_api_key': API_Key,
           'pinata_secret_api_key': API_Secret}

def upload_to_pinata(filepath, filename):
    with Path(filepath).open("rb") as fp:
        response = requests.post(PINATA_BASE_URL + endpoint,
                                 files={"file": (filename, fp)},
                                 headers=headers)

        ipfs_hash = response.json()['IpfsHash']
        filename = filepath.split("/")[-1:][0]
        uri = "https://ipfs.io/ipfs/{}?filename={}".format(ipfs_hash, filename)
        
    return uri
