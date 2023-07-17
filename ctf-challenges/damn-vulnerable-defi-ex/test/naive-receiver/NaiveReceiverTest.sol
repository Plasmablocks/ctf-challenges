pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../contracts/naive-receiver/NaiveReceiverLenderPool.sol";
import "../../contracts/naive-receiver/FlashLoanReceiver.sol";
import "../../contracts/naive-receiver/NaivereveiverAttack.sol";


contract NaiveReceiverTest is Test {

    NaiveReceiverLenderPool lendingPool;
    FlashLoanReceiver receiver;
    NaiveReceiverAttack attackContact;

    address internal attacker;

    uint256 immutable ETHER_IN_POOL = 1000 * 1 ether;
    uint256 immutable ETHER_IN_RECEIVER = 10 * 1 ether;

    function setUp() public {
        attacker = vm.addr(1);
        // Create contracts

        lendingPool = new NaiveReceiverLenderPool();
        vm.deal(address(lendingPool), ETHER_IN_POOL);

        receiver = new FlashLoanReceiver(address(lendingPool));
        vm.deal(address(receiver), ETHER_IN_RECEIVER);

        attackContact = new NaiveReceiverAttack();
    }

    function test_drain_user_funds() public {
        attackContact.attack(address(receiver), address(lendingPool));
        assertEq(address(receiver).balance, 0);
    }
}