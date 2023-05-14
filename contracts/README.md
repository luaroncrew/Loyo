We're using foundry toolkit to build, test & deploy smart contracts. 

### Getting started
```sh
forge build # build contracts
forge test # test them

# Generate abi json files
forge inspect ShopAggregator abi > abi/ShopAggregator.json
forge inspect Shop abi > abi/Shop.json
```

### Running locally
```sh
chmod +x ./local.sh

./local.sh # run every options in the asc order. Make sure to provide USER_ADDRESS in local.sh by scanning it from the iPhone app.
```

### Development

When you update smart contracts, you'll need to update interfaces in the iOS app. Follow the instructions:
```sh
# Convert abi files into .swift for iOS app
npm i -g swiftabigen --location=global # install the tool
cd abi
npx swiftabigen Shop 
npx swiftabigen ShopAggregator
# Copy .swift files to app/Loyo
```

### Deployement
`ShopAggregator` is deployed to `0xD2AF1735ddFa496bC8Edd6a83b6Cf60b71Ba9692` on BSC testnet.
