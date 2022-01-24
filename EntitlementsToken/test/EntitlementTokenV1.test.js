const { expect } = require("chai");

describe("Entitlements contract", function () {
  
  let contract;
  let instance;

  // `beforeEach` will run before each test, re-deploying the contract every
  // time. It receives a callback, which can be async.
  beforeEach(async function () {

    contract = await ethers.getContractFactory("Entitlements");
    instance = await contract.deploy();
  });

  describe("Transactions", function () {

    it("Can grant entitlement", async function() {     

      await instance.grant("1", "12345");
      expect(await instance.state("1", "12345")).to.equal(0);
    });

    it("Can revoke entitlement", async function() {     

      await instance.revoke("1", "12345");
      expect(await instance.state("1", "12345")).to.equal(1);
    });

  });
});
