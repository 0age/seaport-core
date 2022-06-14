// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;

/**
 * This deployer is designed to be owned by a gnosis safe, DAO, or trusted
 * party. It can deploy new PausableZone contracts, which can be used as a zone.
 */

import { PausableZone } from "./PausableZone.sol";

// prettier-ignore
import {
    PausableZoneEventsAndErrors
} from "./interfaces/PausableZoneEventsAndErrors.sol";

// prettier-ignore
import {
    Order,
    Fulfillment,
    OrderComponents,
    AdvancedOrder,
    CriteriaResolver,
    Execution
} from "../lib/ConsiderationStructs.sol";

import { SeaportInterface } from "../interfaces/SeaportInterface.sol";

/**
 * @title  PausableZoneController
 * @author cupOJoseph, BCLeFevre, stuckinaboot
 * @notice PausableZoneController enables deploying, pausing and executing orders on PausableZones.
 */
contract PausableZoneController is PausableZoneEventsAndErrors {
    // Set the owner that can deploy, pause and execute orders on a PausableZone.
    address internal _deployerOwner;

    // Set the address of the new potential owner of the zone.
    address private _potentialOwner;

    // Set the address with the ability to pause the zone.
    address internal _pauserAddress;

    bytes32 public immutable zoneCreationCode;

    /**
     * @dev Throws if called by any account other than the owner or pauser.
     */
    modifier isPauser() {
        if (msg.sender != _pauserAddress && msg.sender != _deployerOwner) {
            revert InvalidPauser();
        }
        _;
    }

    /**
     * @notice Set the owner of the controller and store
     *         the zone creation code.
     *
     * @param deployerOwner The deployer to be set as the owner.
     */
    constructor(address deployerOwner) {
        // Set the deployer as the own
        _deployerOwner = deployerOwner;

        // Hash and store the zone creation code.
        zoneCreationCode = keccak256(type(PausableZone).creationCode);
    }

    /**
     * @notice Deploy a PausableZone to a precomputed address.
     *
     * @param salt The salt to be used to derive the zone address
     *
     * @return derivedAddress The derived address for the zone.
     */
    function createZone(bytes32 salt)
        external
        returns (address derivedAddress)
    {
        // Ensure the caller is the owner.
        require(
            msg.sender == _deployerOwner,
            "Only owner can create new Zones from here."
        );

        // Derive the PausableZone address.
        // This expression demonstrates address computation but is not required.
        derivedAddress = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            address(this),
                            salt,
                            zoneCreationCode
                        )
                    )
                )
            )
        );

        // Revert if a zone is currently deployed to the derived address.
        if (derivedAddress.code.length != 0) {
            revert ZoneAlreadyExists(derivedAddress);
        }

        // Deploy the zone using the supplied salt.
        new PausableZone{ salt: salt }();

        // Emit an event signifying that the zone was created.
        emit ZoneCreated(derivedAddress, salt);
    }

    /**
     * @notice Pause orders on a given zone.
     *
     * @param zone The address of the zone to be paused.
     *
     * @return success A boolean indicating the zone has been paused.
     */
    function pause(address zone) external isPauser returns (bool success) {
        // Call pause on the given zone.
        PausableZone(zone).pause();

        // Return a boolean indicating the pause was successful.
        success = true;
    }

    /**
     * @notice Use a zone to cancel a restricted Seaport offer.
     *
     * @param pausableZoneAddress The zone that manages the orders to be cancelled.
     * @param seaportAddress      The Seaport address.
     * @param orders              The orders to cancel.
     */
    function cancelOrderZone(
        address pausableZoneAddress,
        SeaportInterface seaportAddress,
        OrderComponents[] calldata orders
    ) external {
        // Ensure the caller is the owner.
        require(
            msg.sender == _deployerOwner,
            "Only the owner can cancel orders with the zone."
        );

        // Create a zone object from the zone address.
        PausableZone zone = PausableZone(pausableZoneAddress);

        // Cancel the orders.
        zone.cancelOrders(seaportAddress, orders);
    }

    /**
     * @notice Execute an arbitrary number of matched orders on a given zone.
     *
     * @param pausableZoneAddress The zone that manages the orders to be cancelled.
     * @param seaportAddress      The Seaport address.
     * @param orders              The orders to match.
     * @param fulfillments        An array of elements allocating offer components
     *                            to consideration components.
     *
     * @return executions An array of elements indicating the sequence of
     *                    transfers performed as part of matching the given
     *                    orders.
     */
    function executeMatchOrdersZone(
        address pausableZoneAddress,
        SeaportInterface seaportAddress,
        Order[] calldata orders,
        Fulfillment[] calldata fulfillments
    ) external payable returns (Execution[] memory executions) {
        // Ensure the caller is the owner.
        require(
            msg.sender == _deployerOwner,
            "Only the owner can execute orders with the zone."
        );

        // Create a zone object from the zone address.
        PausableZone zone = PausableZone(pausableZoneAddress);

        // Call executeMatchOrders on the given zone and return the sequence
        // of transfers performed as part of matching the given orders.
        executions = zone.executeMatchOrders{ value: msg.value }(
            seaportAddress,
            orders,
            fulfillments
        );
    }

    /**
     * @notice Execute an arbitrary number of matched advanced orders on a given zone.
     *
     * @param pausableZoneAddress The zone that manages the orders to be cancelled.
     * @param seaportAddress      The Seaport address.
     * @param orders              The orders to match.
     * @param criteriaResolvers   An array where each element contains a reference
     *                            to a specific order as well as that order's
     *                            offer or consideration, a token identifier, and
     *                            a proof that the supplied token identifier is
     *                            contained in the order's merkle root.
     * @param fulfillments        An array of elements allocating offer components
     *                            to consideration components.
     *
     * @return executions An array of elements indicating the sequence of
     *                    transfers performed as part of matching the given
     *                    orders.
     */
    function executeMatchAdvancedOrdersZone(
        address pausableZoneAddress,
        SeaportInterface seaportAddress,
        AdvancedOrder[] calldata orders,
        CriteriaResolver[] calldata criteriaResolvers,
        Fulfillment[] calldata fulfillments
    ) external payable returns (Execution[] memory executions) {
        // Ensure the caller is the owner.
        require(
            msg.sender == _deployerOwner,
            "Only the owner can execute advanced orders with the zone."
        );

        // Create a zone object from the zone address.
        PausableZone zone = PausableZone(pausableZoneAddress);

        // Call executeMatchOrders on the given zone and return the sequence
        // of transfers performed as part of matching the given orders.
        executions = zone.executeMatchAdvancedOrders{ value: msg.value }(
            seaportAddress,
            orders,
            criteriaResolvers,
            fulfillments
        );
    }

    /**
     * @notice Initiate Zone ownership transfer by assigning a new potential
     *         owner this contract. Once set, the new potential owner
     *         may call `acceptOwnership` to claim ownership.
     *         Only the owner in question may call this function.
     *
     * @param newPotentialOwner The address for which to initiate ownership
     *                          transfer to.
     */
    function transferOwnership(address newPotentialOwner) external {
        // Ensure the caller is the owner.
        require(
            msg.sender == _deployerOwner,
            "Only Owner can transfer Ownership."
        );

        // Ensure the new potential owner is not an invalid address.
        require(
            newPotentialOwner != address(0),
            "New Owner can not be 0 address."
        );

        // Emit an event indicating that the potential owner has been updated.
        emit PotentialOwnerUpdated(newPotentialOwner);

        // Set the new potential owner as the potential owner.
        _potentialOwner = newPotentialOwner;
    }

    /**
     * @notice Clear the currently set potential owner, if any.
     *         Only the owner of this contract may call this function.
     */
    function cancelOwnershipTransfer() external {
        // Ensure the caller is the current owner.
        require(msg.sender == _deployerOwner, "Only Owner can cancel.");

        // Emit an event indicating that the potential owner has been cleared.
        emit PotentialOwnerUpdated(address(0));

        // Clear the current new potential owner.
        delete _potentialOwner;
    }

    /**
     * @notice Accept ownership of this contract. Only accounts that the
     *         current owner has set as the new potential owner may call this
     *         function.
     */
    function acceptOwnership() external {
        // Ensure the caller is the potential owner.
        require(
            msg.sender == _potentialOwner,
            "Only Potential Owner can claim."
        );

        // Emit an event indicating that the potential owner has been cleared.
        emit PotentialOwnerUpdated(address(0));

        // Clear the current new potential owner
        delete _potentialOwner;

        // Emit an event indicating ownership has been transferred.
        emit OwnershipTransferred(_deployerOwner, msg.sender);

        // Set the caller as the owner of this contract.
        _deployerOwner = msg.sender;
    }

    /**
     * @notice Assign the given address with the ability to pause the zone.
     *
     * @param pauserToAssign The address to assign the pauser role.
     */
    function assignPauser(address pauserToAssign) external {
        // Ensure the caller is the owner.
        require(
            msg.sender == _deployerOwner,
            "Can only be set by the deployer"
        );

        // Ensure the pauser to assign is not an invalid address.
        require(
            pauserToAssign != address(0),
            "Pauser can not be set to the null address"
        );

        // Set the given account as the pauser.
        _pauserAddress = pauserToAssign;

        // Emit an event indicating the pauser has been assigned.
        emit PauserUpdated(_pauserAddress);
    }

    /**
     * @notice Assigns the given address with the ability to operate the
     *         give zone.
     *
     * @param globalPausableAddress Zone Address to assign operator role.
     * @param operatorToAssign      Address to assign role.
     */
    function assignOperatorOfZone(
        address globalPausableAddress,
        address operatorToAssign
    ) external {
        require(
            msg.sender == _deployerOwner,
            "Can only be set by the deployer"
        );
        PausableZone gp = PausableZone(globalPausableAddress);
        gp.assignOperator(operatorToAssign);
    }
}
