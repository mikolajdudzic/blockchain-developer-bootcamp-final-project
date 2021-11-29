console.log("Welcome in the RopstenPad!")

var LaunchpadDealJS = require('LaunchpadDeal');
var jsonFile = "../build/contracts/LaunchpadDeal.json";
var parsed = JSON.parse(LaunchpadDealJS.readFileSync(jsonFile));
var abi = parsed.abi; 
const LaunchpadDeal = window.ethereum.eth.Contract(abi, );


window.addEventListener("load", function() {
	if (typeof window.ethereum !== "undefined") {

		console.log("MetaMask detected!")
		let mmDetected = document.getElementById("mm-detected")
		//mmDetected.innerHTML = "MetaMask has been detected"


	} else {
		console.log("Theres no Wallet available :(")
		alert("You need to install MetaMask Extension")
	}
})

const mmEnable = document.getElementById("mm-Connect");

mmEnable.onclick = async () => {
	await ethereum.request({ method: 'eth_requestAccounts'})
}
