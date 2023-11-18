// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {BillySolver} from "../BillySolver.sol";
import {ICurta} from "../interfaces/ICurta.sol";

contract Solve15 is Script {
    ICurta public constant CURTA =
        ICurta(0x0000000006bC8D9e5e9d436217B88De704a9F307);

    function run() public {
        vm.startBroadcast(0x2de14DB256Db2597fe3c8Eed46eF5b20bA390823);
        BillySolver solver = new BillySolver();
        CURTA.solve(15, solver.getSoln());
        vm.stopBroadcast();
    }
}
