// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

import "./ConsiderationConstants.sol";

/**
 * @dev Reverts the current transaction with a "BadFraction" error message.
 */
function _revertBadFraction() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, BadFraction_error_selector)
        // revert(abi.encodeWithSignature("BadFraction()"))
        revert(Error_selector_offset, BadFraction_error_length)
    }
}

/**
 * @dev Reverts the current transaction with a
 *      "ConsiderationCriteriaResolverOutOfRange" error message.
 */
function _revertConsiderationCriteriaResolverOutOfRange() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, ConsiderationCriteriaResolverOutOfRange_error_selector)
        // revert(abi.encodeWithSignature("ConsiderationCriteriaResolverOutOfRange()"))
        revert(
            Error_selector_offset,
            ConsiderationCriteriaResolverOutOfRange_error_length
        )
    }
}

/**
 * @dev Reverts the current transaction with a "ConsiderationNotMet" error
 *      message, including the provided order index, consideration index, and
 *      shortfall amount.
 *
 * @param orderIndex         The index of the order that did not meet the
 *                           consideration criteria.
 * @param considerationIndex The index of the consideration item that did not
 *                           meet its criteria.
 * @param shortfallAmount    The amount by which the consideration criteria were
 *                           not met.
 */
function _revertConsiderationNotMet(
    uint256 orderIndex,
    uint256 considerationIndex,
    uint256 shortfallAmount
) pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, ConsiderationNotMet_error_selector)
        mstore(ConsiderationNotMet_error_orderIndex_ptr, orderIndex)
        mstore(
            ConsiderationNotMet_error_considerationIndex_ptr,
            considerationIndex
        )
        mstore(ConsiderationNotMet_error_shortfallAmount_ptr, shortfallAmount)
        // revert(abi.encodeWithSignature("ConsiderationNotMet(uint256,uint256,uint256)", orderIndex, considerationIndex, shortfallAmount))
        revert(Error_selector_offset, ConsiderationNotMet_error_length)
    }
}

/**
 * @dev Reverts the current transaction with a "CriteriaNotEnabledForItem" error
 *      message.
 */
function _revertCriteriaNotEnabledForItem() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, CriteriaNotEnabledForItem_error_selector)
        // revert(abi.encodeWithSignature("CriteriaNotEnabledForItem()"))
        revert(Error_selector_offset, CriteriaNotEnabledForItem_error_length)
    }
}

/**
 * @dev Reverts the current transaction with an "InsufficientEtherSupplied"
 *      error message.
 */
function _revertInsufficientEtherSupplied() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, InsufficientEtherSupplied_error_selector)
        // revert(abi.encodeWithSignature("InsufficientEtherSupplied()"))
        revert(Error_selector_offset, InsufficientEtherSupplied_error_length)
    }
}

/**
 * @dev Reverts the current transaction with an
 *      "InvalidBasicOrderParameterEncoding" error message.
 */
function _revertInvalidBasicOrderParameterEncoding() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, InvalidBasicOrderParameterEncoding_error_selector)
        // revert(abi.encodeWithSignature("InvalidBasicOrderParameterEncoding()"))
        revert(
            Error_selector_offset,
            InvalidBasicOrderParameterEncoding_error_length
        )
    }
}

/**
 * @dev Reverts the current transaction with an "InvalidCallToConduit" error
 *      message, including the provided address of the conduit that was called
 *      improperly.
 *
 * @param conduit The address of the conduit that was called improperly.
 */
function _revertInvalidCallToConduit(address conduit) pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, InvalidCallToConduit_error_selector)
        mstore(InvalidCallToConduit_error_conduit_ptr, conduit)
        // revert(abi.encodeWithSignature("InvalidCallToConduit(address)", conduit))
        revert(Error_selector_offset, InvalidCallToConduit_error_length)
    }
}

/**
 * @dev Reverts the current transaction with an "InvalidCanceller" error
 *      message.
 */
function _revertInvalidCanceller() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, InvalidCanceller_error_selector)
        // revert(abi.encodeWithSignature("InvalidCanceller()"))
        revert(Error_selector_offset, InvalidCanceller_error_length)
    }
}

/**
 * @dev Reverts the current transaction with an "InvalidConduit" error message,
 *      including the provided key and address of the invalid conduit.
 *
 * @param conduitKey    The key of the invalid conduit.
 * @param conduit       The address of the invalid conduit.
 */
function _revertInvalidConduit(bytes32 conduitKey, address conduit) pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, InvalidConduit_error_selector)
        mstore(InvalidConduit_error_conduitKey_ptr, conduitKey)
        mstore(InvalidConduit_error_conduit_ptr, conduit)
        // revert(abi.encodeWithSignature("InvalidConduit(bytes32,address)", conduitKey, conduit))
        revert(Error_selector_offset, InvalidConduit_error_length)
    }
}

/**
 * @dev Reverts the current transaction with an "InvalidERC721TransferAmount"
 *      error message.
 */
function _revertInvalidERC721TransferAmount() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, InvalidERC721TransferAmount_error_selector)
        // revert(abi.encodeWithSignature("InvalidERC721TransferAmount()"))
        revert(Error_selector_offset, InvalidERC721TransferAmount_error_length)
    }
}

