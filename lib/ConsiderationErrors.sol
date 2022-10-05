// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

import "./ConsiderationConstants.sol";

function _revertBadContractSignature() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  BadContractSignature_error_selector)
		// revert(abi.encodeWithSignature("BadContractSignature()"))
		revert(0x1c, BadContractSignature_error_length)
	}
}

function _revertBadFraction() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  BadFraction_error_selector)
		// revert(abi.encodeWithSignature("BadFraction()"))
		revert(0x1c, BadFraction_error_length)
	}
}

function _revertBadSignatureV(uint8 v) pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  BadSignatureV_error_selector)
		mstore(BadSignatureV_error_v_ptr, v)
		// revert(abi.encodeWithSignature("BadSignatureV(uint8)", v))
		revert(0x1c, BadSignatureV_error_length)
	}
}

function _revertConsiderationCriteriaResolverOutOfRange() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  ConsiderationCriteriaResolverOutOfRange_error_selector)
		// revert(abi.encodeWithSignature("ConsiderationCriteriaResolverOutOfRange()"))
		revert(0x1c, ConsiderationCriteriaResolverOutOfRange_error_length)
	}
}

function _revertConsiderationNotMet(uint256 orderIndex, uint256 considerationIndex, uint256 shortfallAmount) pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  ConsiderationNotMet_error_selector)
		mstore(ConsiderationNotMet_error_orderIndex_ptr, orderIndex)
		mstore(ConsiderationNotMet_error_considerationIndex_ptr, considerationIndex)
		mstore(ConsiderationNotMet_error_shortfallAmount_ptr, shortfallAmount)
		// revert(abi.encodeWithSignature("ConsiderationNotMet(uint256,uint256,uint256)", orderIndex, considerationIndex, shortfallAmount))
		revert(0x1c, ConsiderationNotMet_error_length)
	}
}

function _revertCriteriaNotEnabledForItem() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  CriteriaNotEnabledForItem_error_selector)
		// revert(abi.encodeWithSignature("CriteriaNotEnabledForItem()"))
		revert(0x1c, CriteriaNotEnabledForItem_error_length)
	}
}

function _revertEtherTransferGenericFailure(address account, uint256 amount) pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  EtherTransferGenericFailure_error_selector)
		mstore(EtherTransferGenericFailure_error_account_ptr, account)
		mstore(EtherTransferGenericFailure_error_amount_ptr, amount)
		// revert(abi.encodeWithSignature("EtherTransferGenericFailure(address,uint256)", account, amount))
		revert(0x1c, EtherTransferGenericFailure_error_length)
	}
}

function _revertInexactFraction() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  InexactFraction_error_selector)
		// revert(abi.encodeWithSignature("InexactFraction()"))
		revert(0x1c, InexactFraction_error_length)
	}
}

function _revertInsufficientEtherSupplied() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  InsufficientEtherSupplied_error_selector)
		// revert(abi.encodeWithSignature("InsufficientEtherSupplied()"))
		revert(0x1c, InsufficientEtherSupplied_error_length)
	}
}

function _revertInvalid1155BatchTransferEncoding() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  Invalid1155BatchTransferEncoding_error_selector)
		// revert(abi.encodeWithSignature("Invalid1155BatchTransferEncoding()"))
		revert(0x1c, Invalid1155BatchTransferEncoding_error_length)
	}
}

function _revertInvalidBasicOrderParameterEncoding() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  InvalidBasicOrderParameterEncoding_error_selector)
		// revert(abi.encodeWithSignature("InvalidBasicOrderParameterEncoding()"))
		revert(0x1c, InvalidBasicOrderParameterEncoding_error_length)
	}
}

function _revertInvalidCallToConduit(address conduit) pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  InvalidCallToConduit_error_selector)
		mstore(InvalidCallToConduit_error_conduit_ptr, conduit)
		// revert(abi.encodeWithSignature("InvalidCallToConduit(address)", conduit))
		revert(0x1c, InvalidCallToConduit_error_length)
	}
}

function _revertInvalidCanceller() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  InvalidCanceller_error_selector)
		// revert(abi.encodeWithSignature("InvalidCanceller()"))
		revert(0x1c, InvalidCanceller_error_length)
	}
}

