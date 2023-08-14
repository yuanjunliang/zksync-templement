import dotenv from "dotenv";
dotenv.config({});
import { Deployer } from "@matterlabs/hardhat-zksync-deploy";
import { Wallet } from "zksync-web3";
import hre from "hardhat";

const PRIVATE_KEY = process.env.PRIVATE_KEY || "";
if (!PRIVATE_KEY) {
  throw "Please config private key";
}

// UUPS deployment
// other proxy see: https://era.zksync.io/docs/tools/hardhat/hardhat-zksync-upgradable.html
export default async function mint() {
  const contractName = "BatchTransferUpgradeable";
  const zkWallet = new Wallet(PRIVATE_KEY);
  const deployer = new Deployer(hre, zkWallet);
  const contract = await deployer.loadArtifact(contractName);
  const batchTransfer = await hre.zkUpgrades.deployProxy(
    deployer.zkWallet,
    contract,
    [],
    { initializer: "initialize" }
  );

  await batchTransfer.deployed();
}
