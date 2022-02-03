const { assert } = require('chai');

const Tether = artifacts.require('Tether');
const RWD = artifacts.require('RWD');
const DecentralBank = artifacts.require('DecentralBank');

require('chai')
.use(require('chai-as-promised'))
.should()

contract('DecentralBank', ([owner , customer]) => {
        let tether,rwd,decentralBank

        function tokens(number) {
            return web3.utils.toWei(number , 'ether')
            
        }

        before( async () => {
                tether = await Tether.new();
                rwd = await RWD.new();
                decentralBank = await DecentralBank.new(rwd.address , tether.address);

                await rwd.transfer(decentralBank.address , tokens('1000000'))
                await tether.transfer(customer ,tokens('100') , {from : owner})
            })


    
    describe('Mock Tether Deployment', async() => {
        it('matches name successfully',async() =>{
            const name = await tether.name()
            assert.equal(name ,'Mock Tether Token')
        })
    })


    describe('Reward Token Deployment', async() => {
        it('matches name successfully',async() =>{
            const name = await rwd.name()
            assert.equal(name ,'Reward Token')
        })
    })


    describe('Decentral Bank Deployment', async() => {
        it('matches name successfully',async() =>{
            const name = await decentralBank.name()
            assert.equal(name ,'Decentral Bank')
        })
        it('contract has tokens', async() => {
            let balance = await rwd.balanceof(decentralBank.address)
            assert.equal(balance , tokens('1000000'))
        })
    describe('Yield farming', async() =>{
        it('rewards tokens for staking', async () => {
                let result;
                result = await tether.balanceof(customer);
                assert.equal(result.toString(), tokens('100'), 'customer mock balance before staking');

                await tether.approve(decentralBank.address, tokens('100'), { from: customer });
                await decentralBank.depositTokens(tokens('100'), { from: customer });

                result = await tether.balanceof(customer);
                assert.equal(result.toString(), tokens('0'), 'customer mock balance after staking');

                result = await tether.balanceof(decentralBank.address);
                assert.equal(result.toString(), tokens('100'), 'decentralBank mock balance after staking');

                result = await decentralBank.isStaking(customer);
                assert.equal(result.toString(), 'true', 'customer is staking')

                await decentralBank.issueTokens({from : owner})
                await decentralBank.issueTokens({from : customer}).should.be.rejected

                await decentralBank.unstakeTokens({from : customer})

                result = await tether.balanceof(customer);
                assert.equal(result.toString(), tokens('100'), 'customer mock balance after unstaking');

                result = await tether.balanceof(decentralBank.address);
                assert.equal(result.toString(), tokens('0'), 'decentralBank mock balance after unstaking');

                result = await decentralBank.isStaking(customer);
                assert.equal(result.toString(), 'false', 'customer is not staking')

            })
    })
   
   
    })
})

