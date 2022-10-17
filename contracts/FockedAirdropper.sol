// solidty contract that will transfer all of the tokens from an approved address to the contract address
// the contract will then distribute the tokens to the users who are listed in the airdrop list in the most Gas efficient way possible
// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract FockedAirdropper is ERC721Holder {
    using Address for address;
    using Counters for Counters.Counter;
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableMap for EnumerableMap.UintToAddressMap;
    using SafeMath for uint256;
    using Strings for uint256;

    // the address of the ERC721 contract that will be used to distribute the tokens
    address public nftContractAddress;

    // the list of addresses that will be receiving the tokens
    EnumerableSet.AddressSet private _airdropList;

    // the list of token ids that will be distributed
    EnumerableMap.UintToAddressMap private _tokenIds;

    constructor(address _nftContractAddress, address[] memory _addresses, uint256[] memory _tokenIds) {
        nftContractAddress = _nftContractAddress;
        for (uint256 i = 0; i < _addresses.length; i++) {
            _airdropList.add(_addresses[i]);
        }
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            _tokenIds.set(_tokenIds[i], _tokenIds[i]);
        }
    }