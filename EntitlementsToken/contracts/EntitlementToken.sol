// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "contracts/Ownable.sol";

contract EntitlementToken is Ownable {
    enum EntitlementState {
        ACTIVE,
        INACTIVE,
        EXPIRED
    }

    uint256 constant LICENSE_LIFE_TIME = 30 days;

    struct EntitlementInfo {
        uint256 registeredOn;
        uint256 expiresOn;
        EntitlementState state;
        string deviceId;
    }

    // List of all the entitlements tokens issued
    EntitlementInfo[] tokens;

    mapping(uint256 => address) public tokenIndexToOwner;
    mapping(address => uint256) ownershipTokenCount;
    mapping(uint256 => address) public tokenIndexToApproved;

    event GrantEntitlement(address account, uint256 tokenId);
    event Transfer(address from, address to, uint256 tokenId);
    event Approval(address owner, address approved, uint256 tokenId);

    constructor() {}

    // ERC-721 functions
    function totalSupply() public view returns (uint256 total) {
        return tokens.length;
    }

    function balanceOf(address _account) public view returns (uint256 balance) {
        return ownershipTokenCount[_account];
    }

    function ownerOf(uint256 _tokenId) public view returns (address owner) {
        owner = tokenIndexToOwner[_tokenId];
        require(owner != address(0));

        return owner;
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public onlyOwner {
        require(_to != address(0));
        require(_to != address(this));
        require(_owns(_from, _tokenId));

        _transfer(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public {
        require(_owns(msg.sender, _tokenId));
        tokenIndexToApproved[_tokenId] = _to;
        emit Approval(
            tokenIndexToOwner[_tokenId],
            tokenIndexToApproved[_tokenId],
            _tokenId
        );
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public {
        // method is not implemented because it is not needed for licensing logic
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) public {
        // method is not implemented because it is not needed for licensing logic
    }

    function setApprovalForAll(address _operator, bool _approved) public pure {
        // method is not implemented because it is not needed for licensing logic
    }

    function getApproved(uint256 _tokenId) public pure returns (address) {
        // method is not implemented because it is not needed for licensing logic
        return address(0);
    }

    function isApprovedForAll(address _owner, address _operator) public pure returns (bool)
    {
        // method is not implemented because it is not needed for licensing logic
        return false;
    }

    // licensing logic
    function grant(address _account) public onlyOwner {
        uint256 tokenId = _mint(_account);
        emit GrantEntitlement(_account, tokenId);
    }

    function activate(uint256 _tokenId, string memory _deviceId) public onlyOwner {
        EntitlementInfo storage token = tokens[_tokenId];
        require(token.registeredOn != 0);
        require(token.state == EntitlementState.INACTIVE);

        token.state = EntitlementState.ACTIVE;
        token.expiresOn = block.timestamp + LICENSE_LIFE_TIME;
        token.deviceId = _deviceId;
    }

    function burn(address _account, uint256 _tokenId) public onlyOwner {
        require(tokenIndexToOwner[_tokenId] == _account);

        ownershipTokenCount[_account]--;
        delete tokenIndexToOwner[_tokenId];
        delete tokens[_tokenId];
        delete tokenIndexToApproved[_tokenId];
    }

    function isLicenseActive(address _account, uint256 _tokenId) public view returns (uint256 state) {
        require(tokenIndexToOwner[_tokenId] == _account);

        EntitlementInfo memory token = tokens[_tokenId];
        if (
            token.expiresOn < block.timestamp &&
            token.state == EntitlementState.ACTIVE
        ) {
            return uint256(EntitlementState.EXPIRED);
        }

        return uint256(token.state);
    }

    function handleExpiredLicense(address _account, uint256 _tokenId) public onlyOwner {
        require(tokenIndexToOwner[_tokenId] == _account);

        EntitlementInfo storage token = tokens[_tokenId];
        if (token.expiresOn < block.timestamp && token.state == EntitlementState.ACTIVE) {
            burn(_account, _tokenId);
        }
    }

    // internal methods
    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return tokenIndexToOwner[_tokenId] == _claimant;
    }

    function _mint(address _account) internal onlyOwner returns (uint256 tokenId) {
        // create new token
        EntitlementInfo memory token = EntitlementInfo({
            state: EntitlementState.INACTIVE,
            registeredOn: block.timestamp,
            expiresOn: 0,
            deviceId: ""
        });
        tokens.push(token);
        uint256 id = tokens.length - 1;
        _transfer(address(0), _account, id);
        return id;
    }

    function _transfer(address _from, address _to, uint256 _tokenId ) internal {
        ownershipTokenCount[_to]++;
        tokenIndexToOwner[_tokenId] = _to;

        if (_from != address(0)) {
            ownershipTokenCount[_from]--;
            delete tokenIndexToApproved[_tokenId];
        }
        emit Transfer(_from, _to, _tokenId);
    }
}
