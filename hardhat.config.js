require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
const { INFURA_API_LINK, SIGNER_PRIVATE_KEY } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  defaultNetwork: "matic",
  networks: {
    goerli : {
      url: INFURA_API_LINK,
      accounts: [SIGNER_PRIVATE_KEY]
    }
  }
};