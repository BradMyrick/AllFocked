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
import "@openzeppelin/contracts/access/Ownable.sol";


contract FockedAirdropper is ERC721Holder, Ownable {
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

    uint256[] private tokenIds;

    constructor(address _nftContractAddress, address[] memory _addresses, uint256[] memory _Ids) {
        nftContractAddress = _nftContractAddress;
        require(_addresses.length == _Ids.length, "FockedAirdropper: Address and Ids array lengths do not match");
        for (uint256 i = 0; i < _addresses.length; i++) {
            _airdropList.add(_addresses[i]);
        }
        for (uint256 i = 0; i < _Ids.length; i++) {
            _tokenIds.set(_Ids[i], _addresses[i]);
        }
        tokenIds = _Ids;
    }

    // Transfer all of the NFTs from the given address to this contract
    function SendAllNFTs(address _from) external {
        require(_from != address(0), "FockedAirdropper: Cannot send from the zero address");
        require(_from != address(this), "FockedAirdropper: Cannot send from this contract");
        require(nftContractAddress != address(0), "FockedAirdropper: NFT contract address is not set");
        uint256 balance = IERC721(nftContractAddress).balanceOf(_from);
        require(balance == _tokenIds.length(), "FockedAirdropper: NFT balance does not match the number of token ids");
        for (uint256 i = 0; i < balance; i++) {
            // sender must have approved this contract to transfer the NFTs
            IERC721(nftContractAddress).safeTransferFrom(_from, address(this), tokenIds[i]); 
        }
    }



}