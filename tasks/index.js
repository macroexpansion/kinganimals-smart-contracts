const {shasta} = require('../utils')
const tronWeb = require('tronweb')
const {nftAddress, storeAddress} = require('../shasta_address.json')

const minterBytes32 = '0x' + require('keccak256')('MINTER_ROLE').toString('hex')

const setMinter = async () => {
    const NFT = await shasta().contract().at(nftAddress)

    const address = 'TF1CmZgBU1yG7q1Gk6hbk7WFeomLCWE9Un'

    const set = await NFT.grantRole(
        minterBytes32,
        address
    ).send({
        feeLimit: tronWeb.toSun(20), // 20 TRX
        shouldPollResponse: false // wait for confirmation
    })
}

const setItemQuantityInStore = async () => {
    const Store = await shasta().contract().at(storeAddress)

    const itemIds = [10, 11]
    const quantities = [2, 2]

    const set = await Store.setQuantity(
        itemIds,
        quantities
    ).send({
        feeLimit: tronWeb.toSun(2000), // 20 TRX
        shouldPollResponse: false // wait for confirmation
    })
}

!(async () => {
    // await setMinter()
    // await setItemQuantityInStore()
})()
