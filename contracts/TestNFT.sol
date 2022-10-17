// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract TestNFT is ERC721A, Ownable {
  
  constructor(address receiver) ERC721A("AllFockedV2", "AF2") {
    // mint 20 nfts to the receiver
    _safeMint(receiver, 20);
  }

  function mintMore(address receiver, uint256 _mintAmount) public onlyOwner {
    _safeMint(receiver, _mintAmount);
  }
  
 
}