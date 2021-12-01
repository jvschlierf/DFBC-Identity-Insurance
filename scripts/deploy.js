async function main() {
    const propNFT = await ethers.getContractFactory("propNFT")
  
    // Start deployment, returning a promise that resolves to a contract object
    const PropNFT = await propNFT.deploy()
    console.log("Contract deployed to address:", PropNFT.address)
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })
  