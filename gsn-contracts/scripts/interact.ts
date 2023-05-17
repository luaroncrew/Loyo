import { ethers } from "ethers";

async function main() {
    const contractAddress = "0x3Aa5ebB10DC797CAC828524e59A333d0A371443c";
    const myContract = await ethers.
    const mintToken = await myContract.mint(1, { value: ethers.utils.parseEther("0.3") });

    console.log("Trx hash:", mintToken.hash);

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });