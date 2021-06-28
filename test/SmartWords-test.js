const { expect } = require('chai');

describe('SmartWords', function () {
  let dev, alice, bob, SmartWords, smartwords;

  beforeEach(async function () {
    [dev, alice, bob] = await ethers.getSigners();
    SmartWords = await ethers.getContractFactory('SmartWords');
    smartwords = await SmartWords.connect(dev).deploy();

    await smartwords.deployed();
  });
  describe('deploy', function () {
    it('Should have name SmartWords', async function () {
      expect(await smartwords.name()).to.be.equal('SmartWords');
    });
  });
});
