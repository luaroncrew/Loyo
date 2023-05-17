import { ethers } from "hardhat";
import forwarder from "../build/gsn/Forwarder.json";

const USER_ADDRESS = "0x6fcdf3062b885f2baccebd2683c7a9259adb3375";
const SHOP_OWNER_ADDRESS = "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266";
const INITIAL_BALANCE = 1000000;

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
      SHOP_OWNER_ADDRESS,
      forwarder.address
    )    
  }

  // get all shops
  const shops = await shopAggregator.getAllShops()

  for await (const shop of shops) {
    // register user on each Shop contract by initializing contract from address
    const Shop = await ethers.getContractFactory("Shop");
    const shopContract = Shop.attach(shop)
    await shopContract.registerUser(USER_ADDRESS, INITIAL_BALANCE);
  }
  console.log("shops", shops)
}

deployShopAggregator().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
