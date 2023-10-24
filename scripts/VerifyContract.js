const hre = require("hardhat");

async function main() {
await hre.run("verify:verify", {
    address: "0x8Eb6B4D40D35243352aBAD59BFDB27a161F3Bdc1",
    constructorArguments: [
        "0x3B2FA3fB4c7eD3bC495F276DC60782b635bB04d9","0x3B2FA3fB4c7eD3bC495F276DC60782b635bB04d9"
    ],
  });
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });