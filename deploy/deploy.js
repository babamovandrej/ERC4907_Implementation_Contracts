const hre = require('hardhat');


async function main() {

    const NFT_Mint = await hre.ethers.getContractFactory("NFT_Rental");
    const TEST = await NFT_Mint.deploy("NFT_Rental","RENT"); //Add constructor arguments to deploy function
    console.log("Contract has been deployed at address", TEST.address);
 }
 
 main()
   .then(() => process.exit(0))
   .catch(error => {
     console.error(error);
     process.exit(1);
   });