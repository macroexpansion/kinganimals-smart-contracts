const {mainnet, parseTrxArray} = require('../utils')
const tronWeb = require('tronweb')
const {nftAddress, storeAddress} = require('../mainnet_address.json')

const minterBytes32 = '0x' + require('keccak256')('MINTER_ROLE').toString('hex')

const setMinter = async () => {
    const NFT = await mainnet().contract().at(nftAddress)

    const address = storeAddress

    const set = await NFT.grantRole(
        minterBytes32,
        address
    ).send({
        feeLimit: tronWeb.toSun(20), // 20 TRX
        shouldPollResponse: false // wait for confirmation
    })
}

const setItemQuantityInStore = async () => {
    const Store = await mainnet().contract().at(storeAddress)

    const itemIds = Array.from(Array(145).keys()).slice(1, 145)
    const quantities = Array(144).fill(20)

    const set = await Store.setQuantity(
        itemIds,
        quantities
    ).send({
        feeLimit: tronWeb.toSun(2000), // 20 TRX
        shouldPollResponse: false // wait for confirmation
    })
}

const setPriceInStore = async () => {
    const Store = await mainnet().contract().at(storeAddress)

    const prices1 = parseTrxArray([10, 15, 20, 30, 35, 40])
    const prices2 = parseTrxArray([20, 30, 40, 50, 60, 70])
    const prices3 = parseTrxArray([40, 60, 80, 100, 120, 140])
    const prices4 = parseTrxArray([80, 120, 160, 200, 240, 280])
    const prices5 = parseTrxArray([140, 180, 220, 300, 340, 400])
    const priceList = [prices1, prices2, prices3, prices4, prices5]
    const counts = [3, 3, 6, 6, 6]

    let prices = []
    for (let i = 0; i < priceList.length; i++) {
        for (let j = 0; j < counts[i]; j++) {
            prices = prices.concat(priceList[i])
        }
    }

    const itemIds = Array.from(Array(145).keys()).slice(1, 145)

    const set = await Store.setPrice(
        itemIds,
        prices
    ).send({
        feeLimit: tronWeb.toSun(10000), // 100 TRX
        shouldPollResponse: false // wait for confirmation
    })
}

const setNftInStore = async () => {
    const Store = await mainnet().contract().at(storeAddress)

    const set = await Store.setNFT(nftAddress).send({
        feeLimit: tronWeb.toSun(2000), // 100 TRX
        shouldPollResponse: false // wait for confirmation
    })
}

!(async () => {
    await setMinter()
    // await setItemQuantityInStore()
    // await setPriceInStore()
    // await setNftInStore()
})()
