require('dotenv').config()

const keccak256 = require('keccak256')
const TronWeb = require('tronweb')

const minterBytes32 = '0x' + keccak256('MINTER_ROLE').toString('hex')

exports.shasta = () => {
    return new TronWeb({
        fullHost: 'https://api.shasta.trongrid.io',
        privateKey: process.env.PRIVATE_KEY_SHASTA
    })
}

exports.mainnet = () => {
    return new TronWeb({
        fullHost: 'https://api.trongrid.io',
        privateKey: process.env.PRIVATE_KEY_SHASTA
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
