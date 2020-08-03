from flask import Flask
from datetime import datetime
import json

app = Flask(__name__)

@app.route('/')
def main():
	now = datetime.utcnow()
	date_and_time = {"date": now.strftime("%m/%d/%Y"), "time": now.strftime("%H:%M:%S")}
	return json.dumps(date_and_time)

if __name__ == "__main__": 
    app.run(host ='0.0.0.0', port = 5000, debug = True)