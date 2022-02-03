pragma solidity ^0.8.4;

import './RWD.sol';
import './Tether.sol';

contract DecentralBank {
    address public owner;
    string public name = 'Decentral Bank';
    Tether public tether;
    RWD public rwd;

address[] public stakers;

mapping (address => uint) public stakingBalance ;
mapping (address => bool) public hasStaked;
mapping (address => bool) public isStaking;


    constructor(RWD _rwd,Tether _tether) {
    rwd = _rwd;
    tether = _tether;
    owner = msg.sender;

} 
function depositTokens(uint _amount) public {
    require(_amount >0, 'amount must be greater than 0');
    tether.transferfrom(msg.sender, address(this), _amount);
    stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

if(!hasStaked[msg.sender]){
    stakers.push(msg.sender);
}

isStaking[msg.sender] = true;
hasStaked[msg.sender] = true;
}
function issueTokens() public{
    require ( msg.sender == owner, 'only the owner can call');

    for(uint i=0;i<stakers.length;i++){
        address recipient = stakers[i];
        uint balance = stakingBalance[recipient] / 9 ;
        if (balance>0) {
            rwd.transfer(recipient,balance);
        }


    }


}
function unstakeTokens() public{
    uint balance = stakingBalance[msg.sender];
    require(balance >0 , 'it must be greater than 0');
    tether.transfer(msg.sender,balance);
    stakingBalance[msg.sender] = 0;
    isStaking[msg.sender] = false;
}

}