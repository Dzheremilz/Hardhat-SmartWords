const { expect } = require('chai');

describe('SmartWords', function () {
  let dev, alice, bob, SmartWords, smartwords, tx, test;

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
  describe('Quote', function () {
    beforeEach(async function () {
      tx = smartwords
        .connect(alice)
        .quote(
          '0xde3028a2aa0c10b40befce8f7ae48be598081fc931d1addc8c129995137ba1bc',
          'je sui a laeropor bisouuuu je manvol',
          'https://twitter.com/'
        );
    });
    it('Should create a token', async function () {
      await expect(() => tx).to.changeTokenBalance(smartwords, alice, 1);
    });
    it('Should emit an event', async function () {
      await ethers.provider.send('evm_setNextBlockTimestamp', [2624990000]);
      // await ethers.provider.send('evm_mine');
      await expect(tx)
        .to.emit(smartwords, 'Quoted')
        .withArgs(alice.address, '0xde3028a2aa0c10b40befce8f7ae48be598081fc931d1addc8c129995137ba1bc', 1, 2624990000);
    });
    describe('Quote test', function () {
      beforeEach(async function () {
        await tx;
        test = await smartwords.getQuoteById(1);
      });

      it('author', async function () {
        await expect(test.author).to.be.equal(alice.address);
      });
      it('hashedQuote', async function () {
        await expect(test.hashedQuote).to.be.equal(ethers.utils.id('je sui a laeropor bisouuuu je manvol'));
      });
      it('Quote', async function () {
        await expect(test.quote).to.be.equal('je sui a laeropor bisouuuu je manvol');
      });
    });
  });
});
