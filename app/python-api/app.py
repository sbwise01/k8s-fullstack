#!/usr/bin/env python

import os
from flask import Flask, request

app = Flask(__name__)
@app.route('/', defaults={'u_path': ''})
@app.route('/<path:u_path>')
def main(u_path):
    if 'AWS_EXECUTION_ENV' in os.environ:
        exeenv = os.getenv('AWS_EXECUTION_ENV')
    else:
        exeenv = "NOT FOUND"
    if 'APP_NAME' in os.environ:
        appName = os.getenv('APP_NAME')
    else:
        appName = "N/A"
        
    if 'API_KEY' in os.environ:
        apiKey = os.getenv('API_KEY')
    else:
        apiKey = "NOT FOUND"

    return "Hello World ... welcome to Flask!  AWS_EXECUTION_ENV=%s, APP_NAME=%s, Path=%s API_KEY=%s" % (exeenv,appName,u_path,apiKey)

if __name__ == "__main__":
    app.run()