/**
 * @dev Reverts the current transaction with an "InvalidMsgValue" error message,
 *      including the invalid value that was sent in the transaction's
 *      `msg.value` field.
 *
 * @param value The invalid value that was sent in the transaction's `msg.value`
 *              field.
 */
function _revertInvalidMsgValue(uint256 value) pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, InvalidMsgValue_error_selector)
        mstore(InvalidMsgValue_error_value_ptr, value)
        // revert(abi.encodeWithSignature("InvalidMsgValue(uint256)", value))
        revert(Error_selector_offset, InvalidMsgValue_error_length)
    }
}

/**
 * @dev Reverts the current transaction with an "InvalidNativeOfferItem" error
 *      message.
 */
function _revertInvalidNativeOfferItem() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, InvalidNativeOfferItem_error_selector)
        // revert(abi.encodeWithSignature("InvalidNativeOfferItem()"))
        revert(Error_selector_offset, InvalidNativeOfferItem_error_length)
    }
}

/**
 * @dev Reverts the current transaction with an "InvalidProof" error message.
 */
function _revertInvalidProof() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, InvalidProof_error_selector)
        // revert(abi.encodeWithSignature("InvalidProof()"))
        revert(Error_selector_offset, InvalidProof_error_length)
    }
}

/**
 * @dev Reverts the current transaction with an "InvalidRestrictedOrder" error
 *      message.
 *
 * @param orderHash The hash of the restricted order that caused the error.
 */
function _revertInvalidRestrictedOrder(bytes32 orderHash) pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, InvalidRestrictedOrder_error_selector)
        mstore(InvalidRestrictedOrder_error_orderHash_ptr, orderHash)
        // revert(abi.encodeWithSignature("InvalidRestrictedOrder(bytes32)", orderHash))
        revert(Error_selector_offset, InvalidRestrictedOrder_error_length)
    }
}

/**
 * @dev Reverts the current transaction with an "InvalidContractOrder" error
 *      message.
 *
 * @param orderHash The hash of the contract order that caused the error.
 */
function _revertInvalidContractOrder(bytes32 orderHash) pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, InvalidContractOrder_error_selector)
        mstore(InvalidContractOrder_error_orderHash_ptr, orderHash)
        // revert(abi.encodeWithSignature("InvalidContractOrder(bytes32)", orderHash))
        revert(Error_selector_offset, InvalidContractOrder_error_length)
    }
}

/**
 * @dev Reverts the current transaction with an "InvalidTime" error message.
 */
function _revertInvalidTime() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, InvalidTime_error_selector)
        // revert(abi.encodeWithSignature("InvalidTime()"))
        revert(Error_selector_offset, InvalidTime_error_length)
    }
}

/**
 * @dev Reverts execution with a
 *      "MismatchedFulfillmentOfferAndConsiderationComponents" error message.
 */
function _revertMismatchedFulfillmentOfferAndConsiderationComponents() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(
            0,
            MismatchedFulfillmentOfferAndConsiderationComponents_error_selector
        )
        // revert(abi.encodeWithSignature("MismatchedFulfillmentOfferAndConsiderationComponents()"))
        revert(
            Error_selector_offset,
            MismatchedFulfillmentOfferAndConsiderationComponents_error_length
        )
    }
}

/**
 * @dev Reverts execution with a "MissingFulfillmentComponentOnAggregation"
 *       error message.
 *
 * @param side The side of the fulfillment component that is missing (0 for offer, 1 for consideration).
 *
 */
function _revertMissingFulfillmentComponentOnAggregation(uint8 side) pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, MissingFulfillmentComponentOnAggregation_error_selector)
        mstore(MissingFulfillmentComponentOnAggregation_error_side_ptr, side)
        // revert(abi.encodeWithSignature("MissingFulfillmentComponentOnAggregation(uint8)", side))
        revert(
            Error_selector_offset,
            MissingFulfillmentComponentOnAggregation_error_length
        )
    }
}

/**
 * @dev Reverts execution with a "MissingOriginalConsiderationItems" error
 *      message.
 */
function _revertMissingOriginalConsiderationItems() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, MissingOriginalConsiderationItems_error_selector)
        // revert(abi.encodeWithSignature("MissingOriginalConsiderationItems()"))
        revert(
            Error_selector_offset,
            MissingOriginalConsiderationItems_error_length
        )
    }
}

/**
 * @dev Reverts execution with a "NoReentrantCalls" error message.
 */
function _revertNoReentrantCalls() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, NoReentrantCalls_error_selector)
        // revert(abi.encodeWithSignature("NoReentrantCalls()"))
        revert(Error_selector_offset, NoReentrantCalls_error_length)
    }
}

/**
 * @dev Reverts execution with a "NoSpecifiedOrdersAvailable" error message.
 */
function _revertNoSpecifiedOrdersAvailable() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, NoSpecifiedOrdersAvailable_error_selector)
        // revert(abi.encodeWithSignature("NoSpecifiedOrdersAvailable()"))
        revert(Error_selector_offset, NoSpecifiedOrdersAvailable_error_length)
    }
}

