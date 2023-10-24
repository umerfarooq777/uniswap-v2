
const { ethers } = require("hardhat");
const hre = require("hardhat");



const token0 = '0xbaf672de325A4E6beB6a43640C1609C279a75e0a'; //CIP
const OLDcip = '0x776884C2c1e522B6d9664384162dD399C3344467'; //old cip
const token1 = '0xe08ce0fB041BE5c489c82EFcb0b26FB8dDFF780c' //DAI
const oracle = '0x0DEe979D8157cd9c7Bf4EB82abF423C57A571758' //Oracle Price
const factory = '0x1F98431c8aD98523631AE4a59f267346ea31F984' //UniswapV3 Factory
const owner = '0x7A675d2485924E19A7C43E540B08b8f4d7426884' //owner
const fees = 3000
const CAPPING = 1;

async function main() {
 // This is just a convenience check
  if (network.name === "hardhat") {
    console.warn(
      "You are trying to deploy a contract to the Hardhat Network, which" +
        "gets automatically created and destroyed every time. Use the Hardhat" +
        " option '--network localhost'"
    );
  
    }
    const [deployer] = await ethers.getSigners();


    // USDC = await ethers.getContractFactory("USDC")
    // usdc = await USDC.deploy()
    // await usdc.deployed()
    // console.log("USDC Address", usdc.address)

    // CIP = await ethers.getContractFactory("CIP")
    // cip = await CIP.deploy(deployer.getAddress(),deployer.getAddress(),deployer.getAddress(),deployer.getAddress(),deployer.getAddress(),owner,OLDcip)
    // await cip.deployed()
    // console.log("CIP Address", cip.address)

    // UniswapV3Twap = await ethers.getContractFactory("UniswapV3Twap");
    // oracle = await UniswapV3Twap.deploy(factory,token0,token1,fees);
    // await oracle.deployed();
    // console.log("UniswapV3Twap Address", oracle.address);

    CIPMain = await ethers.getContractFactory("CIPMain")
    cipMain = await CIPMain.deploy(deployer.getAddress(),oracle,CAPPING)
    await cipMain.deployed()
    console.log("CIPMain Address", cipMain.address);

}




main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });