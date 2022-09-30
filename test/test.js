const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NFT_Rental contract", function () {

    it("Contract owner should be able to toggle the rental.", async function () {
        console.log("Start of test")
        const NFT_Rental = await ethers.getContractFactory("NFT_Rental");
        const nft_rental = await NFT_Rental.deploy("NFT_Rental", "RENT");
        await nft_rental.toggleRental();
        expect(nft_rental.started_rental).to.be.not.true;

        await nft_rental.toggleRental();
        expect(nft_rental.started_rental).to.be.not.false;


    });

    it("Creating token function should result in an increase in GetNumMinted().", async function () {
        const NFT_Rental = await ethers.getContractFactory("NFT_Rental");
        const nft_rental = await NFT_Rental.deploy("NFT_Rental", "RENT");
        
        await nft_rental.toggleRental();
        expect(nft_rental.started_rental).to.be.not.true;

        await nft_rental.CreateToken({value: nft_rental.getPrice()});
        expect(await nft_rental.GetNumMinted()).to.be.equal(1);

    });

    it("Being able to obtain the price, change it, then check if the change has been applied. ", async function () {
        const NFT_Rental = await ethers.getContractFactory("NFT_Rental");
        const nft_rental = await NFT_Rental.deploy("NFT_Rental", "RENT");
            
        await nft_rental.getPrice();
        expect(await nft_rental.getPrice()).to.be.equal(ethers.BigNumber.from("1000000000000000000"));

        await nft_rental.setPrice(1);
        expect(await nft_rental.getPrice()).to.be.equal(1);

    });

    it("Change the baseURI of the contract.", async function () {
        const NFT_Rental = await ethers.getContractFactory("NFT_Rental");
        const nft_rental = await NFT_Rental.deploy("NFT_Rental", "RENT");
            
        await nft_rental.contractURI();
        expect(await nft_rental.contractURI()).to.be.equal("");

        await nft_rental.setURI("Bamba")
        expect(await nft_rental.contractURI()).to.be.equal("Bamba")
    });

    it("Check the tokenURI return function", async function () {
        const NFT_Rental = await ethers.getContractFactory("NFT_Rental");
        const nft_rental = await NFT_Rental.deploy("NFT_Rental", "RENT");
        await nft_rental.toggleRental();

        await nft_rental.CreateToken({value: nft_rental.getPrice()});
        expect(await nft_rental.GetNumMinted()).to.be.equal(1)

        await nft_rental.tokenURI(1);
        expect(await nft_rental.tokenURI(1)).to.be.equal("ipfs://1");
    });

    it("Withdraw contract balance.", async function () {
        const NFT_Rental = await ethers.getContractFactory("NFT_Rental");
        const nft_rental = await NFT_Rental.deploy("NFT_Rental", "RENT");
        await nft_rental.toggleRental();
        await nft_rental.setPrice(1);
       
        expect(await nft_rental.getPrice()).to.be.equal(1);
        await nft_rental.CreateToken({value: nft_rental.getPrice()});

        await nft_rental.WithdrawFunds();
        expect(nft_rental.provider.getBalance(nft_rental.address));
        
    });

    it("Mint all of the NFT's at 0 ETH price.", async function () {
        const NFT_Rental = await ethers.getContractFactory("NFT_Rental");
        const nft_rental = await NFT_Rental.deploy("NFT_Rental", "RENT");
        await nft_rental.toggleRental();
        await nft_rental.setPrice(1);
        expect(await nft_rental.getPrice()).to.be.equal(1);
        for (let i = 0; i < 10000; i++){
            await nft_rental.CreateToken({value: nft_rental.getPrice()});
        }
        expect(await nft_rental.GetNumMinted()).to.be.equal(10000);
    });
});
    