/**
 * @dev Reverts execution with a "OfferAndConsiderationRequiredOnFulfillment"
 *      error message.
 */
function _revertOfferAndConsiderationRequiredOnFulfillment() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, OfferAndConsiderationRequiredOnFulfillment_error_selector)
        // revert(abi.encodeWithSignature("OfferAndConsiderationRequiredOnFulfillment()"))
        revert(
            Error_selector_offset,
            OfferAndConsiderationRequiredOnFulfillment_error_length
        )
    }
}

/**
 * @dev Reverts execution with a "OfferCriteriaResolverOutOfRange" error
 *      message.
 */
function _revertOfferCriteriaResolverOutOfRange() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, OfferCriteriaResolverOutOfRange_error_selector)
        // revert(abi.encodeWithSignature("OfferCriteriaResolverOutOfRange()"))
        revert(
            Error_selector_offset,
            OfferCriteriaResolverOutOfRange_error_length
        )
    }
}

/**
 * @dev Reverts execution with an "OrderAlreadyFilled" error message.
 *
 * @param orderHash The hash of the order that has already been filled.
 */
function _revertOrderAlreadyFilled(bytes32 orderHash) pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, OrderAlreadyFilled_error_selector)
        mstore(OrderAlreadyFilled_error_orderHash_ptr, orderHash)
        // revert(abi.encodeWithSignature("OrderAlreadyFilled(bytes32)", orderHash))
        revert(Error_selector_offset, OrderAlreadyFilled_error_length)
    }
}

/**
 * @dev Reverts execution with an "OrderCriteriaResolverOutOfRange" error
 *      message.
 */
function _revertOrderCriteriaResolverOutOfRange() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, OrderCriteriaResolverOutOfRange_error_selector)
        // revert(abi.encodeWithSignature("OrderCriteriaResolverOutOfRange()"))
        revert(
            Error_selector_offset,
            OrderCriteriaResolverOutOfRange_error_length
        )
    }
}

/**
 * @dev Reverts execution with an "OrderIsCancelled" error message.
 *
 * @param orderHash The hash of the order that has already been cancelled.
 */
function _revertOrderIsCancelled(bytes32 orderHash) pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, OrderIsCancelled_error_selector)
        mstore(OrderIsCancelled_error_orderHash_ptr, orderHash)
        // revert(abi.encodeWithSignature("OrderIsCancelled(bytes32)", orderHash))
        revert(Error_selector_offset, OrderIsCancelled_error_length)
    }
}

/**
 * @dev Reverts execution with an "OrderPartiallyFilled" error message.
 *
 * @param orderHash The hash of the order that has already been partially filled.
 */
function _revertOrderPartiallyFilled(bytes32 orderHash) pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, OrderPartiallyFilled_error_selector)
        mstore(OrderPartiallyFilled_error_orderHash_ptr, orderHash)
        // revert(abi.encodeWithSignature("OrderPartiallyFilled(bytes32)", orderHash))
        revert(Error_selector_offset, OrderPartiallyFilled_error_length)
    }
}

/**
 * @dev Reverts execution with a "PartialFillsNotEnabledForOrder" error message.
 */

function _revertPartialFillsNotEnabledForOrder() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, PartialFillsNotEnabledForOrder_error_selector)
        // revert(abi.encodeWithSignature("PartialFillsNotEnabledForOrder()"))
        revert(
            Error_selector_offset,
            PartialFillsNotEnabledForOrder_error_length
        )
    }
}

/**
 * @dev Reverts execution with an "UnresolvedConsiderationCriteria" error message.
 */

function _revertUnresolvedConsiderationCriteria() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, UnresolvedConsiderationCriteria_error_selector)
        // revert(abi.encodeWithSignature("UnresolvedConsiderationCriteria()"))
        revert(
            Error_selector_offset,
            UnresolvedConsiderationCriteria_error_length
        )
    }
}

/**
 * @dev Reverts execution with an "UnresolvedOfferCriteria" error message.
 */

function _revertUnresolvedOfferCriteria() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, UnresolvedOfferCriteria_error_selector)
        // revert(abi.encodeWithSignature("UnresolvedOfferCriteria()"))
        revert(Error_selector_offset, UnresolvedOfferCriteria_error_length)
    }
}

/**
 * @dev Reverts execution with an "UnusedItemParameters" error message.
 */

function _revertUnusedItemParameters() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, UnusedItemParameters_error_selector)
        // revert(abi.encodeWithSignature("UnusedItemParameters()"))
        revert(Error_selector_offset, UnusedItemParameters_error_length)
    }
}

function _revertConsiderationLengthExceedsTotalOriginal() pure {
    assembly {
        // Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
        mstore(0, ConsiderationLengthExceedsTotalOriginal_error_selector)
        // revert(abi.encodeWithSignature("UnusedItemParameters()"))
        revert(
            Error_selector_offset,
            ConsiderationLengthExceedsTotalOriginal_error_length
        )
    }
}
