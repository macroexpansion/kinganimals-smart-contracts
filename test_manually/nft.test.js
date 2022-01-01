const {expect} = require('chai')
const {shasta, setMinter, isMinter} = require('../utils')
const tronWeb = require('tronweb')
const {nftAddress} = require('../shasta_address.json')

describe('NFT', () => {
    before('init', async () => {
        this.instance = await shasta().contract().at(nftAddress)
    })

    it.skip('get tokenId counter', async () => {
        const res = await this.instance._tokenIdCounter().call()
        console.log('token counter:', res._value.toNumber())
    })

    it.skip('mint a nft', async () => {
        const res = await this.instance.mint(
            'TK5oiWAK4wcuhjFJPxZDKeNHT9iPh3gsHA',
            'https://static.howlcity.io/bike/10.json',
            10
        ).send({
            feeLimit: tronWeb.toSun(100), // 100 TRX
            shouldPollResponse: false // wait for confirmation
        })
    })

    it('get nft info', async () => {
        const balance = await this.instance.balanceOf('TK5oiWAK4wcuhjFJPxZDKeNHT9iPh3gsHA').call()
        console.log('balance:', balance.toNumber())

        for (let i = 1; i <= 2; i++) {
            const info = await this.instance.getNftInfo(/*tokenId*/i).call()
            console.log('itemId', info.toNumber())
        }

        /* const item = await this.instance.itemById(1).call()
        console.log('item by id:', item) */
    })

    it.skip('set minter', async () => {
        await setMinter({
            contract: this.instance,
            address: 'TK5oiWAK4wcuhjFJPxZDKeNHT9iPh3gsHA'
        })
    })

    it('check minter', async () => {
        const minter = await isMinter({
            contract: this.instance,
            address: 'TK5oiWAK4wcuhjFJPxZDKeNHT9iPh3gsHA'
        })
        console.log({minter})
    })
})
