const { expect } = require("chai");

describe("EntitlementTokenV1 contract", function () {
  
  let Token;
  let hardhatToken;
  let owner;
  let addr0;
  let addr1;
  let addr2;
  let addrs;

  // `beforeEach` will run before each test, re-deploying the contract every
  // time. It receives a callback, which can be async.
  beforeEach(async function () {

    Token = await ethers.getContractFactory("EntitlementTokenV1");
    addr0 = ethers.constants.AddressZero;
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();   

    hardhatToken = await Token.deploy();
  });

  describe("Deployment", function () {
    it("Should assign the total supply of tokens to the owner", async function () {    

      console.log("owner", owner.address);
      console.log("addr1", addr1.address);
      console.log("addr2", addr2.address);

      const ownerBalance = await hardhatToken.balanceOf(owner.address);
      expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
    });
  });

  describe("Transactions", function () {
    it("Can grant entitlement", async function() {     

      await expect(hardhatToken.grant(addr1.address, "12345"))
        .to.emit(hardhatToken, "Transfer")
        .withArgs(addr0, addr1.address, 0);    

      let balance = await hardhatToken.balanceOf(addr1.address);
      expect(balance).to.equal(1);

      //let ownerOf = await hardhatToken.ownerOf(0);
      //expect(ownerOf.address).to.equal(addr1.address);
    });

    it("Can revoke entitlement", async function() {     

      await expect(hardhatToken.grant(addr1.address, "12345"))
        .to.emit(hardhatToken, "Transfer")
        .withArgs(addr0, addr1.address, 0);    

      await hardhatToken.revoke(addr1.address, tokenId);

      let balance = await hardhatToken.balanceOf(addr1.address);
      expect(balance).to.equal(1);

      //let ownerOf = await hardhatToken.ownerOf(0);
      //expect(ownerOf.address).to.equal(addr1.address);
    });
  });
});