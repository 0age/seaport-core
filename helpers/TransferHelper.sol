// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./TransferHelperStructs.sol";

import { TokenTransferrer } from "../lib/TokenTransferrer.sol";

// prettier-ignore
import {
    TokenTransferrerErrors
} from "../interfaces/TokenTransferrerErrors.sol";

import { ConduitInterface } from "../interfaces/ConduitInterface.sol";

// prettier-ignore
import {
    ConduitControllerInterface
} from "../interfaces/ConduitControllerInterface.sol";

import { Conduit } from "../conduit/Conduit.sol";

import { ConduitTransfer } from "../conduit/lib/ConduitStructs.sol";

// prettier-ignore
import {
    TransferHelperInterface
} from "../interfaces/TransferHelperInterface.sol";

interface IERC721Receiver {
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external returns (bytes4);
}

/**
 * @title TransferHelper
 * @author stuckinaboot, stephankmin, ryanio
 * @notice TransferHelper is a utility contract for transferring
 *         ERC20/ERC721/ERC1155 items in bulk to a specific recipient.
 */
contract TransferHelper is TransferHelperInterface, TokenTransferrer {
    // Allow for interaction with the conduit controller.
    ConduitControllerInterface internal immutable _CONDUIT_CONTROLLER;

    // Set conduit creation code and runtime code hashes as immutable arguments.
    bytes32 internal immutable _CONDUIT_CREATION_CODE_HASH;
    bytes32 internal immutable _CONDUIT_RUNTIME_CODE_HASH;

    /**
     * @dev Set the supplied conduit controller and retrieve its
     *      conduit creation code hash.
     *
     *
     * @param conduitController A contract that deploys conduits, or proxies
     *                          that may optionally be used to transfer approved
     *                          ERC20/721/1155 tokens.
     */
    constructor(address conduitController) {
        // Get the conduit creation code and runtime code hashes from the
        // supplied conduit controller and set them as an immutable.
        ConduitControllerInterface controller = ConduitControllerInterface(
            conduitController
        );
        (_CONDUIT_CREATION_CODE_HASH, _CONDUIT_RUNTIME_CODE_HASH) = controller
            .getConduitCodeHashes();

        // Set the supplied conduit controller as an immutable.
        _CONDUIT_CONTROLLER = controller;
    }

    /**
     * @notice Transfer multiple items to a single recipient.
     *
     * @param items      The items to transfer.
     * @param recipient  The address the items should be transferred to.
     * @param conduitKey An optional conduit key referring to a conduit through
     *                   which the bulk transfer should occur.
     *
     * @return magicValue A value indicating that the transfers were successful.
     */
    function bulkTransfer(
        TransferHelperItem[] calldata items,
        address recipient,
        bytes32 conduitKey
    ) external override returns (bytes4 magicValue) {
        // If no conduitKey is given, use TokenTransferrer to perform transfers.
        if (conduitKey == bytes32(0)) {
            _performTransfersWithoutConduit(items, recipient);
        }
        // Otherwise, a conduitKey was provided.
        else {
            _performTransfersWithConduit(items, recipient, conduitKey);
        }

        // Return a magic value indicating that the transfers were performed.
        magicValue = this.bulkTransfer.selector;
    }

    function _performTransfersWithoutConduit(
        TransferHelperItem[] calldata items,
        address recipient
    ) internal {
        // Retrieve total number of transfers and place on stack.
        uint256 totalTransfers = items.length;

        // Create a boolean that reflects whether recipient is a contract.
        bool recipientIsContract = _isContract(recipient);

        // Skip overflow checks: all for loops are indexed starting at zero.
        unchecked {
            // Iterate over each transfer.
            for (uint256 i = 0; i < totalTransfers; ++i) {
                // Retrieve the transfer in question.
                TransferHelperItem calldata item = items[i];

                // Perform a transfer based on the transfer's item type.
                // Revert if item being transferred is a native token.
                if (item.itemType == ConduitItemType.NATIVE) {
                    revert InvalidItemType();
                } else if (item.itemType == ConduitItemType.ERC20) {
                    // Ensure that the identifier for an ERC20 token is 0.
                    if (item.identifier != 0) {
                        revert InvalidERC20Identifier();
                    }

                    // Transfer ERC20 token.
                    _performERC20Transfer(
                        item.token,
                        msg.sender,
                        recipient,
                        item.amount
                    );
                } else if (item.itemType == ConduitItemType.ERC721) {
                    // If recipient is a contract, ensure it can receive
                    // ERC721 tokens.
                    if (recipientIsContract) {
                        // Check if recipient can receive ERC721 tokens.
                        try
                            IERC721Receiver(recipient).onERC721Received(
                                address(this),
                                msg.sender,
                                item.identifier,
                                ""
                            )
                        returns (bytes4 selector) {
                            // Check if onERC721Received selector is valid.
                            if (
                                selector !=
                                IERC721Receiver.onERC721Received.selector
                            ) {
                                // Revert if recipient cannot accept
                                // ERC721 tokens.
                                revert InvalidERC721Recipient();
                            }
                        } catch (bytes memory data) {
                            // Bubble up recipient's revert reason
                            // if present.
                            if (data.length != 0) {
                                assembly {
                                    returndatacopy(0, 0, returndatasize())
                                    revert(0, returndatasize())
                                }
                            } else {
                                revert InvalidERC721Recipient();
                            }
                        }
                    }
                    // Ensure that the amount for an ERC721 transfer is 1.
                    if (item.amount != 1) {
                        revert InvalidERC721TransferAmount();
                    }

                    // Transfer ERC721 token.
                    _performERC721Transfer(
                        item.token,
                        msg.sender,
                        recipient,
                        item.identifier
                    );
                } else if (item.itemType == ConduitItemType.ERC1155) {
                    // Transfer ERC1155 token.
                    _performERC1155Transfer(
                        item.token,
                        msg.sender,
                        recipient,
                        item.identifier,
                        item.amount
                    );
                }
            }
        }
    }

    function _performTransfersWithConduit(
        TransferHelperItem[] calldata items,
        address recipient,
        bytes32 conduitKey
    ) internal {
        // Retrieve total number of transfers and place on stack.
        uint256 totalTransfers = items.length;

        // Derive the conduit address from the deployer, conduit key
        // and creation code hash.
        address conduit = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            address(_CONDUIT_CONTROLLER),
                            conduitKey,
                            _CONDUIT_CREATION_CODE_HASH
                        )
                    )
                )
            )
        );

        // Declare a new array to populate with each token transfer.
        ConduitTransfer[] memory conduitTransfers = new ConduitTransfer[](
            totalTransfers
        );

        // Skip overflow checks: all for loops are indexed starting at zero.
        unchecked {
            // Iterate over each transfer.
            for (uint256 i = 0; i < totalTransfers; ++i) {
                // Retrieve the transfer in question.
                TransferHelperItem calldata item = items[i];

                // Create a ConduitTransfer corresponding to each
                // TransferHelperItem.
                conduitTransfers[i] = ConduitTransfer(
                    item.itemType,
                    item.token,
                    msg.sender,
                    recipient,
                    item.identifier,
                    item.amount
                );
            }
        }

        if (!_isContract(conduit)) {
            revert InvalidConduit(conduitKey, conduit);
        }

        // If the external call fails, revert with the conduit's
        // custom error.
        try ConduitInterface(conduit).execute(conduitTransfers) returns (
            bytes4 conduitMagicValue
        ) {
            if (
                conduitMagicValue != ConduitInterface(conduit).execute.selector
            ) {
                revert InvalidMagicValue(conduitKey, conduit);
            }
        } catch (bytes memory data) {
            // "Bubble up" the conduit's revert reason if present.
            if (data.length != 0) {
                assembly {
                    returndatacopy(0, 0, returndatasize())
                    revert(0, returndatasize())
                }
            } else {
                revert ConduitErrorGenericRevert(conduitKey, conduit);
            }
        } catch Error(string memory reason) {
            // Revert with the error reason string if present.
            revert ConduitErrorString(reason, conduitKey, conduit);
        } catch Panic(uint256 errorCode) {
            // Revert with the panic error code if the error was caused
            // by a panic.
            revert ConduitErrorPanic(errorCode, conduitKey, conduit);
        }
    }

    function _isContract(address account) internal view returns (bool) {
        // This is the default codeHash for non-contract addresses.
        // prettier-ignore
        bytes32 accountHash =
            0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        // Get the account codeHash.
        bytes32 codeHash = account.codehash;

        // Account is a contract if codeHash is not equal to accountHash
        // and is not equal to 0 meaning it does not exist or is empty.
        return (codeHash != accountHash && codeHash != 0x0);
    }
}
