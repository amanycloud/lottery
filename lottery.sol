// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{

address public manager;
address payable[] public participants;

constructor() {
manager=msg.sender; //deployers address
}


function noOfParticipants() public view returns(uint)
{
    return participants.length;
}

modifier onlyManager()
{require(msg.sender==manager,"Manager only access property");
_;
}

function getBalance() public view onlyManager returns(uint){
return address(this).balance;
}

receive() external payable{
    require(msg.value == 1 ether,"send 1 ether exactly");
    participants.push(payable(msg.sender));
}

function random() public view returns(uint){
    return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
}

function selectWinner() public onlyManager{
require(participants.length>=3,"minimum participants is 3");
uint r=random();
address payable winner;
uint index=r%participants.length;
winner=participants[index];
winner.transfer(getBalance());

while(participants.length!=0)
{
    participants.pop();
}

}


}