// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SmartWords is ERC721, ERC721Enumerable, ERC721URIStorage {
    using Counters for Counters.Counter;

    struct Quote {
        address author;
        bytes32 hashedQuote;
        uint256 timestamp; // uint48 can be use
        string quote;
    }

    Counters.Counter private _quoteIds;
    mapping(uint256 => Quote) private _quotes; // id to struct
    mapping(bytes32 => uint256) private _quoteId; // bytes32 to id

    event Quoted(address indexed author, bytes32 indexed hashedQuote, uint256 indexed quoteId, uint256 timestamp);

    constructor() ERC721("SmartWords", "SW") {}

    function quote(
        bytes32 hashedQuote_,
        string memory quote_,
        string memory uri_
    ) public returns (uint256) {
        require(_quoteId[hashedQuote_] == 0, "SmartWords: this quote is already register");
        _quoteIds.increment();
        uint256 currentId = _quoteIds.current();
        uint256 timestamp = block.timestamp;
        _mint(_msgSender(), currentId);
        _setTokenURI(currentId, uri_);
        _quotes[currentId] = Quote(_msgSender(), hashedQuote_, timestamp, quote_);
        _quoteId[hashedQuote_] = currentId;
        emit Quoted(_msgSender(), hashedQuote_, currentId, timestamp);
        return currentId;
    }

    function getQuoteById(uint256 id) public view returns (Quote memory) {
        return _quotes[id];
    }

    function getQuoteIdByHash(bytes32 quoteHash) public view returns (uint256) {
        return _quoteId[quoteHash];
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
}
