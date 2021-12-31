const {expect} = require('chai')
const {shasta, Sale, tokenApprove, nftApprove} = require('../utils')
const tronWeb = require('tronweb')
const {marketAddress, nftAddress, tokenAddress} = require('../shasta_address.json')

describe('Market', () => {
    before('init', async () => {
        this.Market = await shasta(process.env.PRIVATE_KEY_SHASTA_2).contract().at(marketAddress)
        this.NFT = await shasta(process.env.PRIVATE_KEY_SHASTA_2).contract().at(nftAddress)
    })

    it.skip('create sale', async () => {
        await nftApprove({
            contract: this.NFT,
            targetAddress: marketAddress
        })

        /* const sales = await this.Market.createSale(4, tronWeb.toSun('40000')).send({
            feeLimit: tronWeb.toSun('200')
        }) */
    }).timeout(20000)

    it('get active sales', async () => {
        const sales = await this.Market.getActiveSalesByPage(0, 10).call()
        console.log(Sale(sales))
    })

    // TODO: fix empty sale
    it.skip('get user created sales', async () => {
        const sales = await this.Market.getUserCreatedSales().call()
        console.log(Sale(sales))
    })

    it.skip('cancel sale', async () => {
        const sales = await this.Market.cancelSale(4).send({
            feeLimit: tronWeb.toSun('100')
        })
    })

    it.skip('purchase sale', async () => {
        const market = await shasta().contract().at(marketAddress)
        const token = await shasta().contract().at(tokenAddress)

        await tokenApprove({
            tokenContract: token,
            targetAddress: marketAddress,
            amount: tronWeb.toSun(20000)
        })

        const sales = await market.purchaseSale(2).send({
            feeLimit: tronWeb.toSun('200')
        })
    })
})
