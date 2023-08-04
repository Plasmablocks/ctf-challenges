// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../contracts/side-entrance/SideEntranceExploit.sol";
import "../../contracts/side-entrance/SideEntranceLenderPool.sol";

contract SideEntranceTest is Test {
    SideEntranceExploiter attackContract;
    SideEntranceLenderPool lendingPool;

    uint256 immutable ETHER_IN_POOL = 1000 * 1 ether;
    uint256 immutable ETHER_IN_RECEIVER = 1 * 1 ether;

    function setUp() public { 

        lendingPool = new SideEntranceLenderPool();
        vm.deal(address(lendingPool), ETHER_IN_POOL);

        attackContract = new SideEntranceExploiter(address(lendingPool));
        vm.deal(address(attackContract), ETHER_IN_RECEIVER);
    }

    function test_drain_side_entrance() public {
        attackContract.attack(ETHER_IN_POOL);
        assertEq(address(lendingPool).balance, 0);
    }
}