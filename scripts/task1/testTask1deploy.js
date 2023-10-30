
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
const formateToken = (val) => {
  return ethers.utils.formatEther(String(val))
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

  const owner = "0x1260e408d9E1Ad2f2293Fb092D840BF252c68833";


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


  // console.log("=== DEPLOYER ===", deployer.address);

  // factoryV2Contract = await ethers.getContractAt("FactoryV2", factoryV2)
  // routerV2Contract = await ethers.getContractAt("RouterV2", routerV2)
  const mola = "0x8128cE2516EaE14BE8c1c164F8565C70067e9026";
  const AppleContract = "0x474863625bf7cD97B9872b400ae7BEB30EA237EC";
  const goerli_weth = "0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6";
  const v2Router = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";


  TokenContract = await ethers.getContractAt("TokenContract2", mola)
  goerliContract = await ethers.getContractAt("TokenContract2", goerli_weth)

  const _1000Tokens = tokenAmount(10000)

  const transfer = await TokenContract.connect(signer).transfer(deployer.getAddress(), _1000Tokens);
  const bal = await TokenContract.balanceOf(deployer.address);
  console.log("balance ", formateToken(bal));
  const bal0 = await goerliContract.balanceOf(deployer.getAddress());
  console.log("goerl before swap ", formateToken(bal0));

  // TestUniswap1Contract = await ethers.getContractFactory("TestUniswap1")
  routerV2 = await ethers.getContractAt("RouterV2", v2Router)


  // tokenContract1 = await TokenContract.deploy("Apple Token", "APPLE", 10000000) //10 million tokens
  // console.log("============ DEPLOYMENT ============");
  // await tokenContract1.deployed()
  // console.log("tokenContract1 Address", tokenContract1.address)

  // tokenContract2 = await TokenContract.deploy("Mango Token", "MANGO", 10000000) //10 million tokens
  // await tokenContract2.deployed()
  // console.log("tokenContract2 Address", tokenContract2.address)

  // testUniswap1Contract = await TestUniswap1Contract.deploy()
  // await testUniswap1Contract.deployed()
  // console.log("testUniswap1Contract Address", testUniswap1Contract.address)


  // console.log("============ CREATING POOL ============");

  // const createPoolTx = await testUniswap1Contract.creatUniswapPair(tokenContract1.address, tokenContract2.address);
  // await createPoolTx.wait()
  // console.log("createPoolTx", createPoolTx)
  // console.log("factoryV2Contract", factoryV2Contract)

  // const poolAddress = await testUniswap1Contract.getPoolAddress(AppleContract, goerli_weth);
  // console.log("poolAddress", poolAddress)

  // poolContract = await ethers.getContractAt("PairV2", poolAddress)



  // const _1000Tokens = tokenAmount(1000)
  // await tokenContract1.approve(testUniswap1Contract.address, _1000Tokens);
  // await tokenContract2.approve(testUniswap1Contract.address, _1000Tokens);

  // console.log("============ ADDINGING LIQUIDITY ============");

  // await testUniswap1Contract.addLiquidityToPool(
  //   tokenContract1.address,    // address tokenContract1 
  //   tokenContract2.address, //address tokenContract2
  //   _1000Tokens, //amountADesired
  //   _1000Tokens, //amountBDesired
  // );

  // const ownerPoolBal = await poolContract.balanceOf(deployer.getAddress());
  // console.log(`balance LP: ${formateToken(ownerPoolBal)}`); //999999999999999999000


  // const query0 = await poolContract.getReserves();
  // console.log("Number of Token A in the pool rightnow", formateToken(query0[0].toString())); //1000.000000000000000000
  // console.log("Number of Token B in the pool rightnow", formateToken(query0[1].toString())); //1000.000000000000000000

  //deployer sending 500 to p1
  // const _500Token = tokenAmount(500)
  // await tokenContract1.transfer(per1.address, _500Token)

  // console.log("============ USER 2 getting 100 TOKEN B ============");

  // const routerV2 = await testUniswap1Contract.connect(per1)
  // const per1_routerV2Con = await testUniswap1Contract.connect(per1)
  // const per1_tokenContract1 = await tokenContract1.connect(per1)
  // //p1 adding token to pool sending 500 to p1
  // await per1_tokenContract1.approve(testUniswap1Contract.address, _500Token);

  // const _100Token = tokenAmount(100)
  // const tx2 = await per1_routerV2Con.getAmountsIn(tokenContract1.address, tokenContract2.address, _100Token)
  // // console.log("quote Token B", tx2)
  // // [
  // //   BigNumber { value: "111445447453471525689" },
  // //   BigNumber { value: "100000000000000000000" }
  // // ]
  // console.log("====acc 2 balance of tokenContract1", formateToken(await tokenContract1.balanceOf(per1.address)))
  // console.log("====acc 2 balance of tokenContract2", formateToken(await tokenContract2.balanceOf(per1.address)))
  // console.log("Amoount will get in", formateToken(tx2[0]))
  // console.log("Amoount will spend", formateToken(tx2[1]))
  // console.log("Swapping Token B..........")
  // const executeSwap1 = await per1_routerV2Con.swapExactTokensForTokensHandle(tx2[0], tx2[1], [tokenContract1.address, tokenContract2.address], per1.address, Math.floor(Date.now() / 1000) + 5 * 10)
  // console.log("====acc 2 balance of tokenContract1", formateToken(await tokenContract1.balanceOf(per1.address)))
  // console.log("====acc 2 balance of tokenContract2", formateToken(await tokenContract2.balanceOf(per1.address)))

  // // const ownerPoolBal2 = await poolContract.balanceOf(deployer.getAddress());
  // // console.log(`balance LP: ${formateToken(ownerPoolBal2)}`); //999999999999999999000

  // const query2 = await poolContract.getReserves();
  // console.log("Number of Token A in the pool rightnow", formateToken(query2[0].toString()));
  // console.log("Number of Token B in the pool rightnow", formateToken(query2[1].toString()));



  // console.log("============ USER 2 getting TOKEN 50 A ============");

  // //!================================get token 1
  const _50Token = tokenAmount(50)

  const tx5 = await routerV2.getAmountsOut(_1000Tokens, [mola, AppleContract, goerli_weth])
  console.log("3rd estimation for Swapping Token A", formateToken(tx5[0]))
  console.log("3rd estimation for Swapping Token A", formateToken(tx5[1]))
  console.log("3rd estimation for Swapping Token A", formateToken(tx5[2]))



  // const per1_tokenContract2 = await tokenContract2.connect(per1)
  await TokenContract.approve(routerV2.address, _1000Tokens);

  // console.log("Swapping Token A...........")
  const tx6 = await routerV2.swapExactTokensForETH(_1000Tokens, 0, [mola, AppleContract, goerli_weth], deployer.getAddress(), Math.floor(Date.now() / 1000) + 5 * 10)

  const swapData = await tx6.wait();
  // console.log("Swap done ", swapData);
  const bal2 = await TokenContract.balanceOf(deployer.getAddress());
  console.log("mola after balance ", formateToken(bal2));
  const bal3 = await goerliContract.balanceOf(deployer.getAddress());
  console.log("goerl after balance ", formateToken(bal3));


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