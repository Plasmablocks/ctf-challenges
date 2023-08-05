// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../contracts/DamnValuableToken.sol";
import "../../contracts/the-rewarder/FlashLoanerPool.sol";
import "../../contracts/the-rewarder/TheRewarderPool.sol";
import "../../contracts/the-rewarder/RewardPoolExploiter.sol";
import {RewardToken} from "../../contracts/the-rewarder/RewardToken.sol";
import {AccountingToken} from "../../contracts/the-rewarder/AccountingToken.sol";


contract RewardPoolTest is Test {

    DamnValuableToken dvt;
    TheRewarderPool rewarderPool;
    FlashLoanerPool flashLoaner;
    RewardPoolExploiter attackerContract;

    address userOne;
    address userTwo;

    uint256 immutable ETHER_IN_POOL = 1000000 * 1 ether;
    uint256 immutable INITIAL_ETH_DEPOSITS = 100 * 1 ether;

    uint256 initialRewardSupply;

    function setUp() public {
        userOne = vm.addr(1);
        userTwo = vm.addr(2);

        dvt = new DamnValuableToken();
        flashLoaner = new FlashLoanerPool(address(dvt));

        // Add initial funds to flash loan pool
        dvt.transfer(address(flashLoaner), ETHER_IN_POOL);

        rewarderPool = new TheRewarderPool(address(dvt));

        // Give users initial balance
        dvt.transfer(address(userOne), INITIAL_ETH_DEPOSITS);
        dvt.transfer(address(userTwo), INITIAL_ETH_DEPOSITS);

        vm.startPrank(userOne);
        dvt.approve(address(rewarderPool), INITIAL_ETH_DEPOSITS);
        rewarderPool.deposit(INITIAL_ETH_DEPOSITS);
        vm.stopPrank();

        vm.startPrank(userTwo);
        dvt.approve(address(rewarderPool), INITIAL_ETH_DEPOSITS);
        rewarderPool.deposit(INITIAL_ETH_DEPOSITS);
        vm.stopPrank();

        // Initiate attack contract
        attackerContract = new RewardPoolExploiter(address(rewarderPool),address(flashLoaner), address(dvt));
        vm.deal(address(attackerContract), 0.1 ether); // Gasssss

        vm.warp(block.timestamp + 5 days);
    }

    function test_reward_drain() public {

        initialRewardSupply = rewarderPool.rewardToken().totalSupply();
        attackerContract.attack(10000 ether);

        vm.warp(block.timestamp + 5 days);
        
        uint256 rewardPoolSupply = rewarderPool.rewardToken().totalSupply();
        uint256 attackContractRewardSupply = rewarderPool.rewardToken().balanceOf(address(attackerContract));

        assertEq(attackContractRewardSupply, rewardPoolSupply);
        assertGt(rewardPoolSupply, initialRewardSupply);
    }
}