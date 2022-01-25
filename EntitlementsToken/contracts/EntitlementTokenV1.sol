// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Ownable.sol";

contract Entitlements is Ownable {
    
    enum EntitlementState {
        ACTIVE,
        INACTIVE,
        EXPIRED
    }

    struct EntitlementData {
        uint256 registeredOn;
        EntitlementState state;
        string productId;
    }

    mapping(string => mapping(string => EntitlementData)) _users;

    function grant(
        string memory puid,
        string memory productId) public onlyOwner () {

        // create new token
        EntitlementData memory entitlement = EntitlementData({
            state: EntitlementState.ACTIVE,
            registeredOn: block.timestamp,
            productId: productId
        });

        _users[puid][productId] = entitlement;
    }

    function revoke(
        string memory puid,
        string memory productId) public onlyOwner () {

        _users[puid][productId].state = EntitlementState.INACTIVE;
    }

    function state(
        string memory puid,
        string memory productId) public view returns (EntitlementState) {

        return _users[puid][productId].state;
    }

    function details(
        string memory puid,
        string memory productId) public view returns (EntitlementData memory) {

        return _users[puid][productId];
    }
}