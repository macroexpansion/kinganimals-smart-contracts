const {expect} = require('chai')
const {shasta, Sale, tokenApprove, nftApprove, UserInfo} = require('../utils')
const tronWeb = require('tronweb')
const {storeAddress, nftAddress, tokenAddress, userInfoAddress} = require('../shasta_address.json')

describe('Store', () => {
    before('init', async () => {
        this.Store = await shasta(process.env.PRIVATE_KEY_SHASTA_2).contract().at(storeAddress)
        this.UserInfo = await shasta(process.env.PRIVATE_KEY_SHASTA_2).contract().at(userInfoAddress)
        this.Token = await shasta(process.env.PRIVATE_KEY_SHASTA_2).contract().at(tokenAddress)
    })

    it.skip('buy', async () => {
        await tokenApprove({
            contract: this.Token,
            targetAddress: storeAddress,
            amount: tronWeb.toSun(20000)
        })

        const bought = await this.Store.buy(/*num*/2).send({
            feeLimit: tronWeb.toSun('200')
        })
    }).timeout(20000)

    it('check nft', async () => {
        const res = await this.UserInfo.getUserNft(this.UserInfo.tronWeb.defaultAddress.base58).call()
        console.log(UserInfo(res))
    })
})