function _revertInvalidConduit(bytes32 conduitKey, address conduit) pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  InvalidConduit_error_selector)
		mstore(InvalidConduit_error_conduitKey_ptr, conduitKey)
		mstore(InvalidConduit_error_conduit_ptr, conduit)
		// revert(abi.encodeWithSignature("InvalidConduit(bytes32,address)", conduitKey, conduit))
		revert(0x1c, InvalidConduit_error_length)
	}
}

function _revertInvalidERC721TransferAmount() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  InvalidERC721TransferAmount_error_selector)
		// revert(abi.encodeWithSignature("InvalidERC721TransferAmount()"))
		revert(0x1c, InvalidERC721TransferAmount_error_length)
	}
}

function _revertInvalidFulfillmentComponentData() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  InvalidFulfillmentComponentData_error_selector)
		// revert(abi.encodeWithSignature("InvalidFulfillmentComponentData()"))
		revert(0x1c, InvalidFulfillmentComponentData_error_length)
	}
}

function _revertInvalidMsgValue(uint256 value) pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  InvalidMsgValue_error_selector)
		mstore(InvalidMsgValue_error_value_ptr, value)
		// revert(abi.encodeWithSignature("InvalidMsgValue(uint256)", value))
		revert(0x1c, InvalidMsgValue_error_length)
	}
}

function _revertInvalidNativeOfferItem() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  InvalidNativeOfferItem_error_selector)
		// revert(abi.encodeWithSignature("InvalidNativeOfferItem()"))
		revert(0x1c, InvalidNativeOfferItem_error_length)
	}
}

function _revertInvalidProof() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  InvalidProof_error_selector)
		// revert(abi.encodeWithSignature("InvalidProof()"))
		revert(0x1c, InvalidProof_error_length)
	}
}

function _revertInvalidRestrictedOrder(bytes32 orderHash) pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  InvalidRestrictedOrder_error_selector)
		mstore(InvalidRestrictedOrder_error_orderHash_ptr, orderHash)
		// revert(abi.encodeWithSignature("InvalidRestrictedOrder(bytes32)", orderHash))
		revert(0x1c, InvalidRestrictedOrder_error_length)
	}
}

function _revertInvalidSignature() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  InvalidSignature_error_selector)
		// revert(abi.encodeWithSignature("InvalidSignature()"))
		revert(0x1c, InvalidSignature_error_length)
	}
}

function _revertInvalidSigner() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  InvalidSigner_error_selector)
		// revert(abi.encodeWithSignature("InvalidSigner()"))
		revert(0x1c, InvalidSigner_error_length)
	}
}

function _revertInvalidTime() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  InvalidTime_error_selector)
		// revert(abi.encodeWithSignature("InvalidTime()"))
		revert(0x1c, InvalidTime_error_length)
	}
}

function _revertMismatchedFulfillmentOfferAndConsiderationComponents() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  MismatchedFulfillmentOfferAndConsiderationComponents_error_selector)
		// revert(abi.encodeWithSignature("MismatchedFulfillmentOfferAndConsiderationComponents()"))
		revert(0x1c, MismatchedFulfillmentOfferAndConsiderationComponents_error_length)
	}
}

function _revertMissingFulfillmentComponentOnAggregation(uint8 side) pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  MissingFulfillmentComponentOnAggregation_error_selector)
		mstore(MissingFulfillmentComponentOnAggregation_error_side_ptr, side)
		// revert(abi.encodeWithSignature("MissingFulfillmentComponentOnAggregation(uint8)", side))
		revert(0x1c, MissingFulfillmentComponentOnAggregation_error_length)
	}
}

function _revertMissingItemAmount() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  MissingItemAmount_error_selector)
		// revert(abi.encodeWithSignature("MissingItemAmount()"))
		revert(0x1c, MissingItemAmount_error_length)
	}
}

function _revertMissingOriginalConsiderationItems() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  MissingOriginalConsiderationItems_error_selector)
		// revert(abi.encodeWithSignature("MissingOriginalConsiderationItems()"))
		revert(0x1c, MissingOriginalConsiderationItems_error_length)
	}
}

