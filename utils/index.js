require('dotenv').config()
const TronWeb = require('tronweb')

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
