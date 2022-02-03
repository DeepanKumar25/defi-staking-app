const DecentralBank = artifacts.require('DecentralBank');

module.exports = async function issueRewards(callback){
    let decentralbank = await DecentralBank.deployed()
    await decentralbank.issueTokens()
    console.log('Tokens have been issued successfully');
    callback()
}
