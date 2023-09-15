// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract VehicularNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721("VehicularCar", "VC Funded") {}

  function mintCar(string memory _tokenURI) public returns (uint256) {
    uint256 newItemId = _tokenIds.current();
    _mint(msg.sender, newItemId);
    _setTokenURI(newItemId, _tokenURI);

    _tokenIds.increment();
    return newItemId;
  }

  function isOwner(uint256 _tokenId) public view returns (bool) {
    return _ownerOf(_tokenId) == msg.sender;
  }
}
