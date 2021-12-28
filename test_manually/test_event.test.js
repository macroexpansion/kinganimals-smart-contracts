const {expect} = require('chai')
const {shasta} = require('../utils')

describe('Test Event', () => {
    before('init', async () => {
        this.instance = await shasta().contract().at('TBNao4gymP5ot2Z3Hcn2LR4MBMqoapJPU2')
    })

    it('watching event', async () => {
        this.instance.NumChanged().watch((err, event) => {
            if (err) {
                return console.error('Error with "method" event:', err)
            }

            if (event) { 
                console.log('event:', event)
            }
        })
    }).timeout(120000)
})
