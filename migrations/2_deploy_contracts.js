const Test = artifacts.require('./Test.sol')
const NFT = artifacts.require('./NFT.sol')
const Token = artifacts.require('./Token.sol')

module.exports = async deployer => {
    // await deployer.deploy(Test, 5)
    // await deployer.deploy(NFT)
    await deployer.deploy(Token)
}
