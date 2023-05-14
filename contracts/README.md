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
