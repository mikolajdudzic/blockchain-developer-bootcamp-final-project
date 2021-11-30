const LaunchpadDeal = artifacts.require("LaunchpadDeal");
const { assert } = require('chai');
const truffleAssert = require('truffle-assertions');
const PToken = artifacts.require("PToken");

contract('test', function(accounts){
	
	it("Should return a formated value", function(){
		return LaunchpadDeal.deployed().then(async function(instance){
			await PToken.new();
			await instance.setParameters(100, 50, 5, PToken.address, 18);
			let expected = await instance.formatValue(200);
			return expected;
		}).then(function(expected){
			assert.equal(expected, 200000000000000000000, "Value is not like the expected one.");
		});
	});	


	it("Balance of checking account should be equal 200 or higher", function() {
		return LaunchpadDeal.deployed().then(async function(instance){
			await PToken.new();
			await instance.setParameters(100, 50, 5, PToken.address, 18);
			let balance = instance.getBalance.call(accounts[1]);
			return balance;
		}).then(function(balance){
			assert(balance >= 5*10**18, "Balance of pToken is not equal 200 or higher...");
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
				return true
			}
		});
	});

	it("Should check if pTokens were sent to 2 addresses", async () => {
		let PTokenInstance = await PToken.new();
		let result = await truffleAssert.createTransactionResult(PTokenInstance, PTokenInstance.transactionHash);
		truffleAssert.eventEmitted(result, "Transfer", (ev) => {
			return ev.from.toString() === "0x0000000000000000000000000000000000000000" &&
			ev.to === accounts[0];
		});
		truffleAssert.eventEmitted(result, "Transfer", (ev) => {
			return ev.from.toString() === "0x0000000000000000000000000000000000000000" && 
			ev.to === accounts[1];
		});
	});

	it("Should check if modifier UserCanPay works properly", async () => {
		return LaunchpadDeal.deployed().then(async function(instance) {
			await PToken.new();
			await instance.setParameters(100, 50, 5, PToken.address, 18);
			let result = await instance.getNum.call(50, {from: accounts[1]});
			return result;
		}).then(function(result) {
				assert.equal(result, 50, "?");
		});
	});
});