// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EntitlementTokenV1 is ERC721, ERC721Enumerable, Ownable {
    constructor() ERC721("EntitlementTokenV1", "ET") {}

    enum EntitlementState {
        ACTIVE,
        INACTIVE,
        EXPIRED
    }

    struct EntitlementInfo {
        uint256 registeredOn;
        EntitlementState state;
        string productId;
    }

    // List of all the entitlements tokens issued
    EntitlementInfo[] _tokens;

    function grant(
        address account,
        string memory productId) public onlyOwner returns (uint256) {
        require(account != address(0), "mint to the zero address");

        // create new token
        EntitlementInfo memory token = EntitlementInfo({
            state: EntitlementState.ACTIVE,
            registeredOn: block.timestamp,
            productId: productId
        });

        _tokens.push(token);
        uint256 tokenId = _tokens.length - 1;

        _safeMint(account, tokenId);
        return tokenId;
    }

    function revoke(
        address account, 
        uint256 _tokenId) public onlyOwner {
        require(account != address(0), "mint to the zero address");

        EntitlementInfo storage token = _tokens[_tokenId];
        require(token.registeredOn != 0);
        require(token.state == EntitlementState.ACTIVE);

        token.state = EntitlementState.INACTIVE;
    }
    
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // PRIVATE
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) 
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}