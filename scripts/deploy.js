const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {

  const [owner,player] = await ethers.getSigners()
  const contractLevelNames = ["FragileAirdropLevelManager","GuessLevelManager","LongTimeLockLevelManager","RecoverTheKeysLevelManager","retirementSavingsLevelManager"]

  const HackLab = await hre.ethers.getContractFactory("HackLab");
  const hackLab = await HackLab.connect(owner).deploy();
  await hackLab.deployed();

  console.log("--HackLabs--")
  console.log(hackLab.address)

  console.log("--LevelManagers--")
  const managers = await deployLevelManagers(owner,contractLevelNames)
  await registerLevels(owner,hackLab,managers)
  for (const manager of managers) {
    await hackLab.registeredLevels(manager.address)
    console.log(manager.address)
  }

  // console.log("--levelInstances--")
  // const levelInstancesTransactions = await deployLevelInstance(player,hackLab,managers)
  

}

async function registerLevels(owner,hackLab,managers){
    for (const manager of managers) {
        await hackLab.connect(owner).registerLevel(manager.address)
    }
}

async function deployLevelInstance(player,hackLab,managers){

  const listOfInstanceAddress = []
  for(let tt = 0; tt < managers.length;tt++){
    if(tt == 4){
      const instanceAddressTrans = await hackLab.connect(player).createLevelInstance(managers[tt].address,{ value: hre.ethers.utils.parseEther(".1") })
      listOfInstanceAddress.push(instanceAddressTrans)

      await instanceAddressTrans.wait();
      hackLab.on("LevelInstanceCreatedLog", (setter,address, event)=> {
      console.log("LevelInstanceCreatedLog is ", address);
      })
      continue;
    }
    const instanceAddressTrans = await hackLab.connect(player).createLevelInstance(managers[tt].address)
    listOfInstanceAddress.push(instanceAddressTrans)

    await instanceAddressTrans.wait();
    hackLab.on("LevelInstanceCreatedLog", (setter,address, event)=> {
      console.log("LevelInstanceCreatedLog is ", address);
    })

  }
  
  return listOfInstanceAddress;

}

async function deployLevelManagers(owner,contractNames){

  const contractOBJs = []
  for (const contractName of contractNames) {
    const Manager = await hre.ethers.getContractFactory(contractName);
    const manager = await Manager.connect(owner).deploy(5,3);
    await manager.deployed();
    contractOBJs.push(manager);
  }

  return contractOBJs;

}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
