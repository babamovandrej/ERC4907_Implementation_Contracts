/** @type import('hardhat/config').HardhatUserConfig */
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
const dotenv = require('dotenv');
dotenv.config();


module.exports = {
   solidity: {
    version: "0.8.10",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200}
      }
    },
    mocha: {
      timeout: 100000000
    },

   defaultNetwork: "rinkeby",
   networks: {
      hardhat: {},
      mainnet: {
        //Insert endpoint link here
        url: "",
        accounts: [`0x${process.env.PRIVATE_KEY}`]
      },
      rinkeby: {
         url: "",
         accounts: [`0x${process.env.PRIVATE_KEY}`]
      },
      kovan: {
        url: "",
        accounts: [`0x${process.env.PRIVATE_KEY}`]
      }
   },
   etherscan:{
    //Insert Etherscan API for verification purpooses
    apiKey: ""
   }
}