// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ZoneInterface } from "../interfaces/ZoneInterface.sol";

import { ItemType, OrderType } from "./ConsiderationEnums.sol";

import {
    AdvancedOrder,
    BasicOrderParameters,
    AdditionalRecipient,
    ZoneParameters,
    OfferItem,
    ConsiderationItem,
    SpentItem,
    ReceivedItem
} from "./ConsiderationStructs.sol";

import { ZoneInteractionErrors } from "../interfaces/ZoneInteractionErrors.sol";

import { LowLevelHelpers } from "./LowLevelHelpers.sol";

import "./ConsiderationConstants.sol";

import "./ConsiderationErrors.sol";

/**
 * @title ZoneInteraction
 * @author 0age
 * @notice ZoneInteraction contains logic related to interacting with zones.
 */
contract ZoneInteraction is ZoneInteractionErrors, LowLevelHelpers {
    /**
     * @dev Internal view function to determine if an order has a restricted
     *      order type and, if so, to ensure that either the offerer or the zone
     *      are the fulfiller or that a staticcall to `isValidOrder` on the zone
     *      returns a magic value indicating that the order is currently valid.
     *
     * @param orderHash   The hash of the order.
     * @param orderType   The order type.
     * @param parameters  The parameters of the basic order.
     */
    function _assertRestrictedBasicOrderValidity(
        bytes32 orderHash,
        OrderType orderType,
        BasicOrderParameters calldata parameters
    ) internal {
        // Order type 2-3 require zone or offerer be caller or zone to approve.
        bool isRestricted;
        assembly {
            isRestricted := or(eq(orderType, 2), eq(orderType, 3))
        }
        if (
            isRestricted &&
            !_unmaskedAddressComparison(msg.sender, parameters.zone) &&
            !_unmaskedAddressComparison(msg.sender, parameters.offerer)
        ) {
            // TODO: optimize (copy relevant arguments directly for calldata)
            bytes32[] memory orderHashes = new bytes32[](1);
            orderHashes[0] = orderHash;

            SpentItem[] memory offer = new SpentItem[](1);

            ReceivedItem[] memory consideration = new ReceivedItem[](
                parameters.additionalRecipients.length + 1
            );

            bytes memory extraData;

            // TODO: optimize (conversion is temporary to get it to compile)
            bytes memory callData = _generateCallData(
                orderHash,
                orderHashes,
                parameters.zoneHash,
                parameters.offerer,
                offer,
                consideration,
                extraData,
                parameters.startTime,
                parameters.endTime
            );

            // Copy offer & consideration from event data into target callData.
            // 2 words (lengths) + 4 (offer data) + 5 (consideration 1) + 5 * ar
            uint256 size;
            unchecked {
                size =
                    OrderFulfilled_baseDataSize +
                    (parameters.additionalRecipients.length *
                        ReceivedItem_size);
            }

            // Send to the identity precompile.
            _call(IdentityPrecompile, OrderFulfilled_offerDataOffset, size);

            // Copy into the correct region of calldata.
            assembly {
                returndatacopy(
                    add(callData, ValidateOrder_offerDataOffset),
                    0,
                    size
                )
            }

            _callAndCheckStatus(parameters.zone, orderHash, callData);
        }
    }

    /**
     * @dev Internal view function to determine whether an order is a restricted
     *      order and, if so, to ensure that it was either submitted by the
     *      offerer or the zone for the order, or that the zone returns the
     *      expected magic value upon performing a staticcall to `isValidOrder`
     *      or `isValidOrderIncludingExtraData` depending on whether the order
     *      fulfillment specifies extra data or criteria resolvers.
     *
     * @param advancedOrder     The advanced order in question.
     * @param orderHashes       The order hashes of each order supplied prior to
     *                          the current order as part of a "match" variety
     *                          of order fulfillment (e.g. this array will be
     *                          empty for single or "fulfill available").
     * @param orderHash         The hash of the order.
     */
    function _assertRestrictedAdvancedOrderValidity(
        AdvancedOrder memory advancedOrder,
        bytes32[] memory orderHashes,
        bytes32 orderHash
    ) internal {
        // Order type 2-3 require zone or offerer be caller or zone to approve.
        bool isRestricted;
        {
            OrderType orderType = advancedOrder.parameters.orderType;
            assembly {
                isRestricted := or(eq(orderType, 2), eq(orderType, 3))
            }
        }
        if (
            isRestricted &&
            !_unmaskedAddressComparison(msg.sender, advancedOrder.parameters.zone) &&
            !_unmaskedAddressComparison(msg.sender, advancedOrder.parameters.offerer)
        ) {
            // TODO: optimize (conversion is temporary to get it to compile)
            bytes memory callData = _generateCallData(
                orderHash,
                orderHashes,
                advancedOrder.parameters.zoneHash,
                advancedOrder.parameters.offerer,
                _convertOffer(advancedOrder.parameters.offer),
                _convertConsideration(advancedOrder.parameters.consideration),
                advancedOrder.extraData,
                advancedOrder.parameters.startTime,
                advancedOrder.parameters.endTime
            );

            _callAndCheckStatus(advancedOrder.parameters.zone, orderHash, callData);
        }
    }

    function _generateCallData(
        bytes32 orderHash,
        bytes32[] memory orderHashes,
        bytes32 zoneHash,
        address offerer,
        SpentItem[] memory offer,
        ReceivedItem[] memory consideration,
        bytes memory extraData,
        uint256 startTime,
        uint256 endTime
    ) internal view returns (bytes memory) {
        // TODO: optimize (conversion is temporary to get it to compile)
        return
            abi.encodeWithSelector(
                ZoneInterface.validateOrder.selector,
                ZoneParameters(
                    orderHash,
                    msg.sender,
                    offerer,
                    offer,
                    consideration,
                    extraData,
                    orderHashes,
                    startTime,
                    endTime,
                    zoneHash
                )
            );
    }

    function _callAndCheckStatus(
        address zone,
        bytes32 orderHash,
        bytes memory callData
    ) internal {
        uint256 callDataLength = callData.length;
        uint256 callDataMemoryPointer;
        assembly {
            callDataMemoryPointer := add(callData, OneWord)
        }

        bool success = _call(zone, callDataMemoryPointer, callDataLength);

        // Ensure call was successful and returned correct magic value.
        _assertIsValidOrderCallSuccess(success, orderHash);
    }

    function _convertOffer(OfferItem[] memory offer)
        internal
        pure
        returns (SpentItem[] memory spentItems)
    {
        assembly {
            spentItems := offer
        }
    }

    function _convertConsideration(ConsiderationItem[] memory consideration)
        internal
        pure
        returns (ReceivedItem[] memory receivedItems)
    {
        assembly {
            receivedItems := consideration
        }
    }

    /**
     * @dev Internal view function to ensure that a call to `validateOrder`
     *      as part of validating a restricted order that was not submitted by
     *      the named zone was successful and returned the required magic value.
     *
     * @param success   A boolean indicating the status of the staticcall.
     * @param orderHash The order hash of the order in question.
     */
    function _assertIsValidOrderCallSuccess(bool success, bytes32 orderHash)
        internal
        view
    {
        // If the call failed...
        if (!success) {
            // Revert and pass reason along if one was returned.
            _revertWithReasonIfOneIsReturned();

            // Otherwise, revert with a generic error message.
            _revertInvalidRestrictedOrder(orderHash);
        }

        // Ensure result was extracted and matches isValidOrder magic value.
        if (_doesNotMatchMagic(ZoneInterface.validateOrder.selector)) {
            _revertInvalidRestrictedOrder(orderHash);
        }
    }
}
