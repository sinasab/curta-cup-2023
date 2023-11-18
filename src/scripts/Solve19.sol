// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Puzzle19, Mode} from "../puzzles/Puzzle19.sol";
import {ICurta} from "../interfaces/ICurta.sol";

contract Solve19 is Script {
    ICurta public constant CURTA =
        ICurta(0x0000000006bC8D9e5e9d436217B88De704a9F307);
    uint32 public constant PUZZLE_NUM = 19;
    // TODO Set your solver addr here, currently set to eoa.sina.eth.
    address public constant SOLVER = 0x2de14DB256Db2597fe3c8Eed46eF5b20bA390823;
    Puzzle19 public constant PUZZLE = Puzzle19(0x12B9e49E4d6241CB005cC70CaDeEEb3b10d11A53);

    function run() public {
        vm.startBroadcast(SOLVER);
        // Set maintenance mode to the right value.
        uint256 modeSlot = calcSlotHelper(address(SOLVER), 1);
        PUZZLE.setSlot(modeSlot, uint16(Mode.Development));
        PUZZLE.applySlot();
        // Set serv to the right value.
        uint256 servSlot = calcSlotHelper(SOLVER, 0);
        uint16 servVal = 123; // TODO set this to the right pc.
        PUZZLE.setSlot(servSlot, servVal);
        PUZZLE.applySlot();
        // Ok we're all set up, now let's call solve.
        PUZZLE.solve(123, 123);
        uint256 solution = uint256(uint160(SOLVER));
        CURTA.solve(PUZZLE_NUM, solution);
        vm.stopBroadcast();
    }

    function calcSlotHelper(address mapKey, uint256 storageIdx) public pure returns (uint256) {
        bytes32 slot = keccak256(abi.encode(mapKey, storageIdx));
        return uint256(slot);
    }
}
