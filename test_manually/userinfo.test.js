const {expect} = require('chai')
const {shasta, UserInfo} = require('../utils')
const tronWeb = require('tronweb')
const {userInfoAddress} = require('../shasta_address.json')

describe('User Info', () => {
    before('init', async () => {
        this.instance = await shasta().contract().at(userInfoAddress)
    })

    it('get user nft currently owned', async () => {
        // const nfts = await this.instance.getUserNft('TSEzvg3UW8KudD7ru5BkdTeBso8LZac2CG').call()
        const nfts = await this.instance.getUserNft('TD3T7xVMbZpc4HSKyiBF2m1eiwkucXXVxz').call()
        const info = UserInfo(nfts)
        console.log(info)
    }).timeout(20000)
})
