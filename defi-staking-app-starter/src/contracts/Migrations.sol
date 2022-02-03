pragma solidity ^0.8.4;

contract Migrations {
    address public owner;
    uint public last_completed_migrations;

constructor() {
     owner = msg.sender;
}
modifier restricted (){
    require(msg.sender == owner);
_ ;
}
function setCompleted(uint completed)public restricted{
    last_completed_migrations = completed;
}
function upgrade(address new_address)public restricted{
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migrations);
}

}