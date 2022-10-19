// solidty contract that will transfer all of the tokens from an approved address to the contract address
// the contract will then distribute the tokens to the users who are listed in the airdrop list in the most Gas efficient way possible
// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.10;

import "./IERC721A.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract AirdropRevolver is Ownable {
    bool public loaded;

    address[] public targets = 
        [0x2de799677F4d325dBefAAe8AcB02Ea9D203AbB72,
        0xC1dB77A7Ed5848B93B379aCDa285f018C98fe4e0,
        0xFa76e804f744ab86208FA35ef1Bbaf85961B623D,
        0x4a46Df3965195b7457cC5407E03Eb80ABcAE89ad,
        0x301184F35a2E7185E7F799C25df772dec9AB3264,
        0xAA94F936296D19a6bcb2B133a97e5719c9924F0F,
        0x4bAeA175b06ad1f814A72841c00d36A91540dd8E,
        0x890FCD10ED400bD94a4c6F599FCbe376B2081DA5,
        0x0A2D6BA3465b582D30C1153c6FD8A39A8894495C,
        0x1d38fd7269ccd8fd27411fea4c1c1d76e08ff318,
        0xc7b25fC95D1De5c711af1cf3bE33104fae19dCB2,
        0xe7b790968f960D08B0A7C7536B83D60bE657787b,
        0x4D062433cF0706A4c81C91DA22a56905f54b84E5,
        0x00d47bc0012a0BdEb194B9D40919a409C164C815,
        0x45A814D2a459b4DffEeD481C12A1a47395924d3B,
        0xc10FbbD62Ad5A90cFe81F2A8b67E300012ABA47E,
        0xb391D5ea0960DFaDA9DEc11c3a2a3D87D6AC1aD3,
        0x2402Cf77e9DC5282895517344B83cA5121A31cdA,
        0xCB52aE567A639b3e57C2CA64399320b50b1Bf312,
        0x21CC10D3AD42513D1d94B89dEf92c99ba0f8A2e3,
        0x462b605b44baac99d8c8664b4abf56d8d4bafa9f,
        0x001A8aE153ae1FD00FC3835041811e717c7E89dc,
        0x1444d57966700CE490Cc6F2E65C7B85B739A0d83,
        0x34f81bDf0C0378c98ED8CB6D6DA13bF547b8ebAA,
        0xabb92eB53497903d1f3a55A7723377cf1A61A53a,
        0x23151e2495aafe5aade160757fcf5fc35718421a,
        0xC5b8d4acB288CFD57fdcE817Ef03dD15fC00B3E3,
        0x62d7D025FE43C3880f45Df01D154de1596D8Ca49,
        0x6329d4a63E9C698EB295351de3f9E0A9C6791775,
        0xa84501016a01674C7927f1D865759F69773A2Fd3,
        0xdeDdd081A52186F2aCb950b28BB9C79a9aC15d27,
        0x1ffD2E597c87748010ef6345B417Abed67654ae7,
        0x19Db15d9308216B1E5cC5462123c4097cef9CcCb,
        0xB3c6144c929652D6046c01282FA2F355D9864dB9,
        0xFf90E6ebea367866305A5180be2f8A7D7232990d,
        0xE37C7c564A17ba3657574E4e43f4522a155FBbd6,
        0x23643532f0c3355Bd2E7138dA389B96e9926AD45,
        0xBaeCfDEa116000E6C3bcc26C80F443B7A81F7E59,
        0x30064ecb3382e8a1df24bb7f82fc5aea5da46faa,
        0x79b5e03df71eae7d52ad27ff255fc3678be1a1ab,
        0x459d5979a02828c4eaF218037A6451FDf43e3820,
        0x59288FF29B495b77Af052442d32392bc50995E49,
        0xfF9e15cB5A2F53DCAc1C4a5429D261FE151b7DaC,
        0x1F83E155b72833E2fa5733cBe4261073B4AC80eA,
        0x2A88F196Ab46DD6044E62C8A7F916272A526f313,
        0x2Be56150f9Ce242C6DD6a6aDc44DcbFF28f4B402,
        0x4af20E95FB67355aA1C7E9648Df13965f59020E8,
        0x33d3b0476aBA106cde11f01540253B60EEb2f74f,
        0xF964c6449AC4A2Fb571cE78F2229e6a936880686,
        0x38cadEE45A0AFE2E6EB68550ACb6Bb4009208fB9,
        0xD44363D70b5CE5995319c9933E43beb9825d724E,
        0x6506d81776826eA432c41d5147BAf28E9B8d2A8a,
        0xA668bd24A66Fba226c7947b0b417fA9e0C32d612,
        0xAb44cC6162F223D8B0718BAc47212624dCAB51C4,
        0xf3a86D0b49A1cE01A2D444bCbe2A69feB3856eb1,
        0xE5ec2C821A9BB0F867aF881F53E7c2517A31dBC5,
        0x64Bc737b1A030aaC323c073f11939DB7b9e8F347,
        0xcC507e6DDc3a6C992BC02019fbEeb8f81Be9FBb2,
        0x668ca185c3cDfA625115b0A5b0d35BCDADfe0327,
        0xC196df37Dc054e00b91411c89B8a5d5fDFeC3DF1,
        0x8c05c706463cb38cdcf7b018b24bac3e0ce7366d,
        0x445e3f99576EC775D871af9d6D969a45bAAD00ff,
        0xb5A68bB5996dB6124B2D91dFdDdc70322b2A58e5,
        0x982F4f2DD8Ba267971C19f118a9154515c5557A1,
        0x9e71f5EAb422D975740936664D52c37D720e5810,
        0x20C23a7Db9814E6ec235C9B01D3371Aae685F547,
        0xc0d404AF342CEE33953A3d7aA7a9c5469be16136,
        0xC645C8bDb7bAc795a7AaD2A2903d9C1EAB54b995,
        0x4E53b5E7C961081A91A58F49692D86c0cD69b1C6,
        0x21f6302E04744eF90bc9ee65B7CA556E078df9b6,
        0x41c3daB93881286A4e260577f05FEbC16DaFeD88,
        0xF49131a425121199195BFFAd974dEF36475729c3,
        0x9367Fa8408b34428E4Adf7d2afdF29F8C4f4782c,
        0x78BE8faE326683f16177EAB308f558a9c7e9BDa9,
        0xCCeAb0Afdbdf7018eA3722550E0Ff68Fcadb546d];

    // the address of the ERC721 contract that will be used to distribute the tokens
    address public nftContractAddress;

    // map recipient address to the tokens they will receive
    mapping(address => uint256[]) private Package;

    // vault address that holds the nfts
    address public ammoAddress;


    constructor(address _vaultAddress, address _nftContractAddress) {
        ammoAddress = _vaultAddress;
        nftContractAddress = _nftContractAddress;
    }

    function LoadRevolver(uint[] tokens) public onlyOwner {
        require(!loaded, "Revolver already loaded");
        loaded = true;
        uint returnpoint = targets.length - 1;
        uint ticker = 0;
        for (uint i = 0; i < tokens.length; i++) {
            _tokenMap.set(tokens[i], targets[ticker]);
        }
    }

    function FireRevolver() public onlyOwner { // ammoAddress must have approved the contract to transfer all tokens
        require(loaded, "Revolver not loaded");
        uint transferCount = targets.length;

            IERC721A(nftContractAddress).safeTransferFrom(ammoAddress, nextTarget, tokenId);
    }
    
    function EmptyRevolver() public onlyOwner {
        require(loaded, "Revolver not loaded");
        IERC721A(nftContractAddress).safeTransferFrom(vaultAddress, msg.sender, tokenId);
    }

}