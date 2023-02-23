//SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import { Ownable } from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import { ReentrancyGuard } from "../lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import { Strings } from "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import { ERC4907 } from "./ERC4907.sol";

contract Rental is ERC4907, Ownable, ReentrancyGuard {
    using Strings for uint256;

    error CallerIsNotEOA();

    error InssuficientFunds();

    error RentalNotStarted();

    error MintNotStarted();

    error MaxSupplyReached();

    error MaxPerWalletReached();

    error NonexistentToken();
    

    string internal uri;

    bool public mintStarted;

    bool public rentalStarted;

    uint256 public maxSupply = 10000;

    uint256 internal price = 0 ether;

    uint256 internal currentTokenIndex = 0;

    mapping(address => uint256) mintedPerAddress;


    constructor(string memory _name, string memory _symbol) 
    ERC4907(_name,_symbol){}



    modifier onlyEOA() {
        if (tx.origin != msg.sender) revert CallerIsNotEOA();
        _;
    }


    function totalSupply() public view returns (uint256){
        return currentTokenIndex;
    }


    function toggleMint() external onlyOwner {
        mintStarted = !mintStarted;
    }

    function toggleRent() external onlyOwner {
        rentalStarted = !rentalStarted;
    }

    function getPrice() external view returns(uint256) {
        return price;
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function setURI(string memory _uri) external onlyOwner {
        uri = _uri;
    }

    function getCurrentBlock() external view returns(uint256){
        return block.timestamp;
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
		if (_tokenId > currentTokenIndex) revert NonexistentToken();
		return string(abi.encodePacked("ipfs://", uri, _tokenId.toString()));
    }


    function ownerMint(address receiver, uint256 quantity) external onlyOwner {
        if (quantity + totalSupply() > maxSupply) revert MaxSupplyReached();
        for(uint i; i < quantity; i++) { 
            currentTokenIndex += 1;
            _safeMint(receiver, currentTokenIndex);
        }
        
    }

    function mintToken(uint256 quantity) external payable {
        if (mintStarted != true) revert MintNotStarted();
        if (mintedPerAddress[msg.sender] >= 3) revert MaxPerWalletReached();
        if (1 + totalSupply() > maxSupply) revert MaxSupplyReached();
        if (msg.value < price ) revert InssuficientFunds();
        
        for(uint i; i < quantity; i++) { 
            currentTokenIndex += 1;
            _mint(_msgSender(), currentTokenIndex);
        }
    }


    function withdrawFunds() external onlyOwner nonReentrant {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }
}