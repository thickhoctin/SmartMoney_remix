// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;


contract Consumer {
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    function deposit() public payable {}
}
contract SmartContractWallet{
    address payable public owner;

    mapping (address => uint) public allowance;
    mapping (address => bool) public isAllowedToSend;
    mapping (address => bool) public guardians;
    address payable nextOwner;
    mapping (address => mapping(address => bool)) nextOwnerGuardianVotedBool;

    uint guardiansResetCount;
    uint public constant confirmationFromGuardiansForReset = 3;


    constructor(){
        owner = payable (msg.sender);

    }

    function setGuardian(address _guardian, bool _isGuardian) public {
        require(msg.sender == owner, "You're not the owner, aborting");
        guardians[_guardian] = _isGuardian;
    }
    function proposeNewOwner(address payable _newOwner) public {
        require(guardians[msg.sender], "You are not a guardian of this contract");
        require(nextOwnerGuardianVotedBool[_newOwner][msg.sender] ==  false, "You are already voted, aborting");
        if(_newOwner != nextOwner){
            nextOwner = _newOwner;
            guardiansResetCount = 0;
        }

        guardiansResetCount++;

        if(guardiansResetCount >= confirmationFromGuardiansForReset){
            owner = nextOwner;
            nextOwner = payable(address(0));
        }
    }


    function setAllowance(address _for , uint _amount) public{
        require(msg.sender == owner, "You're not the owner, aborting");
        allowance[_for] = _amount;

        if(_amount >0){
            isAllowedToSend[_for] = true;
        }else {
            isAllowedToSend[_for] = false;
        }

    }

    //trasfer funtion
    function transfer (address payable _to , uint _amount, bytes memory _payload)  public returns(bytes memory){
        //check if the sender is the owner
        require(msg.sender == owner,"You're not the owner, aborting");
        if(msg.sender != owner){
            require(allowance[msg.sender] >= _amount , "You are trying to send more than you allowed to, aborting");
            require(isAllowedToSend[msg.sender], "You are not allowed to send anything from this contract, aborting.");

            allowance[msg.sender] -= _amount;
        }
        (bool success, bytes memory returnData) = _to.call{value: _amount}(_payload);
        require(success, "Aborting, call was not successful");
        return returnData;
    }
    receive() external payable {

     }

}