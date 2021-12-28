const {expect} = require('chai')
const {shasta} = require('../utils')
const tronWeb = require('tronweb')

describe('Test', () => {
    before('init', async () => {
        this.instance = await shasta().contract().at('TBNao4gymP5ot2Z3Hcn2LR4MBMqoapJPU2')
    })

    it('should change and return value', async () => {
        const newValue = 10
        const set = await this.instance.setNum(newValue).send({
            feeLimit: tronWeb.toSun(10), // 10 TRX
            shouldPollResponse: false // wait for confirmation
        })
        console.log(set)

        const res = await this.instance.num().call()
        expect(res.toNumber()).to.equal(newValue)
    }).timeout(20000)
})
