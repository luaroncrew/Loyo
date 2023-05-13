# loyo_swift_app


# Demo

- Open the application for the first time (ethtereum wallet initialization)
  * no seed phrase shown to user
  * just a pop up saying that the wallet is initialized and the **user can start to get and spend bonus points**
  * behind we generate a private key, deriving a public key and storing this in the iphone storage (no need to use the Apple KeyChain, but could be interesting if we have time)

- Explain what the QR code means and how it works
  * please do not generate the new QR code, 
  let's use the one I have already generated. It's hardcoded and doesn't reflect the public key of our user, but for demo purpose it's ok

- Show different shops
  * There will be 6 shops in the demo. Let the first be the real token, and the rest is just hardcoded values.
  * As on the main page we see the balances for each shop, we need to fetch the balance of our user by calling the shopToken smart contract method

- Shop page
  * real world assets we can buy will be hardcoded. No need to fetch them from somewhere else.
  * the trickiest part. here I want to send shopTokens to a treasury address of a shop (will be hardcoded as well, 
  but later we can try to implement it as token contract method ^_^).
  After a user clicks on the "spend" button, I want a transaction to be
  generated and signed. 
