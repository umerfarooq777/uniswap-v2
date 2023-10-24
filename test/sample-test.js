const { ethers } = require("hardhat");
var describe = require ('mocha').describe;


async function mineNBlocks(n) {
  for (let index = 0; index < n; index++) {
    await ethers.provider.send('evm_mine');
  }
}

describe("HOTIE ENERGY",  function ()  {


  
   

  
  let BUSD
  let busd
  let HESTOKEN
  let hestoken
  let Staking
  let staking




   let [_,per1,per2,per3] = [1,1,1,1]

  it("Should deploy all smart contracts", async function () {

    [_,per1,per2,per3] = await ethers.getSigners()
    
    BUSD = await ethers.getContractFactory("BUSD")  
    busd = await BUSD.deploy()
    await busd.deployed() 
    
    HESTOKEN = await ethers.getContractFactory("HESTOKEN")  
    hestoken = await HESTOKEN.deploy()
    await hestoken.deployed()

    Staking = await ethers.getContractFactory("Staking")  
    staking = await Staking.deploy(_.address , _.address , _.address)
    await staking.deployed()

    let _ETHvalue = await ethers.utils.parseEther('100')

    let _value = await ethers.utils.parseEther('10000000')

    let tx = await busd.setRouterAddress("0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D", {value :_ETHvalue })  //  
    await tx.wait()
    tx = await busd.addLiquidity(_value, _ETHvalue )
    await tx.wait()

    tx =await hestoken.setRouterAddress("0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D")
    await tx.wait()

    tx =await hestoken.excludeFromFee(staking.address)
    await tx.wait()
    tx =await hestoken.excludeFromReward(staking.address)
    await tx.wait()


    await staking.setRouterAddress("0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D")
    await staking.setHESTAddress(hestoken.address)

    _value = await ethers.utils.parseUnits('1000' , await hestoken.decimals())
    await hestoken.transfer(staking.address,_value)
    _value = await ethers.utils.parseUnits('1000' , await busd.decimals())
    await busd.transfer(staking.address,_value)


    await staking.addLiquidity(busd.address)
  
    await staking.setRewardTokenAddress(busd.address)

    

    

    _value = await ethers.utils.parseUnits('1000' , await hestoken.decimals())
    await hestoken.transfer(per1.address,_value)

    console.log("pair address : ", (await staking.getPair(hestoken.address , busd.address)).toString())

    console.log("per1 hest before" , (await hestoken.balanceOf(per1.address)).toString())
    
  });
  
 
  it("Should initialize", async function () {
    
    //let _value = await ethers.utils.parseEther('5')
    
    let initialize = await staking.initiatePools([10,10,10,10,10,10,10,10],[25,2500,9000,19000,35000,58000,100000,176000],[1500,5000,12000,28000,40000,90000,120000,800000000])
    await initialize.wait()
   
    
  });

  it("Should add BUSD into Pools", async function () {
    
    let _value = await ethers.utils.parseEther('100')
    await busd.approve(staking.address , _value)
    let add = await staking.addRewardToken(_value)
    await add.wait()
    
  });
  
  it("Should stake into Pools", async function () {
    let info = await staking.pool(1,1)
    console.log(info)
    let _value = await ethers.utils.parseUnits('200',  await hestoken.decimals() )

    await hestoken.approve(staking.address , _value)
    let add = await staking.stake(1)
    await add.wait()

    _value = await ethers.utils.parseUnits('100',  await hestoken.decimals() )

    let approve = await hestoken.connect(per1).approve(staking.address , _value)
    await approve.wait()
    add = await staking.connect(per1).stake(1)
    await add.wait()

    let reward = await staking.calcRewards(_.address,1,1)
    console.log("reward before" , reward.toString())
    await mineNBlocks(24 * 15)
    reward = await staking.calcRewards(_.address,1,1)
    console.log("reward after" , reward.toString())



    let unstake  = await staking.unStake(1 , 1 , _value)
    await unstake.wait()



    await mineNBlocks(24 * 15)

  });

  // // it("loop the process", async function () {

  // //   for (let index = 0; index < 10 ; index++) {
      
  // //     let initialize = await staking.initiatePools([10,10,10,10,10,10,10,10],[1,1,1,100,100,100,100,100],[200,200,200,200,200,200,200,200])
  // //     await initialize.wait()

  // //     let _value = await ethers.utils.parseEther('100')
  // //     await busd.approve(staking.address , _value)
  // //     let add = await staking.addRewardToken(_value)
  // //     await add.wait()

  // //     let info = await staking.pool(1,1)
  // //   console.log(info)
  // //   _value = await ethers.utils.parseUnits('3',  await hestoken.decimals() )

  // //   await hestoken.approve(staking.address , _value)
  // //    add = await staking.stake(1)
  // //   await add.wait()

  // //   _value = await ethers.utils.parseUnits('1',  await hestoken.decimals() )

  // //   let approve = await hestoken.connect(per1).approve(staking.address , _value)
  // //   await approve.wait()
  // //   add = await staking.connect(per1).stake(1)
  // //   await add.wait()

  // //   let reward = await staking.calcRewards(_.address,1,1)
  // //   console.log("reward before" , reward.toString())
  // //   await mineNBlocks(24 * 30)
  // //   reward = await staking.calcRewards(_.address,1,1)
  // //   console.log("reward after" , reward.toString())
      
  // //   }
      
  // //   });

  it("Should initialize", async function () {
    
    //let _value = await ethers.utils.parseEther('5')
    
    let initialize = await staking.initiatePools([10,10,10,10,10,10,10,10],[100,100,100,100,100,100,100,100],[200,200,200,200,200,200,200,200])
    await initialize.wait()
   
    
  });

  it("Should add BUSD into Pools", async function () {
    
    let _value = await ethers.utils.parseEther('100')
    await busd.approve(staking.address , _value)
    let add = await staking.addRewardToken(_value)
    await add.wait()
    
  });

  // // it("Should stake into Pools", async function () {

  // //   let info = await staking.pool(1,2)
  // //   console.log(info)
  // //   let _value = await ethers.utils.parseUnits('300',  await hestoken.decimals() )

  // //   await hestoken.approve(staking.address , _value)
  // //   let add = await staking.stake(1)
  // //   await add.wait()

  // //   _value = await ethers.utils.parseUnits('100',  await hestoken.decimals() )

  // //   let approve = await hestoken.connect(per1).approve(staking.address , _value)
  // //   await approve.wait()
  // //   add = await staking.connect(per1).stake(1)
  // //   await add.wait()

  // //   let reward = await staking.calcRewards(_.address,1,2)
  // //   console.log("reward before" , reward.toString())
  // //   await mineNBlocks(24 * 30)
  // //   reward = await staking.calcRewards(_.address,1,2)
  // //   console.log("reward after" , reward.toString())

  // //  // await staking.calcRewards(_.address,1,2)    
  // // });

  // // it("Should withdraw from Pool", async function () {

  // //   console.log("per1 Busd before" , (await busd.balanceOf(per1.address)).toString())
  // //   console.log("per1 stakeInfo before" , (await staking.stakeInfo(per1.address,1,1)))
    
  // //   await staking.withdrawRewards(per1.address , 1 , 1)

  // //   //await staking.withdrawRewards(per1.address , false , [1,2,3,4])(address account , uint8 _id , uint256 _Poolno )
  // //   console.log("per1 Busd after" , (await busd.balanceOf(per1.address)).toString())

  // //   console.log("per1 stakeInfo after" , (await staking.stakeInfo(per1.address,1,1)))
   
    
  // // });


  it("Should clubRewards into Pools", async function () {

    console.log("per1 hest before" , (await hestoken.balanceOf(_.address)).toString())
    console.log("Contract hest before" , (await hestoken.balanceOf(staking.address)).toString())
    console.log("per1 Busd before" , (await busd.balanceOf(_.address)).toString())
    console.log("Contract Busd before" , (await busd.balanceOf(staking.address)).toString())
    
    await staking.connect(per1).clubRewards(_.address , false , [1,2,3,4])

    //await staking.clubRewards(per1.address , false , [1,2,3,4])

    console.log("per1 hest after" , (await hestoken.balanceOf(_.address)).toString())
    console.log("Contract hest after" , (await hestoken.balanceOf(staking.address)).toString())
    console.log("per1 Busd after" , (await busd.balanceOf(_.address)).toString())
    console.log("Contract Busd after" , (await busd.balanceOf(staking.address)).toString())

    console.log("1 pool after" , (await staking.pool(1,2)))
    console.log("2 pool after" , (await staking.pool(2,2)))
    console.log("3 pool after" , (await staking.pool(3,2)))
    console.log("4 pool after" , (await staking.pool(4,2)))
    
  });

  

});
