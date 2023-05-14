#!/bin/bash

TOTAL_SHOPS=10
USER_ADDRESS=0x6fcdf3062b885f2baccebd2683c7a9259adb3375

echo "Please select an option:"
echo "1) Deploy ShopAggregator Contract"
echo "2) Create a Shop Contracts"
echo "3) Register a new user to the Shop Contracts"
echo "4) Tot up user balances to pay gas fees"
echo "5) Quit"

read option

case $option in
    1)
        echo "⚒️ Deploying ShopAggregator contract..."
        # forge script script/ShopAggregator.s.sol:ShopAggregatorScript --fork-url http://localhost:8545 --broadcast -vvv
        # Run the forge deployment command and save the output
        DEPLOY_OUTPUT=$(forge script script/ShopAggregator.s.sol:ShopAggregatorScript --fork-url http://localhost:8545 --broadcast -vvv)

        # Use a regex to find the contract address, specifically the one after "Contract Address: "
        CONTRACT_ADDRESS=$(echo "$DEPLOY_OUTPUT" | awk -F': ' '/Contract Address/ {print $2}')

         # Create .env file if it doesn't exist
        if [[ ! -f .env ]]; then
            touch .env
        fi

        # Write the address to .env
        echo "SHOP_AGGREGATOR_ADDRESS=$CONTRACT_ADDRESS" > .env
        echo $CONTRACT_ADDRESS
        ;;
    2)
        echo "⚒️ Running Shops creation script..."
        # Check if .env exists and source it. If not, exit the script.
        if [[ -f .env ]]; then
            source .env
        else
            echo "Error: .env file not found. Please execute the first script first."
            exit 1
        fi

        # Check if SHOP_AGGREGATOR_ADDRESS is present
        if [[ -z "$SHOP_AGGREGATOR_ADDRESS" ]]; then
            echo "SHOP_AGGREGATOR_ADDRESS not found in .env file. Please execute the first script first."
            exit 1
        fi

        # Dummy data for shop creation
        shop_names=("Test Shop 1" "Test Shop 2" "Test Shop 3" "Test Shop 4" "Test Shop 5" "Test Shop 6" "Test Shop 7" "Test Shop 8" "Test Shop 9" "Test Shop 10")
        shop_codes=("TSH1" "TSH2" "TSH3" "TSH4" "TSH5" "TSH6" "TSH7" "TSH8" "TSH9" "TSH10")
        shop_urls=("https://testshop1.com" "https://testshop2.com" "https://testshop3.com" "https://testshop4.com" "https://testshop5.com" "https://testshop6.com" "https://testshop7.com" "https://testshop8.com" "https://testshop9.com" "https://testshop10.com")

        echo "Running Shops creation script..."

        # for i in {0..9}
        for ((i=0; i<$TOTAL_SHOPS; i++));
        do
            cast send $SHOP_AGGREGATOR_ADDRESS --from 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266 "addShop(string, string, string, string, string, address)"  "${shop_names[$i]}" "${shop_codes[$i]}" "${shop_urls[$i]}" "123 Test Street" "1234567890" 0x70997970c51812dc3a010c7d01b50e0d17dc79c8
        done
        ;;
    3)
        echo "🪄 Registering a new user..."

        # Check if .env exists and source it. If not, exit the script.
        if [[ -f .env ]]; then
            source .env
        else
            echo "Error: .env file not found. Please execute the first script first."
            exit 1
        fi

        # Check if SHOP_AGGREGATOR_ADDRESS is present
        if [[ -z "$SHOP_AGGREGATOR_ADDRESS" ]]; then
            echo "SHOP_AGGREGATOR_ADDRESS not found in .env file. Please execute the first script first."
            exit 1
        fi


        # Get all shops
        raw=$(cast call $SHOP_AGGREGATOR_ADDRESS "getAllShops()")

      
        # Remove '0x' prefix
        raw=${raw:2}

        # We know each address is 40 characters long
        address_length=40

        # We know each offset is 64 characters long
        offset=64

        # Calculate the total length of the string
        total_length=${#raw}

        # Loop over each address from the end
        for ((i=1; i<=$TOTAL_SHOPS; i++)); do
            # Calculate the start of the address in the string (from the end)
            start=$((total_length - offset * i + 24))

            # Extract the address
            address="0x${raw:$start:$address_length}"
            echo "🆕 Registering user to $address shop"
            cast send $address --from 0x70997970c51812dc3a010c7d01b50e0d17dc79c8 "registerUser(address, uint256)"  $USER_ADDRESS 15000
        done
        ;;
    4)
        echo "🔥 Totting up user balances..."
        cast send $USER_ADDRESS --value "1ether" --from  0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
        ;;
    5)
        echo "Quitting..."
        exit 0
        ;;
    *)
        echo "Invalid option. Please choose a number from the menu."
        ;;
esac
