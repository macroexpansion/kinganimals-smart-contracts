const Test = artifacts.require('./Test.sol')

module.exports = async deployer => {
    await deployer.deploy(Test, 5)
}
