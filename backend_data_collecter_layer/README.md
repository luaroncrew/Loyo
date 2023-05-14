# Loyo Backend for data processing for GREENFIELD

## Flask server
```
python -m flask run
```
app.py runs a flask server that has only one endpoint:
- method: POST 
- url: /add 
valid json data example: 
```json
{
    "address": "0x12312468271351726312acfed",
    "item_name": "Pizza Margarita", 
    "item_type": "Fast Food",
    "country": "Italy",
    "shop_name": "Pizza Happy"
}
```

this method will be called
from the Loyo mobile app each time we 
have a successful bonus points spending.

data about this spending will then be 
added to the transactions.csv file, and this 
file will be pushed once a day on the GREENFIELD


## Greenfield CLI installation on the server
to install gnfd-cmd cli on the server:
1. install Go
2. ```
   git clone https://github.com/bnb-chain/greenfield-cmd.git
    cd greenfield-cmd
    make build
    cd build
    ./gnfd-cmd -h
    ```

3.add gnfd-cmd to path : `
    export PATH=$PATH:/Users/root/code/greenfield-cmd/build
`


## Connection with GREENFIELD
every day we're going to push this file from the 
server to the GREENFIELD data storage.

### setting up server:

So, on the server, we have to create ```config.toml``` :

```toml
endpoint = "https://gnfd-testnet-sp-1.bnbchain.org"
rpcAddr = "gnfd-testnet-fullnode-cosmos-us.bnbchain.org:9090"
chainId = "greenfield_5600-1"
privateKey = "xxxxxxx"
publicKey = "0x35979BDd030CF42508151FFEDd961263FC50133A"
PasswordFile = "password.txt"
passwordFile = "password.txt"
```

then with this config, 
generate a Keystore (required for
pushing files on the greenfield)

```shell
nano key.txt
```
insert the private key in this file

then run
```shell
gnfd-cmd gen-key --privKeyFile key.txt key.json
```


## Cron Job

after all the setup, start a cron job that will call the
```greenfield_push.sh``` script

this script contains the following command:

```shell
gnfd-cmd -c config.toml storage del-obj gnfd://loyo-application/transactions.csv
gnfd-cmd -c config.toml storage put --contentType "text/xml" --visibility private ./transactions.csv  gnfd://loyo-application/transactions.csv 
```

It will update the file transactions.csv on the GREENFIELD 




