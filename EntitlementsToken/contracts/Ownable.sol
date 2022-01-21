// SPDX-License-Identifier: MIT
contract Ownable {
  address owner;
   
  constructor() {
    owner = msg.sender;
  }
   
  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }
   
  function transferOwnership(address newOwner) onlyOwner  public {
    owner = newOwner;
  }
}