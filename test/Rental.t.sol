// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { PRBTest } from "../lib/prb-test/src/PRBTest.sol";
import { console2 } from "../lib/forge-std/src/console2.sol";
import { StdCheats } from "../lib/forge-std/src/StdCheats.sol";
import { Rental } from "../src/Rental.sol";

contract RentalTest is PRBTest, StdCheats {
    Rental public rental;
    address public owner;
    uint256 public ownerPkey;

    address public minter1;
    address public minter2;
    address public minter3;

    string public symbol = "Rental";
    string public name = "Rental";


    function setUp() public {
        (owner, ownerPkey) = makeAddrAndKey("owner");
        minter1 = makeAddr("minter1");
        minter2 = makeAddr("minter2");
        minter3 = makeAddr("minter3");

        vm.deal(minter1, 20 ether);
        vm.deal(minter2, 20 ether);
        vm.deal(minter3, 20 ether);

        vm.prank(owner);
        rental = new Rental(name, symbol);
    }

    function testDeployment() public {
        assertEq(rental.name(), name);
        assertEq(rental.symbol(), symbol);
        assertEq(rental.owner(), owner);
        assertEq(rental.mintStarted(), false);
    }

    function testToggleMintShouldBeTrue() public {
        vm.prank(owner);
        rental.toggleMint();
        assertEq(rental.mintStarted(), true);
    }

    function testToggleMintShouldRevert() public {
        vm.prank(minter1);
        vm.expectRevert("Ownable: caller is not the owner");
        rental.toggleMint();
    }

    function testToggleRentalShouldBeTrue() public {
        vm.prank(owner);
        rental.toggleRent();
        assertEq(rental.rentalStarted(), true);
    }

    function testToggleRentalShouldRevert() public {
        vm.prank(minter1);
        vm.expectRevert("Ownable: caller is not the owner");
        rental.toggleRent();
    }

    function testOwnerMintShouldPass() public {
        vm.prank(owner);
        rental.toggleMint();
        assertEq(rental.mintStarted(), true);

        vm.prank(owner);
        rental.ownerMint(owner, 10);
        assertEq(rental.totalSupply(), 10);
    }

    function testMintAndRentalShouldPass() public {
        vm.prank(owner);
        rental.toggleMint();

        vm.prank(owner);
        rental.toggleRent();

        vm.prank(minter1);
        rental.mintToken(5);

        vm.prank(minter1);
        rental.setUser(5, minter2, 100000000000000000);

        vm.prank(minter1);
        assertEq(rental.userOf(5), minter2);
    }

    function testMintAndRentalShouldRevert() public {
        vm.prank(owner);
        rental.toggleMint();

        vm.prank(owner);
        rental.toggleRent();

        vm.prank(minter1);
        rental.mintToken(10);

        vm.prank(minter1);
        vm.expectRevert();
        rental.setUser(11, minter2, 100000000000000000);
    }

    function testWithdrawFunction() public {
        vm.prank(owner);
        rental.withdrawFunds();
    }

    function testUriShouldBeRevertedWithNonexistantToken() public {
        vm.prank(owner);
        rental.toggleMint();

        vm.prank(minter1);
        rental.mintToken(10);

        vm.prank(minter1);
        vm.expectRevert();
        rental.tokenURI(11);
    }

    function testUriShouldBeSuccessfull() public {
        vm.prank(owner);
        rental.toggleMint();

        vm.prank(minter1);
        rental.mintToken(10);

        vm.prank(minter1);
        assertEq(rental.tokenURI(10), "ipfs://10");

    }

    function testSetPriceShouldBeSuccessfull() public {
        vm.prank(owner);
        rental.setPrice(1 ether);
        assertEq(rental.getPrice(), 1 ether);
    }

    function testMintScenarioShouldBeSuccessful() public {
        vm.prank(owner);
        rental.toggleMint();

        address[] memory users = new address[](10000);
        for (uint256 i = 0; i < 10000; i++) {
            bytes memory byteIndex = abi.encodePacked(i);
            string memory addressLabel = string.concat("user", string(byteIndex));

            address user = makeAddr(addressLabel);
            vm.deal(user, 10 ether);
            users[i] = user;
        }


        for (uint256 i = 0; i < 10000; i++) {
            vm.prank(users[i], users[i]);
            rental.mintToken(1);
            assertEq(rental.balanceOf(users[i]), 1);
        }
    }
}