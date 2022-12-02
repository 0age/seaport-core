// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import { ZoneInterface } from "../interfaces/ZoneInterface.sol";

import { ERC721Interface } from "../interfaces/AbridgedTokenInterfaces.sol";

import { ItemType } from "../lib/ConsiderationEnums.sol";

import {
    AdvancedOrder,
    CriteriaResolver,
    ReceivedItem,
    ZoneParameters
} from "../lib/ConsiderationStructs.sol";

contract TestPostExecution is ZoneInterface {
    function validateOrder(ZoneParameters calldata zoneParameters)
        external
        view
        override
        returns (bytes4 validOrderMagicValue)
    {
        ReceivedItem memory receivedItem = zoneParameters.consideration[0];

        address currentOwner = ERC721Interface(receivedItem.token).ownerOf(
            receivedItem.identifier
        );

        if (receivedItem.itemType != ItemType.ERC721) {
            revert("Validity check performed with unsupported item type");
        }

        // Note that endAmount has been repurposed as recipient; this interface
        // still needs to be modified to return spent / received items.
        if (receivedItem.amount != 1) {
            // Note that this is currently failing in the matchOrder case.
            revert("Returned item amount incorrectly modified");
        }

        if (currentOwner != receivedItem.recipient) {
            revert("Validity check performed prior to execution");
        }

        validOrderMagicValue = ZoneInterface.validateOrder.selector;
    }
}
