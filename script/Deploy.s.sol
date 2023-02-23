// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Script } from '../lib/forge-std/src/Script.sol';
import { Rental } from "../src/Rental.sol";

/// @notice A very simple deployment script
contract Deploy is Script {
  /// @notice The main script entrypoint
  /// @return rental The deployed contract
  function run() external returns (Rental rental) {
    vm.startBroadcast();
    rental = new Rental("Rental","Rental");
    vm.stopBroadcast();
  }
}