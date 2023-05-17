const ethers = require('ethers')
const {RelayProvider} = require('@opengsn/provider')
const paymasterAddress = require('../build/gsn/Paymaster.json').address


const contractArtifactABI = require('../build/Shop.json')

let theContract
let provider
let gsnProvider


async function initContract() {

    if (!window.ethereum) {
        throw new Error('provider not found')
    }

    gsnProvider = await RelayProvider.newProvider({
        provider: window.ethereum,
        config: {
            loggerConfiguration: {logLevel: 'debug'},
            paymasterAddress
        }
    }).init()

    provider = new ethers.providers.Web3Provider(gsnProvider)

    const network = "31337"
    const contractAddress = "0xca4211da53d1bbab819B03138302a21d6F6B7647" // shop address
    theContract = new ethers.Contract(
        contractAddress, contractArtifactABI, provider.getSigner())

    return {contractAddress, network}
}

async function contractCall() {
    const transaction = await theContract.transfer("0xca4211da53d1bbab819B03138302a21d6F6B7647", 10)
    console.log(transaction)
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

window.app = {
    initContract,
    contractCall,
    log
}
