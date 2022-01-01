require('dotenv').config()

const keccak256 = require('keccak256')
const TronWeb = require('tronweb')

const minterBytes32 = '0x' + keccak256('MINTER_ROLE').toString('hex')

exports.shasta = (privateKey) => {
    return new TronWeb({
        fullHost: 'https://api.shasta.trongrid.io',
        privateKey: privateKey ? privateKey : process.env.PRIVATE_KEY_SHASTA
    })
}

exports.mainnet = (privateKey) => {
    return new TronWeb({
        fullHost: 'https://api.trongrid.io',
        privateKey: privateKey ? privateKey : process.env.PRIVATE_KEY_SHASTA
    })
}

exports.setMinter = async ({contract, address}) => {
    const set = await contract.grantRole(
        minterBytes32,
        address
    ).send({
        feeLimit: TronWeb.toSun(20), // 20 TRX
        shouldPollResponse: false // wait for confirmation
    })
}

exports.isMinter = async ({contract, address}) => {
    const isMinter = await contract.hasRole(
        minterBytes32,
        address
    ).call()
    return isMinter
}

exports.formatTrx = (value) => {
    return TronWeb.fromSun(value).toNumber()
}

exports.UserInfo = (items) => {
    if (items.length == 0) return []

    const tokenIds = items[0]
    const itemIds = items[1]
    const uris = items[2]

    const userInfos = []
    for (let i = 0; i < tokenIds.length; i++) {
        userInfos.push({
            tokenId: tokenIds[i],
            itemId: itemIds[i],
            uri: uris[i]
        })
    }

    return userInfos
}

exports.Sale = (items) => {
    const sales = []

    for (let i = 0; i < items.saleIds.length; i++) {
        sales.push({
            saleId: items.saleIds[i].toNumber(),
            tokenId: items.tokenIds[i].toNumber(),
            seller: TronWeb.address.fromHex(items.sellers[i]),
            price: TronWeb.fromSun(items.prices[i]).toNumber(),
            lastUpdated: items.lastUpdateds[i].toNumber(),
        })
    }

    return sales
}

exports.tokenApprove = async ({contract, targetAddress, amount}) => {
    /* const maxNumber = '115792089237316195423570985008687907853269984665640564039457584007913129639935'
    const unlimitedAllowance = TronWeb.toBigNumber(maxNumber).toNumber() */

    /* const signerAddress = tokenContract.tronWeb.defaultAddress.base58
    const allowance = await tokenContract.allowance(signerAddress, targetAddress).call()
    if (allowance > ) */

    const approve = await contract.approve(targetAddress, amount).send({
        feeLimit: TronWeb.toSun('100')
    })

    await new Promise(r => setTimeout(r, 2000))
}

exports.nftApprove = async ({contract, targetAddress}) => {
    const signerAddress = contract.tronWeb.defaultAddress.base58
    const isApprovedForAll = await contract.isApprovedForAll(signerAddress, targetAddress).call()

    if (!isApprovedForAll) {
        const approve = await contract.setApprovalForAll(targetAddress, true).send({
            feeLimit: TronWeb.toSun('100'),
            shouldPollResponse: false
        })
    }

    await new Promise(r => setTimeout(r, 2000))
}
