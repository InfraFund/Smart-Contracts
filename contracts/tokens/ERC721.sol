// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract CharityNFT is ERC721URIStorage {
    
    uint256 private _tokenIds;
    address private mintableOwner;
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        mintableOwner = msg.sender;
    }

    function awardItem(address investor, string memory tokenURI)
        public
        returns (uint256)
    {
        require(msg.sender == mintableOwner, "You have not permission");
        _tokenIds += 1;

        _mint(investor, _tokenIds);
        _setTokenURI(_tokenIds, tokenURI);

        return _tokenIds;
    }
}