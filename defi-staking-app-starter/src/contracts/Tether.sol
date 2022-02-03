pragma solidity ^0.8.4; 

contract Tether{
    string public name = 'Mock Tether Token';
    string public symbol = 'USDT';
    uint public total_supply = 1000000000000000000000000;
    uint public decimals = 18;

event Transfer(
    address indexed _from,
    address indexed _to,
    uint _value
);
event Approval(
    address indexed _owner,
    address indexed _spender,
    uint _value
);

mapping(address => uint)public balanceof;
mapping(address => mapping(address => uint))public allowance ;

constructor(){
    balanceof[msg.sender] = total_supply;
}

function transfer(address _to , uint _value)public returns (bool success){
    require(balanceof[msg.sender]>= _value);
    balanceof[msg.sender] -= _value;
    balanceof[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
    return true;
}
function approve(address _spender,uint _value)public returns (bool success){
    allowance[msg.sender][_spender] = _value ;
    emit Approval(msg.sender, _spender, _value);
    return true;
}

function transferfrom(address _from,address _to,uint _value)public returns(bool success){
    require(_value<= balanceof[_from]);
    require(_value<=allowance[_from][msg.sender]);
    balanceof[_from] -= _value;
    balanceof[_to] += _value;
    allowance[_from][msg.sender] -= _value;
    emit Transfer(_from, _to, _value);
    return true;

}

}