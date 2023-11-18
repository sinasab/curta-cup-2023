// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Puzzle19} from "../puzzles/Puzzle19.sol";
import {ICurta} from "../interfaces/ICurta.sol";

contract Solve19 is Script {
    ICurta public constant CURTA =
        ICurta(0x0000000006bC8D9e5e9d436217B88De704a9F307);
    uint32 public constant PUZZLE_NUM = 19;
    address public constant SOLVER = 0x2de14DB256Db2597fe3c8Eed46eF5b20bA390823;
    Puzzle19 public constant PUZZLE = Puzzle19(0x12b9e49e4d6241cb005cc70cadeeeb3b10d11a53);

    function run() public {
        vm.startBroadcast(SOLVER);
        // Set maintenance mode to the right value.
        uint256 modeSlot = calcSlotHelper(address(SOLVER), 1);
        PUZZLE.setSlot(modeSlot, Mode.Development);
        PUZZLE.applySlot();
        // Set serv to the right value.
        uint256 servSlot = calcSlotHelper(SOLVER, 0);
        uint256 servVal = 123; // TODO set this to the right pc.
        PUZZLE.setSlot(servSlot, servVal);
        PUZZLE.applySlot();
        // Ok we're all set up, now let's call solve.
        PUZZLE.solve(123, 123);
        uint256 solution = uint256(uint160(SOLVER));
        CURTA.solve(PUZZLE_NUM, solution);
        vm.stopBroadcast();
    }

    function generate(address _seed) public returns (uint256){
        return uint256(keccak256(abi.encode("Are you a fundamentals enjoyooor?", _seed))) >> 3;
    }

    function calcSlotHelper(address mapKey, uint256 storageIdx) {
        uint256 slot = keccak256(abi.encodePacked(keccak256(abi.encodePacked(uint256(mapKey))),storageIdx));
        return slot;
    }
}
