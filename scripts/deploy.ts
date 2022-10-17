import { ethers } from "hardhat";

async function main() {
  const _nftContractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  const _addresses: string[] = ["0x5FbDB2315678afecb367f032d93F642f64180aa3", "0x5FbDB2315678afecb367f032d93F642f64180aa3", "0x5FbDB2315678afecb367f032d93F642f64180aa3"];
  const _Ids: number[] = [8, 15, 69];
  const Airdropper = await ethers.getContractFactory("FockedAirdropper");
  const airdropper = await Airdropper.deploy(_nftContractAddress, _addresses, _Ids);

  await airdropper.deployed();

  console.log(`Airdropper deployed to ${airdropper.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
