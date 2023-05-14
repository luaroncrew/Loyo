import { Injectable } from '@nestjs/common';
import { Interface, ethers } from 'ethers';

@Injectable()
export class TransactionsService {
  private provider: ethers.JsonRpcProvider;
  private relayerWallet: ethers.Wallet;

  constructor() {
    const url = 'http://localhost:8545';
    this.provider = new ethers.JsonRpcProvider(url);
    this.relayerWallet = new ethers.Wallet(
      '<your private key here>',
      this.provider,
    );
  }

  async relayTransaction(userSignedTx: string) {
    // parse the user's signed transaction
    const iface = new Interface([
      'function transferFrom(address from, address to, uint amount)',
      'function transfer(address to, uint amount)',
    ]);

    // create a new transaction that calls the same function with the same parameters as the original transaction
    const relayTransaction = {
      to: 'to',
      data: userSignedTx,
      nonce: await this.relayerWallet.getNonce(),
      gasPrice: await this.provider.send('eth_gasPrice', []),
      // gasLimit: await this.provider.estimateGas(transaction),
    };

    // sign the transaction with the relayer's wallet

    // send the signed transaction to the BSC network

    // wait for transaction to be mined
    const receipt = '<tx receipt>';

    return receipt;
  }
}
