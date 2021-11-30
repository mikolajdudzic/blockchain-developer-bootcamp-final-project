const LaunchpadDeal = artifacts.require("LaunchpadDeal");
const { assert } = require('chai');
const truffleAssert = require('truffle-assertions');
const PToken = artifacts.require("PToken");
const DudzicToken = artifacts.require("DudzicToken");

contract('test', function(accounts){

	it("Balance of checking account should be greater than 0", function() {
		return DudzicToken.deployed().then(async function(instance) {
			let amount = 100000000000;
			let DudzicTokenInstance = await DudzicToken.new();
			let result = await truffleAssert.createTransactionResult(DudzicTokenInstance, DudzicTokenInstance.transactionHash);
			truffleAssert.eventEmitted(result, "Transfer", (ev) => {
				return ev.from.toString() === "0x0000000000000000000000000000000000000000" && ev.value.toNumber() === amount;
			});
		});
	});


	it("Should emit the Approval event", function() {
		return PToken.deployed().then(async function(instance) {
			let amount = 100000000000;
			let tx = await instance.approve(LaunchpadDeal.address, amount, { from: accounts[1] });
			truffleAssert.eventEmitted(tx, "Approval", (ev) => {
				return ev.spender === LaunchpadDeal.address && ev.value.toNumber() === amount;
			});
		});
	});
	
	it("Should catch an error and return true", function() {
		return LaunchpadDeal.deployed().then(async function(instance) {
			try {
				await instance.claimDealToken( {from: accounts[1] });
			} catch {
				return true;
			}
		});
	});

	it("Should check if pTokens were sent to the first Ganache accout address", async () => {
		let PTokenInstance = await PToken.new();
		let result = await truffleAssert.createTransactionResult(PTokenInstance, PTokenInstance.transactionHash);
		truffleAssert.eventEmitted(result, "Transfer", (ev) => {
			return ev.from.toString() === "0x0000000000000000000000000000000000000000" &&
			ev.to === accounts[0];
		});
	});

	it("Should return true", async () => {
		return LaunchpadDeal.deployed().then(async function(instance) {
			await DudzicToken.new();
			await PToken.new();
			let result = await instance.setParameters.call(100000000000, 20000000, 10000000, PToken.address, DudzicToken.address, {from: accounts[0]});
			return result;
		}).then(function(result) {
				assert.equal(result, true, "?");
		});
	});
});