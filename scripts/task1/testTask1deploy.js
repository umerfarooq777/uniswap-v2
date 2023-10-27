
const { ethers } = require("hardhat");
const hre = require("hardhat");



// const token0 = '0xbaf672de325A4E6beB6a43640C1609C279a75e0a'; //CIP
// const OLDcip = '0x776884C2c1e522B6d9664384162dD399C3344467'; //old cip
// const token1 = '0xe08ce0fB041BE5c489c82EFcb0b26FB8dDFF780c' //DAI
// const oracle = '0x0DEe979D8157cd9c7Bf4EB82abF423C57A571758' //Oracle Price
// const factory = '0x1F98431c8aD98523631AE4a59f267346ea31F984' //UniswapV3 Factory
// const owner = '0x808f0597D8B83189ED43d61d40064195F71C0D15' //owner
// const fees = 3000
// const CAPPING = 1;


// const factoryV2 = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f"
// const routerV2 = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D"


const tokenAmount = (val) => {
  return ethers.utils.parseEther(String(val))
}

async function main() {
  // This is just a convenience check
  if (network.name === "hardhat") {
    //!=============================================== HARDHAT
    console.warn(
      "You are trying to deploy a contract to the Hardhat Network, which" +
      "gets automatically created and destroyed every time. Use the Hardhat" +
      " option '--network localhost'"
    );

  }
  const [deployer, per1, per2] = await ethers.getSigners();


  console.log("=== DEPLOYER ===", deployer.address);

  // factoryV2Contract = await ethers.getContractAt("FactoryV2", factoryV2)
  // routerV2Contract = await ethers.getContractAt("RouterV2", routerV2)
  TokenContract = await ethers.getContractFactory("TokenContract")
  TestUniswap1Contract = await ethers.getContractFactory("TestUniswap1")


  tokenContract1 = await TokenContract.deploy("Apple Token", "APPLE", 10000000) //10 million tokens
  console.log("============ DEPLOYMENT ============");
  await tokenContract1.deployed()
  console.log("tokenContract1 Address", tokenContract1.address)

  tokenContract2 = await TokenContract.deploy("Mango Token", "MANGO", 10000000) //10 million tokens
  await tokenContract2.deployed()
  console.log("tokenContract2 Address", tokenContract2.address)

  testUniswap1Contract = await TestUniswap1Contract.deploy()
  await testUniswap1Contract.deployed()
  console.log("testUniswap1Contract Address", testUniswap1Contract.address)


  // console.log("============ CREATING POOL ============");

  // const createPoolTx = await factoryV2Contract.createPair(tokenContract1.address, tokenContract2.address);
  // await createPoolTx.wait()
  // // console.log("createPoolTx", createPoolTx)
  // // console.log("factoryV2Contract", factoryV2Contract)

  // const poolAddress = await factoryV2Contract.getPair(tokenContract1.address, tokenContract2.address);
  // console.log("poolAddress", poolAddress)

  // poolContract = await ethers.getContractAt("PairV2", poolAddress)



  // const _1000Tokens = tokenAmount(1000)
  // await tokenContract1.approve(routerV2Contract.address, _1000Tokens);
  // await tokenContract2.approve(routerV2Contract.address, _1000Tokens);

  // console.log("============ ADDINGING LIQUIDITY ============");

  // await routerV2Contract.addLiquidity(
  //   tokenContract1.address,    // address tokenContract1 
  //   tokenContract2.address, //address tokenContract2
  //   _1000Tokens, //amountADesired
  //   _1000Tokens, //amountBDesired
  //   _1000Tokens, //amountAMin
  //   _1000Tokens, //amountBMin
  //   deployer.getAddress(), //to
  //   Math.floor(Date.now() / 1000) + 60 * 10 //deadline
  //   // currentTime
  // );

  // const ownerPoolBal = await poolContract.balanceOf(deployer.getAddress());
  // console.log(`balance LP: ${ownerPoolBal}`); //999999999999999999000


  // const query0 = await poolContract.getReserves();
  // console.log("Number of Token A in the pool rightnow", query0[0].toString()); //1000.000000000000000000
  // console.log("Number of Token B in the pool rightnow", query0[1].toString()); //1000.000000000000000000

  // //deployer sending 500 to p1
  // const _500Token = tokenAmount(500)
  // await tokenContract1.transfer(per1.address, _500Token)

  // console.log("============ USER 2 getting TOKEN 100 B ============");

  // const per1_routerV2Con = await routerV2Contract.connect(per1)
  // const per1_tokenContract1 = await tokenContract1.connect(per1)
  // //p1 adding token to pool sending 500 to p1
  // await per1_tokenContract1.approve(routerV2Contract.address, _500Token);

  // const _100Token = tokenAmount(100)
  // const tx2 = await per1_routerV2Con.getAmountsIn(_100Token, [tokenContract1.address, tokenContract2.address])
  // console.log("result for buying Token B", tx2)
  // // [
  // //   BigNumber { value: "111445447453471525689" },
  // //   BigNumber { value: "100000000000000000000" }
  // // ]
  // console.log("Buying Token B..........")
  // const tx3 = await per1_routerV2Con.swapExactTokensForTokens(tx2[0], tx2[1], [tokenContract1.address, tokenContract2.address], per1.address, Math.floor(Date.now() / 1000) + 5 * 10)
  // console.log("acc 2 balance of tokenContract1", await tokenContract1.balanceOf(per1.address))
  // console.log("acc 2 balance of tokenContract2", await tokenContract2.balanceOf(per1.address))

  // const query2 = await poolContract.getReserves();
  // console.log("Number of Token A in the pool rightnow", query2[0].toString());
  // console.log("Number of Token B in the pool rightnow", query2[1].toString());



  // console.log("============ USER 2 getting TOKEN 50 A ============");

  // //!================================get token 1
  // const _50Token = tokenAmount(50)

  // const tx5 = await per1_routerV2Con.getAmountsIn(_50Token, [tokenContract2.address, tokenContract1.address])
  // console.log("3rd estimation for buying Token A", tx5)



  // const per1_tokenContract2 = await tokenContract2.connect(per1)
  // await per1_tokenContract2.approve(routerV2Contract.address, _50Token);

  // console.log("Buying Token A...........")
  // const tx6 = await per1_routerV2Con.swapExactTokensForTokens(tx5[0], tx5[1], [tokenContract2.address, tokenContract1.address], per1.address, Math.floor(Date.now() / 1000) + 5 * 10)
  // console.log("acc 2 balance of tokenContract1", await tokenContract1.balanceOf(per1.address))
  // console.log("acc 2 balance of tokenContract2", await tokenContract2.balanceOf(per1.address))
  // console.log("success")
  // const query3 = await poolContract.getReserves();

  // console.log("Number of Token A in the pool rightnow", query3[0].toString());
  // console.log("Number of Token B in the pool rightnow", query3[1].toString());




}




main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });