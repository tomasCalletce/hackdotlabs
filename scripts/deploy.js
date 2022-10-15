// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {

  const [owner,player] = await ethers.getSigners()

  const HackLab = await hre.ethers.getContractFactory("HackLab");
  const hackLab = await HackLab.connect(owner).deploy();
  await hackLab.deployed();

  console.log("--LevelManagers--")
  const managers = await deployLevelManagers(owner)
  for (const manager of managers) {
    console.log(manager.address);
    await hackLab.connect(owner).registerLevel(manager.address);
  }

  console.log("--levelInstances--")
  const levelInstances = await deployLevelInstance(player)
  for (const levelInstance of levelInstances) {
    console.log(levelInstance.address);
  }


}

async function deployLevelInstance(player){

  const contractNames = ["DontWantMoney","QuestionableAirdrop","Guess","LongTimeLockProxy"]
  const contractOBJs = []
  for (const contractName of contractNames) {
    const LevelInstance = await hre.ethers.getContractFactory(contractName);
    const levelInstance = await LevelInstance.connect(player).deploy();
    await levelInstance.deployed();
    contractOBJs.push(levelInstance);
    console.log(levelInstance.address)
  }

  return contractOBJs;

}

async function deployLevelManagers(owner){

  const contractNames = ["IdontWantMoneyLevelManager","FragileAirdropLevelManager","GuessLevelManager","LongTimeLockLevelManager"]
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
