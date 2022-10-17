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
    Counters.Counter private _lastUpload;

    // the address of the ERC721 contract that will be used to distribute the tokens
    address public nftContractAddress;

    // map recipient address to the amount of tokens they will receive
    EnumerableMap.UintToAddressMap private _tokenMap;

    // vault address that holds the nfts
    address public vaultAddress = 0x7A94B5f4C419975CfDce03f0FDf4b4C85acfcAb5;


    constructor(address _nftContractAddress) {
        nftContractAddress = _nftContractAddress;
    }

    function updateList (address[] memory _addresses, uint256[] memory _Ids) external onlyOwner {
        require(_addresses.length == _Ids.length, "FockedAirdropper: Address and Ids array lengths do not match");
        uint uploadId = _lastUpload.current();
        for (uint256 i = uploadId; i < (_addresses.length + uploadId); i++) {
            _tokenMap.set(_Ids[i], _addresses[i]);
            _lastUpload.increment();
        }
    }

    // this will clear the map and return some of the gas
    function clearList () external onlyOwner {
        delete _tokenMap; 
        _lastUpload.reset();
    }

    // Airdorp the NFTs to the addresses in the airdrop list
    // the vault address must have approved this contract to transfer all the NFTs
    function Airdrop() external onlyOwner {
        require(nftContractAddress != address(0), "FockedAirdropper: NFT contract address is not set");
        for (uint256 i = 0; i < _tokenMap.length(); i++) {
            (uint256 tokenId, address recipient) = _tokenMap.at(i);
            IERC721A(nftContractAddress).safeTransferFrom(vaultAddress , recipient, tokenId);
        }
    }

}