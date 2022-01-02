const {shasta} = require('../utils')
const tronWeb = require('tronweb')
const {nftAddress} = require('../shasta_address.json')

const minterBytes32 = '0x' + require('keccak256')('MINTER_ROLE').toString('hex')

const setMinter = async () => {
    const NFT = await shasta().contract().at(nftAddress)

    const address = 'TCTTBC3B87hPwZ8uhm9kiLjAi5LZzq68p3'

    const set = await NFT.grantRole(
        minterBytes32,
        address
    ).send({
        feeLimit: tronWeb.toSun(20), // 20 TRX
        shouldPollResponse: false // wait for confirmation
    })
}

!(async () => {
    await setMinter()
})()
