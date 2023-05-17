import { ethers } from "hardhat";
import forwarder from "../build/gsn/Forwarder.json";

async function main() {
  const forwarderAddress = forwarder.address

  const Shop = await ethers.getContractFactory("Shop");
  const shop = await Shop.deploy(
    "Test Shop",
    "TSH",
    "https://testshop.com",
    "123 Test Street",
    "1234567890",
    forwarderAddress
  );

  await shop.deployed();

  // call a method on a shop contract
  const shopName = await shop.registerUser("0xF9D8214560b24ea13ddf6E98ae875fEA11C01684", 1500000);

  console.log(
    `Shop deployed to ${shop.address}`
  );
}

async function deployShopAggregator() {
  const ShopAggregator = await ethers.getContractFactory("ShopAggregator");
  const shopAggregator = await ShopAggregator.deploy();

  const aggregator = await shopAggregator.deployed();
  console.log("ShopAggregator deployed to:", aggregator.address)

  // create 5 shops
  for (let i = 0; i < 5; i++) {
    await shopAggregator.addShop(
      `Test Shop ${i}`,
      `TSH${i}`,
      `https://testshop${i}.com`,
      `123 Test Street ${i}`,
      `123456789${i}`,
      "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266",
      forwarder.address
    )    
  }

  // get all shops
  const shops = await shopAggregator.getAllShops()

  // const shops = [
  //   '0xca4211da53d1bbab819B03138302a21d6F6B7647',
  //   '0xE7402c51ae0bd667ad57a99991af6C2b686cd4f1',
  //   '0xED53ee55B63FCD7842D009481c6DC5Af66Ba2e1e',
  //   '0xD8833987A077C5E9c25c08171c24C5e77F21DddD',
  //   '0x51E0B0F516748cbD7c8a689C9ed2B01E83E64e3D'
  // ]

  for await (const shop of shops) {
    // register user on each Shop contract by initializing contract from address
    const Shop = await ethers.getContractFactory("Shop");
    const shopContract = Shop.attach(shop)
    await shopContract.registerUser("0x6fcdf3062b885f2baccebd2683c7a9259adb3375", 1000000);
  }
  console.log("shops", shops)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
deployShopAggregator().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
