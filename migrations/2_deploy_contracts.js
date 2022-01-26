const Test = artifacts.require('./Test.sol')
const KingAnimalNFT = artifacts.require('./KingAnimalNFT.sol')
const KingAnimalItem = artifacts.require('./KingAnimalItem.sol')
const Token = artifacts.require('./Token.sol')
const UserInfo = artifacts.require('./UserInfo.sol')
const Marketplace = artifacts.require('./Marketplace.sol')
const Store = artifacts.require('./Store.sol')
const KaiMarketplace = artifacts.require('./KaiMarketplace.sol')
const KaiStore = artifacts.require('./KaiStore.sol')

module.exports = async deployer => {
    // await deployer.deploy(Test, 5)
    // await deployer.deploy(KingAnimalNFT)
    // await deployer.deploy(KingAnimalItem)
    // await deployer.deploy(Token)

    const {tokenAddress, nftAddress, kaiAddress} = require(`../${deployer.network}_address.json`)
    console.log({tokenAddress, nftAddress, kaiAddress})

    // await deployer.deploy(Marketplace, tokenAddress, nftAddress)
    // await deployer.deploy(Store, tokenAddress, nftAddress)

    // await deployer.deploy(KaiMarketplace, tokenAddress, kaiAddress)
    // await deployer.deploy(KaiStore, tokenAddress, kaiAddress)

    // await deployer.deploy(UserInfo, tokenAddress, nftAddress, kaiAddress)
}
