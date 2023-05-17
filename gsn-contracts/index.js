const Web3 = require('web3');
const { RelayProvider } = require('@opengsn/provider');
const ShopABI = require('./build/Shop.json').abi;

const config = { 
    paymasterAddress: "0x5FC8d32690cc91D4c39d9d3abcBD16989F875707",
    loggerConfiguration: {
        logLevel: 'debug'
    }

}

async function main() {
    const baseProvider = new Web3("http://localhost:8545");
    const provider = await RelayProvider.newProvider({ provider: baseProvider, config }).init()
    const web3 = new Web3(provider);

    const from = provider.newAccount().address
    const myRecipient = new web3.eth.Contract(ShopABI, "0x3Aa5ebB10DC797CAC828524e59A333d0A371443c");

    // Sends the transaction via the GSN
    const test = await myRecipient.methods.transfer().send({ from });
    console.log(test)

}

main()







const ethers = require('ethers')

const contractArtifact = require('../build/contracts/CaptureTheFlag.json')
const contractAbi = contractArtifact.abi

let theContract
let provider

async function initContract() {

    if (!window.ethereum) {
        throw new Error('provider not found')
    }
    window.ethereum.on('accountsChanged', () => {
        console.log('acct');
        window.location.reload()
    })
    window.ethereum.on('chainChanged', () => {
        console.log('chainChained');
        window.location.reload()
    })
    const networkId = await window.ethereum.request({method: 'net_version'})

    provider = new Web3("http://localhost:8545");

    // const network = await provider.getNetwork()
    // const artifactNetwork = contractArtifact.networks[networkId]
    // if (!artifactNetwork)
    //     throw new Error('Can\'t find deployment on network ' + networkId)
    // const contractAddress = artifactNetwork.address
    const network = "31337"
    const contractAddress = "0x3Aa5ebB10DC797CAC828524e59A333d0A371443c"
    theContract = new ethers.Contract(
        contractAddress, contractAbi, provider.getSigner())

    await listenToEvents()
    return {contractAddress, network}
}

async function contractCall() {
    await window.ethereum.send('eth_requestAccounts')

    const txOptions = {gasPrice: await provider.getGasPrice()}
    const transaction = await theContract.captureTheFlag(txOptions)
    const hash = transaction.hash
    console.log(`Transaction ${hash} sent`)
    const receipt = await transaction.wait()
    console.log(`Mined in block: ${receipt.blockNumber}`)
}

let logview

function log(message) {
    message = message.replace(/(0x\w\w\w\w)\w*(\w\w\w\w)\b/g, '<b>$1...$2</b>')
    if (!logview) {
        logview = document.getElementById('logview')
    }
    logview.innerHTML = message + "<br>\n" + logview.innerHTML
}

async function listenToEvents() {

    theContract.on('FlagCaptured', (previousHolder, currentHolder, rawEvent) => {
        log(`Flag Captured from&nbsp;${previousHolder} by&nbsp;${currentHolder}`)
        console.log(`Flag Captured from ${previousHolder} by ${currentHolder}`)
    })
}

window.app = {
    initContract,
    contractCall,
    log
}