function _revertNoReentrantCalls() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  NoReentrantCalls_error_selector)
		// revert(abi.encodeWithSignature("NoReentrantCalls()"))
		revert(0x1c, NoReentrantCalls_error_length)
	}
}

function _revertNoSpecifiedOrdersAvailable() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  NoSpecifiedOrdersAvailable_error_selector)
		// revert(abi.encodeWithSignature("NoSpecifiedOrdersAvailable()"))
		revert(0x1c, NoSpecifiedOrdersAvailable_error_length)
	}
}

function _revertOfferAndConsiderationRequiredOnFulfillment() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  OfferAndConsiderationRequiredOnFulfillment_error_selector)
		// revert(abi.encodeWithSignature("OfferAndConsiderationRequiredOnFulfillment()"))
		revert(0x1c, OfferAndConsiderationRequiredOnFulfillment_error_length)
	}
}

function _revertOfferCriteriaResolverOutOfRange() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  OfferCriteriaResolverOutOfRange_error_selector)
		// revert(abi.encodeWithSignature("OfferCriteriaResolverOutOfRange()"))
		revert(0x1c, OfferCriteriaResolverOutOfRange_error_length)
	}
}

function _revertOrderAlreadyFilled(bytes32 orderHash) pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  OrderAlreadyFilled_error_selector)
		mstore(OrderAlreadyFilled_error_orderHash_ptr, orderHash)
		// revert(abi.encodeWithSignature("OrderAlreadyFilled(bytes32)", orderHash))
		revert(0x1c, OrderAlreadyFilled_error_length)
	}
}

function _revertOrderCriteriaResolverOutOfRange() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  OrderCriteriaResolverOutOfRange_error_selector)
		// revert(abi.encodeWithSignature("OrderCriteriaResolverOutOfRange()"))
		revert(0x1c, OrderCriteriaResolverOutOfRange_error_length)
	}
}

function _revertOrderIsCancelled(bytes32 orderHash) pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  OrderIsCancelled_error_selector)
		mstore(OrderIsCancelled_error_orderHash_ptr, orderHash)
		// revert(abi.encodeWithSignature("OrderIsCancelled(bytes32)", orderHash))
		revert(0x1c, OrderIsCancelled_error_length)
	}
}

function _revertOrderPartiallyFilled(bytes32 orderHash) pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  OrderPartiallyFilled_error_selector)
		mstore(OrderPartiallyFilled_error_orderHash_ptr, orderHash)
		// revert(abi.encodeWithSignature("OrderPartiallyFilled(bytes32)", orderHash))
		revert(0x1c, OrderPartiallyFilled_error_length)
	}
}

function _revertPartialFillsNotEnabledForOrder() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  PartialFillsNotEnabledForOrder_error_selector)
		// revert(abi.encodeWithSignature("PartialFillsNotEnabledForOrder()"))
		revert(0x1c, PartialFillsNotEnabledForOrder_error_length)
	}
}

function _revertUnresolvedConsiderationCriteria() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  UnresolvedConsiderationCriteria_error_selector)
		// revert(abi.encodeWithSignature("UnresolvedConsiderationCriteria()"))
		revert(0x1c, UnresolvedConsiderationCriteria_error_length)
	}
}

function _revertUnresolvedOfferCriteria() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  UnresolvedOfferCriteria_error_selector)
		// revert(abi.encodeWithSignature("UnresolvedOfferCriteria()"))
		revert(0x1c, UnresolvedOfferCriteria_error_length)
	}
}

function _revertUnusedItemParameters() pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  UnusedItemParameters_error_selector)
		// revert(abi.encodeWithSignature("UnusedItemParameters()"))
		revert(0x1c, UnusedItemParameters_error_length)
	}
}

function _revertPanic(uint256 code) pure {
	assembly {
		// Store left-padded selector with push4 (reduces bytecode), mem[28:32] = selector
		mstore(0,  Panic_error_selector)
		mstore(Panic_error_code_ptr, code)
		// revert(abi.encodeWithSignature("Panic(uint256)", code))
		revert(0x1c, Panic_error_length)
	}
}