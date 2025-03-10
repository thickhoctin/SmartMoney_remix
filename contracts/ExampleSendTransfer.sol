// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Sender{
    receive() external payable { }

    function withDrawTransfer(address payable _to) public {
        _to.transfer(10);
    }

    function withDrawSend(address payable _to) public {
        bool isSent =_to.send(10);
        require(isSent, "Sending the funds was unsuccessful");
    }
}

contract ReceiverNoAction {
    function balance() public view returns (uint) {
        return address(this).balance;
    }
    receive() external payable { }
}

contract ReceiverAction {
    uint public balanceReceived;

    receive() external payable {
        balanceReceived += msg.value;
    }

    function balance() public view returns (uint) {
        return address(this).balance;
    }
}