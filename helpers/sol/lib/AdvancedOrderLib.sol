// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { ItemType } from "../../../lib/ConsiderationEnums.sol";

import {
    AdditionalRecipient,
    AdvancedOrder,
    BasicOrderParameters,
    ConsiderationItem,
    OfferItem,
    Order,
    OrderParameters,
    OrderType
} from "../../../lib/ConsiderationStructs.sol";

import { BasicOrderType } from "../../../lib/ConsiderationEnums.sol";

import { OrderParametersLib } from "./OrderParametersLib.sol";

import { StructCopier } from "./StructCopier.sol";

/**
 * @title AdvancedOrderLib
 * @author James Wenzel (emo.eth)
 * @notice AdditionalRecipientLib is a library for managing AdvancedOrder
 *         structs and arrays. It allows chaining of functions to make struct
 *         creation more readable.
 */
library AdvancedOrderLib {
    bytes32 private constant ADVANCED_ORDER_MAP_POSITION =
        keccak256("seaport.AdvancedOrderDefaults");
    bytes32 private constant ADVANCED_ORDERS_MAP_POSITION =
        keccak256("seaport.AdvancedOrdersDefaults");
    bytes32 private constant EMPTY_ADVANCED_ORDER =
        keccak256(
            abi.encode(
                AdvancedOrder({
                    parameters: OrderParameters({
                        offerer: address(0),
                        zone: address(0),
                        offer: new OfferItem[](0),
                        consideration: new ConsiderationItem[](0),
                        orderType: OrderType(0),
                        startTime: 0,
                        endTime: 0,
                        zoneHash: bytes32(0),
                        salt: 0,
                        conduitKey: bytes32(0),
                        totalOriginalConsiderationItems: 0
                    }),
                    numerator: 0,
                    denominator: 0,
                    signature: new bytes(0),
                    extraData: new bytes(0)
                })
            )
        );

    using OrderParametersLib for OrderParameters;

    /**
     * @dev Clears a default AdvancedOrder from storage.
     *
     * @param defaultName the name of the default to clear
     */
    function clear(string memory defaultName) internal {
        mapping(string => AdvancedOrder)
            storage advancedOrderMap = _advancedOrderMap();
        AdvancedOrder storage item = advancedOrderMap[defaultName];
        clear(item);
    }

    /**
     * @dev Clears all fields on an AdvancedOrder.
     *
     * @param item the AdvancedOrder to clear
     */
    function clear(AdvancedOrder storage item) internal {
        // clear all fields
        item.parameters.clear();
        item.signature = "";
        item.numerator = 0;
        item.denominator = 0;
        item.extraData = "";
    }

    /**
     * @dev Clears an array of AdvancedOrders from storage.
     *
     * @param items the AdvancedOrders to clear
     */
    function clear(AdvancedOrder[] storage items) internal {
        while (items.length > 0) {
            clear(items[items.length - 1]);
            items.pop();
        }
    }

    /**
     * @dev Gets a default AdvancedOrder from storage.
     *
     * @param defaultName the name of the default for retrieval
     *
     * @return item the AdvancedOrder retrieved from storage
     */
    function fromDefault(
        string memory defaultName
    ) internal view returns (AdvancedOrder memory item) {
        mapping(string => AdvancedOrder)
            storage advancedOrderMap = _advancedOrderMap();
        item = advancedOrderMap[defaultName];

        if (keccak256(abi.encode(item)) == EMPTY_ADVANCED_ORDER) {
            revert("Empty AdvancedOrder selected.");
        }
    }

    /**
     * @dev Gets an array of default AdvancedOrders from storage.
     *
     * @param defaultName the name of the default for retrieval
     *
     * @return items the AdvancedOrders retrieved from storage
     */
    function fromDefaultMany(
        string memory defaultName
    ) internal view returns (AdvancedOrder[] memory items) {
        mapping(string => AdvancedOrder[])
            storage advancedOrdersMap = _advancedOrdersMap();
        items = advancedOrdersMap[defaultName];

        if (items.length == 0) {
            revert("Empty AdvancedOrder array selected.");
        }
    }

    /**
     * @dev Returns an empty AdvancedOrder.
     *
     * @custom:return item the empty AdvancedOrder
     */
    function empty() internal pure returns (AdvancedOrder memory) {
        return AdvancedOrder(OrderParametersLib.empty(), 0, 0, "", "");
    }

    /**
     * @dev Saves an AdvancedOrder as a named default.
     *
     * @param advancedOrder the AdvancedOrder to save as a default
     * @param defaultName   the name of the new default
     *
     * @return _advancedOrder the AdvancedOrder saved as a default
     */
    function saveDefault(
        AdvancedOrder memory advancedOrder,
        string memory defaultName
    ) internal returns (AdvancedOrder memory _advancedOrder) {
        mapping(string => AdvancedOrder)
            storage advancedOrderMap = _advancedOrderMap();
        StructCopier.setAdvancedOrder(
            advancedOrderMap[defaultName],
            advancedOrder
        );
        return advancedOrder;
    }

    /**
     * @dev Saves an array of AdvancedOrders as a named default.
     *
     * @param advancedOrders the AdvancedOrders to save as a default
     * @param defaultName    the name of the new default
     *
     * @return _advancedOrders the AdvancedOrders saved as a default
     */
    function saveDefaultMany(
        AdvancedOrder[] memory advancedOrders,
        string memory defaultName
    ) internal returns (AdvancedOrder[] memory _advancedOrders) {
        mapping(string => AdvancedOrder[])
            storage advancedOrdersMap = _advancedOrdersMap();
        StructCopier.setAdvancedOrders(
            advancedOrdersMap[defaultName],
            advancedOrders
        );
        return advancedOrders;
    }

    /**
     * @dev Makes a copy of an AdvancedOrder in-memory.
     *
     * @param item the AdvancedOrder to make a copy of in-memory
     *
     * @custom:return item the copied AdvancedOrder
     */
    function copy(
        AdvancedOrder memory item
    ) internal pure returns (AdvancedOrder memory) {
        return
            AdvancedOrder({
                parameters: item.parameters.copy(),
                numerator: item.numerator,
                denominator: item.denominator,
                signature: item.signature,
                extraData: item.extraData
            });
    }

    /**
     * @dev Makes a copy of an array of AdvancedOrders in-memory.
     *
     * @param items the AdvancedOrders to make a copy of in-memory
     *
     * @custom:return items the copied AdvancedOrders
     */
    function copy(
        AdvancedOrder[] memory items
    ) internal pure returns (AdvancedOrder[] memory) {
        AdvancedOrder[] memory copiedItems = new AdvancedOrder[](items.length);
        for (uint256 i = 0; i < items.length; i++) {
            copiedItems[i] = copy(items[i]);
        }
        return copiedItems;
    }

    /**
     * @dev Gets the storage position of the default AdvancedOrder map.
     *
     * @return advancedOrderMap the storage position of the default
     *                          AdvancedOrder map
     */
    function _advancedOrderMap()
        private
        pure
        returns (mapping(string => AdvancedOrder) storage advancedOrderMap)
    {
        bytes32 position = ADVANCED_ORDER_MAP_POSITION;
        assembly {
            advancedOrderMap.slot := position
        }
    }

    /**
     * @dev Gets the storage position of the default AdvancedOrder array map.
     *
     * @return advancedOrdersMap the storage position of the default
     *                           AdvancedOrder array map
     */
    function _advancedOrdersMap()
        private
        pure
        returns (mapping(string => AdvancedOrder[]) storage advancedOrdersMap)
    {
        bytes32 position = ADVANCED_ORDERS_MAP_POSITION;
        assembly {
            advancedOrdersMap.slot := position
        }
    }

    // Methods for configuring a single of each of an AdvancedOrder's fields,
    // which modify the AdvancedOrder in-place and return it.

    /**
     * @dev Configures an AdvancedOrder's parameters.
     *
     * @param advancedOrder the AdvancedOrder to configure
     * @param parameters    the parameters to set
     *
     * @custom:return _advancedOrder the configured AdvancedOrder
     */
    function withParameters(
        AdvancedOrder memory advancedOrder,
        OrderParameters memory parameters
    ) internal pure returns (AdvancedOrder memory) {
        advancedOrder.parameters = parameters.copy();
        return advancedOrder;
    }

    /**
     * @dev Configures an AdvancedOrder's numerator.
     *
     * @param advancedOrder the AdvancedOrder to configure
     * @param numerator     the numerator to set
     *
     * @custom:return _advancedOrder the configured AdvancedOrder
     */
    function withNumerator(
        AdvancedOrder memory advancedOrder,
        uint120 numerator
    ) internal pure returns (AdvancedOrder memory) {
        advancedOrder.numerator = numerator;
        return advancedOrder;
    }

    /**
     * @dev Configures an AdvancedOrder's denominator.
     *
     * @param advancedOrder the AdvancedOrder to configure
     * @param denominator   the denominator to set
     *
     * @custom:return _advancedOrder the configured AdvancedOrder
     */
    function withDenominator(
        AdvancedOrder memory advancedOrder,
        uint120 denominator
    ) internal pure returns (AdvancedOrder memory) {
        advancedOrder.denominator = denominator;
        return advancedOrder;
    }

    /**
     * @dev Configures an AdvancedOrder's signature.
     *
     * @param advancedOrder the AdvancedOrder to configure
     * @param signature     the signature to set
     *
     * @custom:return _advancedOrder the configured AdvancedOrder
     */
    function withSignature(
        AdvancedOrder memory advancedOrder,
        bytes memory signature
    ) internal pure returns (AdvancedOrder memory) {
        advancedOrder.signature = signature;
        return advancedOrder;
    }

    /**
     * @dev Configures an AdvancedOrder's extra data.
     *
     * @param advancedOrder the AdvancedOrder to configure
     * @param extraData     the extra data to set
     *
     * @custom:return _advancedOrder the configured AdvancedOrder
     */
    function withExtraData(
        AdvancedOrder memory advancedOrder,
        bytes memory extraData
    ) internal pure returns (AdvancedOrder memory) {
        advancedOrder.extraData = extraData;
        return advancedOrder;
    }

    /**
     * @dev Converts an AdvancedOrder to an Order.
     *
     * @param advancedOrder the AdvancedOrder to convert
     *
     * @return order the converted Order
     */
    function toOrder(
        AdvancedOrder memory advancedOrder
    ) internal pure returns (Order memory order) {
        order.parameters = advancedOrder.parameters.copy();
        order.signature = advancedOrder.signature;
    }

    /**
     * @dev Converts an AdvancedOrder[] to an Order[].
     *
     * @param advancedOrders the AdvancedOrder[] to convert
     *
     * @return the converted Order[]
     */
    function toOrders(
        AdvancedOrder[] memory advancedOrders
    ) internal pure returns (Order[] memory) {
        Order[] memory orders = new Order[](advancedOrders.length);

        for (uint256 i; i < advancedOrders.length; ++i) {
            orders[i] = toOrder(advancedOrders[i]);
        }
        return orders;
    }

    /**
     * @dev Converts an AdvancedOrder to a BasicOrderParameters.
     *
     * @param advancedOrder  the AdvancedOrder to convert
     * @param basicOrderType the BasicOrderType to convert to
     *
     * @return basicOrderParameters the BasicOrderParameters
     */
    function toBasicOrderParameters(
        AdvancedOrder memory advancedOrder,
        BasicOrderType basicOrderType
    ) internal pure returns (BasicOrderParameters memory basicOrderParameters) {
        basicOrderParameters.considerationToken = advancedOrder
            .parameters
            .consideration[0]
            .token;
        basicOrderParameters.considerationIdentifier = advancedOrder
            .parameters
            .consideration[0]
            .identifierOrCriteria;
        basicOrderParameters.considerationAmount = advancedOrder
            .parameters
            .consideration[0]
            .endAmount;
        basicOrderParameters.offerer = payable(
            advancedOrder.parameters.offerer
        );
        basicOrderParameters.zone = advancedOrder.parameters.zone;
        basicOrderParameters.offerToken = advancedOrder
            .parameters
            .offer[0]
            .token;
        basicOrderParameters.offerIdentifier = advancedOrder
            .parameters
            .offer[0]
            .identifierOrCriteria;
        basicOrderParameters.offerAmount = advancedOrder
            .parameters
            .offer[0]
            .endAmount;
        basicOrderParameters.basicOrderType = basicOrderType;
        basicOrderParameters.startTime = advancedOrder.parameters.startTime;
        basicOrderParameters.endTime = advancedOrder.parameters.endTime;
        basicOrderParameters.zoneHash = advancedOrder.parameters.zoneHash;
        basicOrderParameters.salt = advancedOrder.parameters.salt;
        basicOrderParameters.offererConduitKey = advancedOrder
            .parameters
            .conduitKey;
        basicOrderParameters.fulfillerConduitKey = advancedOrder
            .parameters
            .conduitKey;
        basicOrderParameters.totalOriginalAdditionalRecipients =
            advancedOrder.parameters.totalOriginalConsiderationItems -
            1;

        AdditionalRecipient[]
            memory additionalRecipients = new AdditionalRecipient[](
                advancedOrder.parameters.consideration.length - 1
            );
        for (
            uint256 i = 1;
            i < advancedOrder.parameters.consideration.length;
            i++
        ) {
            additionalRecipients[i - 1] = AdditionalRecipient({
                recipient: advancedOrder.parameters.consideration[i].recipient,
                amount: advancedOrder.parameters.consideration[i].startAmount
            });
        }

        basicOrderParameters.additionalRecipients = additionalRecipients;
        basicOrderParameters.signature = advancedOrder.signature;

        return basicOrderParameters;
    }

    function coerceAmountsForPartialFulfillment(
        AdvancedOrder memory order
    ) internal pure {
        OrderParameters memory orderParams = order.parameters;
        for (uint256 i = 0; i < orderParams.offer.length; ++i) {
            uint256 newStartAmount;
            uint256 newEndAmount;
            OfferItem memory item = orderParams.offer[i];

            if (
                item.itemType == ItemType.ERC721 ||
                item.itemType == ItemType.ERC721_WITH_CRITERIA
            ) {
                uint256 amount = uint256(order.denominator / order.numerator);
                newStartAmount = amount;
                newEndAmount = amount;
            } else {
                (
                    newStartAmount,
                    newEndAmount
                ) = deriveFractionCompatibleAmounts(
                    item.startAmount,
                    item.endAmount,
                    orderParams.startTime,
                    orderParams.endTime,
                    order.numerator,
                    order.denominator
                );
            }

            order.parameters.offer[i].startAmount = newStartAmount;
            order.parameters.offer[i].endAmount = newEndAmount;
        }

        // Adjust consideration item amounts based on the fraction
        for (uint256 i = 0; i < orderParams.consideration.length; ++i) {
            uint256 newStartAmount;
            uint256 newEndAmount;
            ConsiderationItem memory item = orderParams.consideration[i];

            if (
                item.itemType == ItemType.ERC721 ||
                item.itemType == ItemType.ERC721_WITH_CRITERIA
            ) {
                uint256 amount = uint256(order.denominator / order.numerator);
                newStartAmount = amount;
                newEndAmount = amount;
            } else {
                (
                    newStartAmount,
                    newEndAmount
                ) = deriveFractionCompatibleAmounts(
                    item.startAmount,
                    item.endAmount,
                    orderParams.startTime,
                    orderParams.endTime,
                    order.numerator,
                    order.denominator
                );
            }

            order.parameters.consideration[i].startAmount = newStartAmount;
            order.parameters.consideration[i].endAmount = newEndAmount;
        }
    }

    function deriveFractionCompatibleAmounts(
        uint256 originalStartAmount,
        uint256 originalEndAmount,
        uint256 startTime,
        uint256 endTime,
        uint256 numerator,
        uint256 denominator
    ) internal pure returns (uint256 newStartAmount, uint256 newEndAmount) {
        if (
            startTime >= endTime ||
            numerator > denominator ||
            numerator == 0 ||
            denominator == 0 ||
            (originalStartAmount == 0 && originalEndAmount == 0)
        ) {
            revert(
                "AdvancedOrderLib: bad inputs to deriveFractionCompatibleAmounts"
            );
        }

        uint256 duration = endTime - startTime;

        // determine if duration or numerator is more likely to overflow when multiplied by value
        uint256 overflowBottleneck = (numerator > duration)
            ? numerator
            : duration;

        uint256 absoluteMax = type(uint256).max / overflowBottleneck;
        uint256 fractionCompatibleMax = (absoluteMax / denominator) *
            denominator;

        newStartAmount = originalStartAmount % fractionCompatibleMax;
        newStartAmount = (newStartAmount / denominator) * denominator;
        newStartAmount = (newStartAmount == 0) ? denominator : newStartAmount;

        newEndAmount = originalEndAmount % fractionCompatibleMax;
        newEndAmount = (newEndAmount / denominator) * denominator;
        newEndAmount = (newEndAmount == 0) ? denominator : newEndAmount;

        if (newStartAmount == 0 && newEndAmount == 0) {
            revert("AdvancedOrderLib: derived amount will always be zero");
        }
    }
}
