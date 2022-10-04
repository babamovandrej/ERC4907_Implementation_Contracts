# ERC4907 Minting Contract
 A smart contract following the ERC4907 standard. The standard in question represents an extension of ERC721 that includes the user and owner roles.

The ERC4907 Minting contract repository contains a smart contracts that, when deployed on a solidity based blockchain, can be used for minting rentable tokens. Through the contract, different ERC721 tokens can be created, which later on can be rented to other users.

### Firstly, you will need to install some dependencies in your repository. You can do so by running the commands below:

```
npm i hardhat
npm i @nomiclabs/hardhat-ethers
npm i dotenv
npm i @nomiclabs/hardhat-etherscan
npm i chai
npm i @nomiclabs/hardhat-truffle5

```
### Furthermore, you will need to install the openzeppelin package that contains contract interfaces needed to build the smart contract.

```
npm i @openzeppelin/contracts
```
### After completing the above steps, you will need to obtain the private key from your wallet  and update the .env file in the repostiory.
Currently the .env file contains a single variable PRIVATE_KEY. You will need to assign your private key to the variable. Make sure to save the changes, otherwise it will be impossible to deploy the contract.

```
PRIVATE_KEY = Insert_your_private_key_here
```

### Next, you will have to update the network url and etherscan api in the hardhat.connfig.js file. 

More specifically, you will need to connect to a endpoint on the rinkeby test network. You can obtain a link to the endpoint from https://infura.io/.Furthermore, you will need to obtain your etherscan api key for contract verification from https://etherscan.io.

Keep in mind that if you want to deploy on a network other than rinkeby, you will have to add the other network to module.exports. It is also important to clarify that the private key is also needed. If you want to add it directly to module exports, keep in mind that you will need to add '0x' at the beggining. Here is an example below were I added the option to deploy to ethereum mainnet:

```
module.exports = {
   solidity: {
    version: "0.8.10",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200}
      }
    },
   defaultNetwork: "rinkeby",
   networks: {
      hardhat: {},
      rinkeby: {
         //Insert the endpoint url below to connect to rinkeby
         url: "",
         accounts: [`0x${process.env.PRIVATE_KEY}`]
      }
   },
   etherscan:{
    apiKey: "Insert your etherscan api here"
   }
}
```
### Additionally, you will need to add the contract constructor arguments to the deploy.js script in scripts. After doing so, you will need to compile the contracts using the code below:
```
npx hardhat compile
```

### Moreover, you can test the contract functions by running the following code:

```
npx hardhat test
```

### You can deploy the contract to the rinkeby testnet by runnning the following command:

```
npx hardhat run scripts/deploy.js --network rinkeby
```
If you are deploying to a different network you will have to change the name of the network in the command above.

### Lastly, you will need to verify your contract on etherscan. You can do so by running the following command:

```
npx hardhat verify --network <your network> <DEPLOYED CONTRACT ADDRESS> "Constructor Argument 1" "Constructor Argument 2"
```




