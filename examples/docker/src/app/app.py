import requests

from flask import Flask
from flask_restful import Resource, Api

from config import BANK_DATA_URL


app = Flask(__name__)
api = Api(app)

def get_bank_data():
    url = BANK_DATA_URL
    response = requests.get(url)
    
    if response.status_code == 200:
        bank_data = response.json()
        return bank_data
    else:
        return None


## define resources
class Bank(Resource):
    def get(self):
        bank_data = get_bank_data()

        return {"result": bank_data}

class HelloWorld(Resource):
    def get(self):
        return {'hello': 'world'}

# add resources
api.add_resource(HelloWorld, '/hello')
api.add_resource(Bank, '/bank')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port='5000')