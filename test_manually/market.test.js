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

        const sales = await this.Market.createSale(/*tokenId*/5, /*price*/tronWeb.toSun('50000')).send({
            feeLimit: tronWeb.toSun('200')
        })
    }).timeout(20000)

    it('get active sales', async () => {
        const page1 = await this.Market.getActiveSalesByPage(/*page*/0, /*num item per page*/2).call()
        console.log(Sale(page1))

        const page2 = await this.Market.getActiveSalesByPage(1, 2).call()
        console.log(Sale(page2))

        const page3 = await this.Market.getActiveSalesByPage(2, 2).call()
        console.log(Sale(page3))
    })

    it('get user created sales', async () => {
        const sales = await this.Market.getUserCreatedSales().call()
        console.log(Sale(sales))
    })

    it.skip('cancel sale', async () => {
        const sales = await this.Market.cancelSale(/*saleId*/1).send({
            feeLimit: tronWeb.toSun('100')
        })
    })

    it.skip('purchase sale', async () => {
        const market = await shasta().contract().at(marketAddress)
        const token = await shasta().contract().at(tokenAddress)

        await tokenApprove({
            contract: token,
            targetAddress: marketAddress,
            amount: tronWeb.toSun(20000)
        })

        const sales = await market.purchaseSale(/*saleid*/2).send({
            feeLimit: tronWeb.toSun('200')
        })
    })
})
