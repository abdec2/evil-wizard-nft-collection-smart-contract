const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("EvilWizards", function () {
  it("Testing EvilWizards baseURI function", async function () {
    const EWZ = await ethers.getContractFactory("EvilWizards");
    const ewz = await EWZ.deploy();
    await ewz.deployed();
    
    expect(await ewz.baseURI()).to.equal('https://gateway.pinata.cloud/ipfs/QmYQ45oJ8TVibA3esZbr2AxKBEGf2dwGmHQcwuGsupfhZW');
  });
  it("Testing EvilWizards maxSupply function", async function () {
    const EWZ = await ethers.getContractFactory("EvilWizards");
    const ewz = await EWZ.deploy();
    await ewz.deployed();
    
    expect(await ewz._maxSupply()).to.equal(400);
  });
  it("Testing EvilWizards getNFTPrice function", async function () {
    const EWZ = await ethers.getContractFactory("EvilWizards");
    const ewz = await EWZ.deploy();
    await ewz.deployed();
    const cost = await ewz.getNFTPrice();
    expect(cost.toString()).to.equal("100000000000000000");
  });

});
