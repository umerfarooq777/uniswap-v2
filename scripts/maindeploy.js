 // We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { ethers } = require("hardhat");
const hre = require("hardhat");


// This is a script for deploying your contracts. You can adapt it to deploy
// yours, or create new ones.
const token0 = '0x50b871fb5bba2895425e5fc6eba219197f21d6d5'; //CIP
const token1 = '0xaf88d065e77c8cc2239327c5edb3a432268e5831' //USDC
const factory = '0x1F98431c8aD98523631AE4a59f267346ea31F984' //UniswapV3 Factory
const owner = '0x7527a16339d902067a8079d8db7b3a673a641b9d' //CIP Owner
const fees = 3000

async function main() {
 // This is just a convenience check
  if (network.name === "hardhat") {
    console.warn(
      "You are trying to deploy a contract to the Hardhat Network, which" +
        "gets automatically created and destroyed every time. Use the Hardhat" +
        " option '--network localhost'"
    );
  }


  const [deployer,per1,per2,per3,per4,per5,per6,per7,per8,per9,per10] = await ethers.getSigners();

  //Impersonation  
  const tx = {
    to: owner,
    value: ethers.utils.parseEther("100"),
  };

 //Sending Money 
  await deployer.sendTransaction(tx);

  await network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [owner],
  });

  const signer = await ethers.getSigner(owner);

  console.log("Impersonation Done");
  
 //Deploy UnsiwapV3 Price Getter
 UniswapV3Twap = await ethers.getContractFactory("UniswapV3Twap");
 oracle = await UniswapV3Twap.deploy(factory,token0,token1,fees);
 await oracle.deployed();
 console.log("UniswapV3Twap Address", oracle.address);
const value = ethers.utils.parseUnits("1","18")
const res =await oracle.estimateAmountOut(token0,value,10)
console.log(res)

// //////////////////////////CryptoIndexPool/////////////////////////////////////

CryptoIndexPool = await ethers.getContractAt("CryptoIndexPool",token0);
const connection = CryptoIndexPool.connect(signer)
const bal = await CryptoIndexPool.balanceOf(signer.getAddress())  
console.log("Signer Balance",bal)
await connection.transfer(deployer.getAddress(),ethers.utils.parseEther("100000"))
await connection.transfer(per1.getAddress(),ethers.utils.parseEther("100000"))
await connection.transfer(per2.getAddress(),ethers.utils.parseEther("100000"))
await connection.transfer(per3.getAddress(),ethers.utils.parseEther("100000"))
await connection.transfer(per4.getAddress(),ethers.utils.parseEther("100000"))
await connection.transfer(per5.getAddress(),ethers.utils.parseEther("100000"))
await connection.transfer(per6.getAddress(),ethers.utils.parseEther("100000"))
await connection.transfer(per7.getAddress(),ethers.utils.parseEther("100000"))
await connection.transfer(per8.getAddress(),ethers.utils.parseEther("100000"))
await connection.transfer(per9.getAddress(),ethers.utils.parseEther("100000"))
await connection.transfer(per10.getAddress(),ethers.utils.parseEther("100000"))
// const bal = await CryptoIndexPool.balanceOf(signer.getAddress())  
console.log("Token Transfering Done") 

const acc1a = CryptoIndexPool.connect(per1)
const acc2a = CryptoIndexPool.connect(per2)
const acc3a = CryptoIndexPool.connect(per3)
const acc4a = CryptoIndexPool.connect(per4)
const acc5a = CryptoIndexPool.connect(per5)
const acc6a = CryptoIndexPool.connect(per6)
const acc7a = CryptoIndexPool.connect(per7)
const acc8a = CryptoIndexPool.connect(per8)
const acc9a  = CryptoIndexPool.connect(per9)
const acc10a  = CryptoIndexPool.connect(per10)


//////////////////////////CIPMain/////////////////////////////////////

CIPMain = await ethers.getContractFactory("CIPMain");
cipMain = await CIPMain.deploy(token0,deployer.getAddress(),oracle.address);
await cipMain.deployed();
console.log("CIPMain Address", cipMain.address);

//////////////////////calling Function///////////////////////////////////////////

console.log("Giving Approval With All accounts")
await CryptoIndexPool.approve(cipMain.address,ethers.utils.parseEther("40000")) 
await acc1a.approve(cipMain.address,ethers.utils.parseEther("40000")) 
await acc2a.approve(cipMain.address,ethers.utils.parseEther("40000"))
await acc3a.approve(cipMain.address,ethers.utils.parseEther("40000"))
await acc4a.approve(cipMain.address,ethers.utils.parseEther("40000"))
await acc5a.approve(cipMain.address,ethers.utils.parseEther("40000"))
await acc6a.approve(cipMain.address,ethers.utils.parseEther("40000"))
await acc7a.approve(cipMain.address,ethers.utils.parseEther("40000"))
await acc8a.approve(cipMain.address,ethers.utils.parseEther("40000"))
await acc9a.approve(cipMain.address,ethers.utils.parseEther("40000"))
await acc10a.approve(cipMain.address,ethers.utils.parseEther("100000"))

console.log("Done with the Approval")

console.log("Starting Staking")

const address0 = '0x0000000000000000000000000000000000000000';

const acc1  = cipMain.connect(per1)  
const acc2  = cipMain.connect(per2)
const acc3  = cipMain.connect(per3)
const acc4  = cipMain.connect(per4)
const acc5  = cipMain.connect(per5)
const acc6  = cipMain.connect(per6)
const acc7  = cipMain.connect(per7)
const acc8  = cipMain.connect(per8)
const acc9  = cipMain.connect(per9)
const acc10  = cipMain.connect(per10)


// const res2 = await oracle.estimateAmountOut(token1,ethers.utils.parseUnits("500",'6'),10);
// console.log(res2)
await cipMain.staking(ethers.utils.parseEther("40000"),address0)  
await acc1.staking(ethers.utils.parseEther("40000"),address0) 
await acc2.staking(ethers.utils.parseEther("40000"),address0)
await acc3.staking(ethers.utils.parseEther("40000"),per1.getAddress())
await acc4.staking(ethers.utils.parseEther("40000"),per3.getAddress())
await acc5.staking(ethers.utils.parseEther("40000"),per3.getAddress())
await acc6.staking(ethers.utils.parseEther("40000"),per5.getAddress())
await acc7.staking(ethers.utils.parseEther("40000"),per6.getAddress())
await acc8.staking(ethers.utils.parseEther("40000"),per2.getAddress())
await acc9.staking(ethers.utils.parseEther("40000"),per7.getAddress())
await acc10.staking(ethers.utils.parseEther("100000"),deployer.getAddress())

console.log("Staking Done")



}



main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });


// npx hardhat run scripts\deploy.js --network rinkeby