require('dotenv').config()

const keccak256 = require('keccak256')
const TronWeb = require('tronweb')

const minterBytes32 = '0x' + keccak256('MINTER_ROLE').toString('hex')

exports.shasta = () => {
    const fullNode = 'https://api.shasta.trongrid.io'
    const solidityNode = 'https://api.shasta.trongrid.io'
    const eventServer = 'https://api.shasta.trongrid.io'
    const privateKey = process.env.PRIVATE_KEY_SHASTA
    return new TronWeb(fullNode, solidityNode, eventServer, privateKey)
}

exports.mainnet = () => {
    const fullNode = 'https://api.trongrid.io'
    const solidityNode = 'https://apitrongrid.io'
    const eventServer = 'https://api.trongrid.io'
    const privateKey = process.env.PRIVATE_KEY_SHASTA
    return new TronWeb(fullNode, solidityNode, eventServer, privateKey)
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
