// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {ICurta} from "../src/interfaces/ICurta.sol";
import {IPuzzle} from "../src/interfaces/IPuzzle.sol";
import {INFTOutlet} from "../src/interfaces/INFTOutlet.sol";

import {BillySolver} from "../src/BillySolver.sol";

contract BillyTheBullTest is Test {
    ICurta public constant CURTA =
        ICurta(0x0000000006bC8D9e5e9d436217B88De704a9F307);
    IPuzzle public constant PUZZLE =
        IPuzzle(0x9C48aE1Ae4C1a8BACcA3a52AEb22657FA0a52D3B);
    INFTOutlet public constant NFT_OUTLET =
        INFTOutlet(0xf9F656435493C58421cFe153E5936f0FafF8c05f);
    uint32 public constant PUZZLE_ID = 15;

    // eoa.sina.eth
    address public constant SINA_ETH_EOA =
        0x2de14DB256Db2597fe3c8Eed46eF5b20bA390823;
    uint256 public constant SINA_ETH_EOA_NONCE = 1405;
    // safe.sina.eth
    address public constant SINA_ETH_SAFE =
        0x5DFfD5527551888c2AC47f799c4Dc8e830dECeE7;
    address public constant SOLVER = SINA_ETH_EOA;

    uint256 public constant expectedGenerated =
        0xc92f25d7aa4cc2a3b31b55e9e9c7c78283a420fa26d964c8afc338496a418b11;
    uint256 public constant solution =
        uint256(
            keccak256(
                abi.encodePacked(
                    bytes1(0xd8),
                    bytes1(0x94),
                    SINA_ETH_EOA,
                    bytes1(0x82),
                    uint16(SINA_ETH_EOA_NONCE)
                )
            )
        );

    function testGenerate() public {
        uint256 generated = PUZZLE.generate(SOLVER);
        assertEq(generated, expectedGenerated);
    }

    function testPredictedAddr() public {
        vm.label(address(CURTA), "Curta");
        vm.label(address(PUZZLE), "BillyTheBull");
        vm.label(address(NFT_OUTLET), "NFTOutlet");
        vm.label(0xe5608a36489Fe45a8f08fD0c6B028801cE6B38d1, "FreeWillyNFT");
        vm.label(0xe5220446640A68693761e6e7429965D82db4c474, "RippedJesusNFT");
        vm.setNonce(SINA_ETH_EOA, uint64(SINA_ETH_EOA_NONCE));
        uint256 nonce = vm.getNonce(SINA_ETH_EOA);
        assertEq(nonce, SINA_ETH_EOA_NONCE);
        vm.startPrank(SINA_ETH_EOA, SINA_ETH_EOA);
        BillySolver solver = new BillySolver();
        uint256 _solution = solver.getSoln();
        address wallet = address(uint160(_solution));
        assertEq(address(solver), wallet);

        CURTA.solve(PUZZLE_ID, _solution);
    }

    // function testPls() public {
    //     vm.setNonce(SINA_ETH_EOA, uint64(SINA_ETH_EOA_NONCE + 1));
    //     vm.startPrank(SINA_ETH_EOA, SINA_ETH_EOA);
    //     BillySolver solver = new BillySolver();
    //     uint256 _solution = solver.getSoln();
    //     assertEq(address(solver), address(uint160(_solution)));
    //     CURTA.solve(PUZZLE_ID, _solution);
    // }

    // function testSolve(uint256 solution) public {
    //     uint256 generated = PUZZLE.generate(SOLVER);

    //     try PUZZLE.verify(generated, solution) returns (bool success) {
    //         // If it doesn't throw or revert, then assert it to be false
    //         assertFalse(success, "The verify function did not revert, but was expected to.");
    //     } catch (bytes memory) {
    //         // If it throws or reverts, the test will pass.
    //         assertTrue(true, "The verify function reverted as expected.");
    //     }
    // }
}
