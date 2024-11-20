//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployMyToken} from "../script/DeployMyToken.s.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken public myToken;
    DeployMyToken public deployer;

    address Bob = makeAddr("bob");
    address Alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployMyToken();
        myToken = deployer.run();

        vm.prank(msg.sender);
        myToken.transfer(Bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(myToken.balanceOf(Bob), STARTING_BALANCE);
    }

    function testTransfer() public{
        uint256 amount = 100 * 10 ** 18; //_example amount
        vm.prank(msg.sender);
        myToken.transfer(Bob,amount);

        assertNotEq(myToken.balanceOf(Bob), amount);
        assertNotEq(myToken.balanceOf(msg.sender), deployer.INITIAL_SUPPLY()- amount);

    }

    function testTransferFrom() public {
        uint256 amount = 500 * 10 ** 18;
        vm.prank(msg.sender);
        myToken.approve(Bob, amount);

        vm.prank(Bob);
        myToken.transferFrom(msg.sender, Alice, amount);

        assertEq(myToken.balanceOf(Alice), amount);
        assertEq(myToken.allowance(msg.sender, Bob), 0);
    }

    function testFailTransferExceedsBalance() public {
        uint256 amount = deployer.INITIAL_SUPPLY() + 1;
        vm.prank(msg.sender);
        myToken.transfer(Bob, amount);
    }

    function testFailApproveExceedsBalance() public {
        uint256 amount = deployer.INITIAL_SUPPLY() + 1;
        vm.expectRevert();
        vm.prank(msg.sender);
        myToken.approve(Bob, amount);
    }
}
