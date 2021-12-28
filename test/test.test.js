const Test = artifacts.require('./Test.sol')

contract('Test', () => {
    it.skip('num should be 5', () => {
        let contract

        return Test.deployed()
            .then(instance => {
                contract = instance
                return contract.num()
            })
            .then(num => {
                assert.equal(
                    num.toNumber(),
                    5,
                    "num is not equal to 5"
                )
            })
    })
})
