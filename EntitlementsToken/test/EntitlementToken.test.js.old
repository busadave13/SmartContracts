const { expect } = require("chai");

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

describe("EntitlementToken contract", function () {
  
  let Token;
  let hardhatToken;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  // `beforeEach` will run before each test, re-deploying the contract every
  // time. It receives a callback, which can be async.
  beforeEach(async function () {
    Token = await ethers.getContractFactory("EntitlementToken");
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
    it("Test grant", async function() {      
      let tokenId = -1;
  
      await expect(hardhatToken.grant(addr1.address))
        .to.emit(hardhatToken, "GrantEntitlement")
        .withArgs(addr1.address, 0);
      
  
      //let balance = await hardhatToken.balanceOf(addr1.address);
      //expect(balance).to.equal(1);

      //let isActive = await hardhatToken.isLicenseActive.call(addr1.address, tokenId);
      //expect(isActive).to.equal(1);

  
      // await token.activate(tokenId, "UDID");
      // isActive = await hardhatToken.isLicenseActive.call(addr1, tokenId);
      // // 0 - LicenseType.ACTIVE
      // assert.equal(isActive, 0, "License is active.");
    });
  });

  //   it("Should fail if sender doesn’t have enough tokens", async function () {
  //     const initialOwnerBalance = await hardhatToken.balanceOf(owner.address);

  //     // Try to send 1 token from addr1 (0 tokens) to owner (1000000 tokens).
  //     // `require` will evaluate false and revert the transaction.
  //     await expect(
  //       hardhatToken.connect(addr1).transfer(owner.address, 1)
  //     ).to.be.revertedWith("Not enough tokens");

  //     // Owner balance shouldn't have changed.
  //     expect(await hardhatToken.balanceOf(owner.address)).to.equal(
  //       initialOwnerBalance
  //     );
  //   });

  //   it("Should update balances after transfers", async function () {
  //     const initialOwnerBalance = await hardhatToken.balanceOf(owner.address);

  //     // Transfer 100 tokens from owner to addr1.
  //     await hardhatToken.transfer(addr1.address, 100);

  //     // Transfer another 50 tokens from owner to addr2.
  //     await hardhatToken.transfer(addr2.address, 50);

  //     // Check balances.
  //     const finalOwnerBalance = await hardhatToken.balanceOf(owner.address);
  //     expect(finalOwnerBalance).to.equal(initialOwnerBalance.sub(150));

  //     const addr1Balance = await hardhatToken.balanceOf(addr1.address);
  //     expect(addr1Balance).to.equal(100);

  //     const addr2Balance = await hardhatToken.balanceOf(addr2.address);
  //     expect(addr2Balance).to.equal(50);
  //   });
  // });
});