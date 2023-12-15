const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const FEE = ethers.constants.WeiPerEther.div(10);

describe("RussianRoullete", function () {

  async function deployOneYearLockFixture() {

    // Contracts are deployed using the first signer/account by default
    const accounts = await ethers.getSigners();

    const RussianRoulleteFactory = await ethers.getContractFactory("RussianRoullete");
    const RussianRoullete = await RussianRoullete.connect(accounts[10]).deploy()

    return { RussianRoullete, accounts };
  }

  describe("Play", function () {
    it("Should work perfectly", async function () {
      const { RussianRoullete, accounts } = await loadFixture(deployOneYearLockFixture);
      for (let player = 1; player <= 6; player++) {
        const acc = accounts[player - 1];

        RussianRoullete.connect(acc).enter({ value: FEE })
      }
    });

  });


});
