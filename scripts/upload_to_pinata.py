import os

PINATA_BASE_URL = 'https://app.pinata.cloud'
endpoint = '/pinning/pinFileToIPFS'

filename = '' # should be the input from the user

headers = {'pinata_api_key': os.getenv('PINATA_API_KEY'),
            'pinata_secret_api_key': os.getenv('PINATA_API_SECRET') 
}



