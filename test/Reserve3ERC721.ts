import { expect } from "chai";
import { ethers } from "hardhat";


describe("Reserve3ERC721", async () => {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Reserve3 = await ethers.getContractFactory("Reserve3ERC721A");
    const reserve3 = await Reserve3.deploy();

    describe("Deployment", () => {
        it("Correct Contract Symbol", async () => {
            expect(await reserve3.symbol()).to.equal("R3N");
        });
    });
});