# LOYO

Loyo is the new generation loyalty program infrastructure.

### For clients: 
- no personal data required to get and spend loyalty rewards
- easy-to-use application, all commercials promos at one place

### For businesses: 
- 500x less infrastructure costs
- open decentralized data about clients' transactions with endless insight opportunities.

### Check our pitch deck:
https://pitch.com/public/71f1c5f5-f052-40e3-9867-873ae42f7eaf]

### Running project locally:
To run the project locally, please, check `./contract` README.
You'll have to execute a very simple bash script to deploy smart contracts and register a user.

### GSN aka gasless transactions:
We are planning to add support for gasless transactions. The user will not require BNB tokens to pay with loyalty points. For this, we have begun writing a relayer server and added a new method to `app/Loyo/BlockchainConnector` - `executeRelayedPayment`. This part took quite a lot of time, as signing the transaction through the web3.swift library by argentlabs guys was not easy. We also plan to use the GSN Starter Kit for our Shop smart contracts.