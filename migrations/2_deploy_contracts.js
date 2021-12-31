const Test = artifacts.require('./Test.sol')
const NFT = artifacts.require('./NFT.sol')
const Token = artifacts.require('./Token.sol')
const Marketplace = artifacts.require('./Marketplace.sol')
const UserInfo = artifacts.require('./UserInfo.sol')

module.exports = async deployer => {
    // await deployer.deploy(Test, 5)
    // await deployer.deploy(NFT)
    // await deployer.deploy(Token)

    const {tokenAddress, nftAddress} = require(`../${deployer.network}_address.json`)
    console.log({tokenAddress, nftAddress})

    // await deployer.deploy(UserInfo, tokenAddress, nftAddress)
    await deployer.deploy(Marketplace, tokenAddress, nftAddress)
}
