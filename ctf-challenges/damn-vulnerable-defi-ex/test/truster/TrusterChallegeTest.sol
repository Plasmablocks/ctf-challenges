// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../contracts/DamnValuableToken.sol";
import "../../contracts/truster/TrusterLenderPoolAttacker.sol";
import "../../contracts/truster/TrusterLenderPool.sol";

contract TrusterLenderPoolTest is Test {

    TrusterLenderPoolAttacker private attackContract;
    DamnValuableToken private token;
    TrusterLenderPool private lendingPool;

    address internal attacker;
    uint256 immutable ETHER_IN_POOL = 1000000 * 1 ether;

    function setUp() public {
        attacker = vm.addr(1);

        // Setup system
        token = new DamnValuableToken();
        lendingPool = new TrusterLenderPool(token);
        token.transfer(address(lendingPool), ETHER_IN_POOL);

        attackContract = new TrusterLenderPoolAttacker(token, address(lendingPool));

        // Give pool 1 million DVT
    }

    function test_drain_truster_pool() public {

        // Before
        uint poolBalanceBeforeAttack = token.balanceOf(address(lendingPool));
        assertEq(poolBalanceBeforeAttack, ETHER_IN_POOL);

        attackContract.attack();
        uint poolBalanceAfterAttack = token.balanceOf(address(lendingPool));
        uint attackContractBalance = token.balanceOf(address(attackContract));

        assertEq(poolBalanceAfterAttack, 0);
        assertEq(attackContractBalance, ETHER_IN_POOL);
    }
}