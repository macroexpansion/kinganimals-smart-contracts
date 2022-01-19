// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/security/Pausable.sol';
import '@openzeppelin/contracts/access/AccessControl.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol';
import '@openzeppelin/contracts/utils/Counters.sol';

contract KingAnimalNFT is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    Pausable,
    AccessControl,
    ERC721Burnable
{
    using Counters for Counters.Counter;

    bytes32 public constant PAUSER_ROLE = keccak256('PAUSER_ROLE');
    bytes32 public constant MINTER_ROLE = keccak256('MINTER_ROLE');
    Counters.Counter public _tokenIdCounter;

    constructor() ERC721('King Animal NFT', 'KAN') {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public
        view
        override(ERC721, ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /**
     * Game item
     */
    struct Item {
        uint256 itemId;
    }

    mapping(uint256 => Item) public itemById;

    function getNftInfo(uint256 tokenId) external view returns (uint256) {
        return itemById[tokenId].itemId;
    }

    function _setItemId(uint256 tokenId, uint256 itemId) internal {
        itemById[tokenId] = Item(itemId);
    }

    function _mint(
        address user,
        string memory uri,
        uint256 itemId
    ) internal {
        _tokenIdCounter.increment();
        uint256 newTokenId = _tokenIdCounter.current();

        _setItemId(newTokenId, itemId);
        _safeMint(user, newTokenId);
        _setTokenURI(newTokenId, uri);
    }

    function mint(
        address user,
        string memory uri,
        uint256 itemId
    ) external onlyRole(MINTER_ROLE) {
        _mint(user, uri, itemId);
    }

    function setTokenURI(uint256 tokenId, string memory uri)
        external
        onlyRole(MINTER_ROLE)
    {
        _setTokenURI(tokenId, uri);
    }

    function setItemId(uint256 tokenId, uint256 itemId)
        external
        onlyRole(MINTER_ROLE)
    {
        _setItemId(tokenId, itemId);
    }
}
