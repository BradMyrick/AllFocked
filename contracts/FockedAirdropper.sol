// solidty contract that will transfer all of the tokens from an approved address to the contract address
// the contract will then distribute the tokens to the users who are listed in the airdrop list in the most Gas efficient way possible
// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.10;

import "./IERC721A.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract FockedAirdropper is ERC721Holder, Ownable {
    using Counters for Counters.Counter;
    using EnumerableMap for EnumerableMap.UintToAddressMap;

    // the address of the ERC721 contract that will be used to distribute the tokens
    address public nftContractAddress;

    // map recipient address to the amount of tokens they will receive
    EnumerableMap.UintToAddressMap private _tokenMap;

    constructor(address _nftContractAddress, address[] memory _addresses, uint256[] memory _Ids) {
        nftContractAddress = _nftContractAddress;
        require(_addresses.length == _Ids.length, "FockedAirdropper: Address and Ids array lengths do not match");
        for (uint256 i = 0; i < _addresses.length; i++) {
            _tokenMap.set(_Ids[i], _addresses[i]);
        }
    }

    // Transfer all of the NFTs from the given address to this contract
    function SendAllMyNFTs() external {
        require(msg.sender != address(0), "FockedAirdropper: Cannot send from the zero address");
        require(msg.sender != address(this), "FockedAirdropper: Cannot send from this contract");
        require(nftContractAddress != address(0), "FockedAirdropper: NFT contract address is not set");
        uint256 balance = IERC721A(nftContractAddress).balanceOf(msg.sender);
        require(balance == _tokenMap.length(), "FockedAirdropper: Sender does not have the correct amount of NFTs");
        for (uint256 i = 0; i < balance; i++) {
            // sender must have approved this contract to transfer the NFTs
            (uint256 tokenId,) = _tokenMap.at(i);
            IERC721A(nftContractAddress).safeTransferFrom(msg.sender, address(this), tokenId);
        }
    }

    // Airdorp the NFTs to the addresses in the airdrop list
    // no sender protection is needed because the NFTs are already in this contract and the airdrop list is set during contract creation
    function Airdrop() external {
        require(nftContractAddress != address(0), "FockedAirdropper: NFT contract address is not set");
        for (uint256 i = 0; i < _tokenMap.length(); i++) {
            (uint256 tokenId, address recipient) = _tokenMap.at(i);
            IERC721A(nftContractAddress).safeTransferFrom(address(this), recipient, tokenId);
        }
    }



}