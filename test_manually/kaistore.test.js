const {expect} = require('chai')
const {formatTrx, shasta, Sale, tokenApprove, nftApprove, UserInfo} = require('../utils')
const tronWeb = require('tronweb')
const {kaiStoreAddress, kaiAddress, tokenAddress, userInfoAddress} = require('../shasta_address.json')

describe('Kai Store', () => {
    before('init', async () => {
        this.Store = await shasta(process.env.PRIVATE_KEY_SHASTA_2).contract().at(kaiStoreAddress)
        this.UserInfo = await shasta(process.env.PRIVATE_KEY_SHASTA_2).contract().at(userInfoAddress)
        this.Token = await shasta(process.env.PRIVATE_KEY_SHASTA_2).contract().at(tokenAddress)
    })

    it('check price', async () => {
        const price = await this.Store.prices(13).call()
        console.log('price', formatTrx(price))
    })

    it.skip('buy', async () => {
        await tokenApprove({
            contract: this.Token,
            targetAddress: storeAddress,
            amount: tronWeb.toSun(20000)
        })

        const tx = await this.Store.buy(
            /*number to buy=*/1,
            /*uri=*/'https://kinganimals.com/nft/json/1.json',
            /*itemId=*/1
        ).send({
            feeLimit: tronWeb.toSun('200'),
            shouldPollResponse: false
        })

        await new Promise(r => setTimeout(r, 7000))

        const transactionInfo = await this.Store.tronWeb.trx.getTransaction(tx)
        // console.log(transactionInfo)
        if (transactionInfo.ret[0].contractRet !== 'SUCCESS') {
            console.log('transaction error')
        } else {
            console.log('transaction success')
        }
    }).timeout(20000)

    it('check nft', async () => {
        const nft = await this.UserInfo.getUserNft(this.UserInfo.tronWeb.defaultAddress.base58).call()
        console.log(UserInfo(nft))

        const item = await this.UserInfo.getUserItem(this.UserInfo.tronWeb.defaultAddress.base58).call()
        console.log(UserInfo(item))
    }).timeout(20000)
})
