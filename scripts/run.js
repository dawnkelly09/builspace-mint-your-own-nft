const main = async () => {
    // eslint-disable-next-line no-undef
    const nftContractFactory = await hre.ethers.getContractFactory('CryptoVan');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("the nft contract is: %s", nftContract.address);

    // call the mint nft function from the actual contract
    let txn = await nftContract.mintNFT();

    // wait for it to happen
    await txn.wait();
}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (err){
        console.log(err)
        process.exit(1);
    }
}

runMain();