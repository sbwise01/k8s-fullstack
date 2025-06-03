def lambda_handler(event, context):
    request = event['Records'][0]['cf']['request']
    headers = request['headers']

    botControlHeader = headers.get('x-amzn-waf-bot-control')
    if botControlHeader:
        botControl = botControlHeader[0]['value']
        if botControl == "bot":
            print("Bot Control Header is %s" % botControl)
            request['origin'] = {
                'custom': {
                    'domainName': 'www.google.com',
                    'port': 443,
                    'protocol': 'https',
                    'path': '',
                    'sslProtocols': ['TLSv1', 'TLSv1.1'],
                    'readTimeout': 5,
                    'keepaliveTimeout': 5,
                    'customHeaders': {}
                }
            }
            request['headers']['host'] = [{'key': 'host', 'value': 'www.google.com'}]
        else:
            print("Bot Control Header found bot")
    else:
        print("Did not find Bot Control Header")

    return request
