const {expect} = require('chai')
const {shasta, formatTrx} = require('../utils')
const tronWeb = require('tronweb')
const {tokenAddress} = require('../shasta_address.json')

describe('Token', () => {
    before('init', async () => {
        this.instance = await shasta().contract().at(tokenAddress)
    })

    it.skip('mint token', async () => {
        const res = await this.instance.mint(
            'TK5oiWAK4wcuhjFJPxZDKeNHT9iPh3gsHA',
            tronWeb.toSun('100000000')
        ).send({
            feeLimit: tronWeb.toSun('50'),
            shouldPollResponse: false
        })
    })

    it('should return balance', async () => {
        const balance = await this.instance.balanceOf('TK5oiWAK4wcuhjFJPxZDKeNHT9iPh3gsHA').call()
        console.log('balance:', formatTrx(balance))
    })
})
