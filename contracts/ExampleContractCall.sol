// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ContractOne{

    mapping (address =>uint) public addressBalances;

    function deposit()public payable {
        addressBalances[msg.sender] += msg.value; 
    }
    
    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    receive() external payable { 
        deposit();
    }
}

contract ContractTwo {
    receive() external payable { }
    function depositOnContractOne(address _contractOne)public{
        //ContractOne one = ContractOne(_contractOne);
        //Encoded Signature

        //bytes memory payload = abi.encodeWithSignature("deposit()");
       (bool success , ) = _contractOne.call{value: 10, gas: 100000}("");
       require(success);
    }
}