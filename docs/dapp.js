console.log("Welcome in the RopstenPad!")

let truncate = function (fullStr, strLen, separator) {
    if (fullStr.length <= strLen) return fullStr;

    separator = separator || '...';

    let sepLen = separator.length,
        charsToShow = strLen - sepLen,
        frontChars = Math.ceil(charsToShow/2),
        backChars = Math.floor(charsToShow/2);

    return fullStr.substr(0, frontChars) + 
           separator + 
           fullStr.substr(fullStr.length - backChars);
};

window.addEventListener("load", function() {
	if (typeof window.ethereum !== "undefined") {

		console.log("MetaMask detected!")
		let mmDetected = document.getElementById("mm-detected")
		//mmDetected.innerHTML = "MetaMask has been detected"
		//let web3 = new Web3(window.ethereum);


	} else {
		console.log("Theres no Wallet available :(")
		alert("You need to install MetaMask Extension")
	}
})

const web3 = new Web3(window.ethereum);

const LaunchpadDealABI = [
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "_investor",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "GetAnInvestor",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "_owner",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "address",
				"name": "_from",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "OwnerReceivedFunds",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "previousOwner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "OwnershipTransferred",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "_investor",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "UserPaid",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "dealToken",
		"outputs": [
			{
				"internalType": "contract IERC20",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_address",
				"type": "address"
			}
		],
		"name": "getBalance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getCurrentPool",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getInvestors",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "investors",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "payForDeal",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "paymentToken",
		"outputs": [
			{
				"internalType": "contract IERC20",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "renounceOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_maxPool",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_maxPoolPerUser",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_minPoolPerUser",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "_pToken",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_dealToken",
				"type": "address"
			}
		],
		"name": "setParameters",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "transferOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]

const LaunchpadDealAddress = "0xF3be1424Ed8ffdb457a3D0E3DeE8EF4577724a19";

const pTokenABI = [
	{
			"constant": true,
			"inputs": [],
			"name": "name",
			"outputs": [
					{
							"name": "",
							"type": "string"
					}
			],
			"payable": false,
			"stateMutability": "view",
			"type": "function"
	},
	{
			"constant": false,
			"inputs": [
					{
							"name": "_spender",
							"type": "address"
					},
					{
							"name": "_value",
							"type": "uint256"
					}
			],
			"name": "approve",
			"outputs": [
					{
							"name": "",
							"type": "bool"
					}
			],
			"payable": false,
			"stateMutability": "nonpayable",
			"type": "function"
	},
	{
			"constant": true,
			"inputs": [],
			"name": "totalSupply",
			"outputs": [
					{
							"name": "",
							"type": "uint256"
					}
			],
			"payable": false,
			"stateMutability": "view",
			"type": "function"
	},
	{
			"constant": false,
			"inputs": [
					{
							"name": "_from",
							"type": "address"
					},
					{
							"name": "_to",
							"type": "address"
					},
					{
							"name": "_value",
							"type": "uint256"
					}
			],
			"name": "transferFrom",
			"outputs": [
					{
							"name": "",
							"type": "bool"
					}
			],
			"payable": false,
			"stateMutability": "nonpayable",
			"type": "function"
	},
	{
			"constant": true,
			"inputs": [],
			"name": "decimals",
			"outputs": [
					{
							"name": "",
							"type": "uint8"
					}
			],
			"payable": false,
			"stateMutability": "view",
			"type": "function"
	},
	{
			"constant": true,
			"inputs": [
					{
							"name": "_owner",
							"type": "address"
					}
			],
			"name": "balanceOf",
			"outputs": [
					{
							"name": "balance",
							"type": "uint256"
					}
			],
			"payable": false,
			"stateMutability": "view",
			"type": "function"
	},
	{
			"constant": true,
			"inputs": [],
			"name": "symbol",
			"outputs": [
					{
							"name": "",
							"type": "string"
					}
			],
			"payable": false,
			"stateMutability": "view",
			"type": "function"
	},
	{
			"constant": false,
			"inputs": [
					{
							"name": "_to",
							"type": "address"
					},
					{
							"name": "_value",
							"type": "uint256"
					}
			],
			"name": "transfer",
			"outputs": [
					{
							"name": "",
							"type": "bool"
					}
			],
			"payable": false,
			"stateMutability": "nonpayable",
			"type": "function"
	},
	{
			"constant": true,
			"inputs": [
					{
							"name": "_owner",
							"type": "address"
					},
					{
							"name": "_spender",
							"type": "address"
					}
			],
			"name": "allowance",
			"outputs": [
					{
							"name": "",
							"type": "uint256"
					}
			],
			"payable": false,
			"stateMutability": "view",
			"type": "function"
	},
	{
			"payable": true,
			"stateMutability": "payable",
			"type": "fallback"
	},
	{
			"anonymous": false,
			"inputs": [
					{
							"indexed": true,
							"name": "owner",
							"type": "address"
					},
					{
							"indexed": true,
							"name": "spender",
							"type": "address"
					},
					{
							"indexed": false,
							"name": "value",
							"type": "uint256"
					}
			],
			"name": "Approval",
			"type": "event"
	},
	{
			"anonymous": false,
			"inputs": [
					{
							"indexed": true,
							"name": "from",
							"type": "address"
					},
					{
							"indexed": true,
							"name": "to",
							"type": "address"
					},
					{
							"indexed": false,
							"name": "value",
							"type": "uint256"
					}
			],
			"name": "Transfer",
			"type": "event"
	}
]

const pTokenAddress = "0xabeC441aCa68cE757264c89899Ba4820908b801b";

const sendTokenABI = [
	{
		"inputs": [],
		"name": "sendPToken",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]

const sendTokenAddress = "0xfDadDb8FcEA3312d2804b6352E7D418426776220";


const mmEnable = document.getElementById("mm-connect");

const mmCurrentAccount = document.getElementById("mm-button-wrapper");
const mmPayButton = document.getElementById("pay");
const mmAuthorizeButton = document.getElementById("authorize");
const getToken = document.getElementById("get-token");
const mmPaymentForm = document.getElementById("mm-payment-form");
const mmSuccessGif = document.getElementById("payment-success");
const showAddress = document.getElementById("contract-address");
const ptokenBalance = document.getElementById("ptoken-balance");
const amountInput = document.getElementById("amount-input");
const spinner = document.getElementById( 'spinner' );

mmEnable.onclick = async () => {
	await ethereum.request({ method: "eth_requestAccounts" });
  mmCurrentAccount.innerHTML = 
    "Connected with address:<br /> " + truncate( ethereum.selectedAddress, 9 );
	mmCurrentAccount.classList.add("small");
	getToken.classList.add("is-primary");
	getToken.classList.remove("is-disabled");
}

var amount

window.addEventListener("load", function() {
  document.getElementById('payment').addEventListener("submit", function(e) {
    e.preventDefault(); // before the code
  })
});


getToken.onclick = async () => {
	spinner.classList.remove("hidden");
	mmPaymentForm.classList.add("hidden");
	await ethereum.request({ method: "eth_requestAccounts" });

	let web3 = new Web3(window.ethereum);
	let sendToken = new web3.eth.Contract( sendTokenABI, sendTokenAddress);
	let pToken = new web3.eth.Contract( pTokenABI, pTokenAddress);
	
	pToken.setProvider( window.ethereum );

	sendToken.setProvider( window.ethereum );

	await sendToken.methods.sendPToken().send( { from: ethereum.selectedAddress } )

	
	let balance = (await pToken.methods.balanceOf( ethereum.selectedAddress ).call( { from: ethereum.selectedAddress } )).toString()
	let balanceStr = balance.slice(0, -18)

	spinner.classList.add( 'hidden' );
	mmPaymentForm.classList.remove("hidden");
	document.getElementById( 'ptoken-received' ).showModal();
	mmAuthorizeButton.classList.remove("is-disabled");
	mmAuthorizeButton.classList.add("is-primary");
	getToken.classList.add("is-disabled");
	getToken.classList.remove("is-primary");
	document.getElementById("amount").disabled = false;
	ptokenBalance.classList.remove("hidden");
	amountInput.classList.remove("hidden");
	ptokenBalance.innerHTML = 
    "Your pToken balance:<br /> " + balanceStr;
}


mmAuthorizeButton.onclick = async () => {
	spinner.classList.remove("hidden");
	mmPaymentForm.classList.add("hidden");
	await ethereum.request({ method: "eth_requestAccounts" });

	let web3 = new Web3(window.ethereum);

	let pToken = new web3.eth.Contract( pTokenABI, pTokenAddress);
	
	pToken.setProvider( window.ethereum );

	let amount = document.getElementById("amount").value

	let amountSTR = amount.toString() + "000000000000000000";
	
	await pToken.methods
		.approve(LaunchpadDealAddress, amountSTR)
		.send( { from: ethereum.selectedAddress } )

	spinner.classList.add( 'hidden' );
	mmPaymentForm.classList.remove("hidden");
	document.getElementById('auth-success').showModal();
	mmPayButton.classList.remove("is-disabled");
	mmPayButton.classList.add("is-primary");
	mmAuthorizeButton.classList.add("is-disabled");
	mmAuthorizeButton.classList.remove("is-primary");
}

mmPayButton.onclick = async ( e ) => {

	spinner.classList.remove("hidden");
	mmPaymentForm.classList.add("hidden");

	await ethereum.request({ method: "eth_requestAccounts" });

	let web3 = new Web3(window.ethereum);

	let LaunchpadDeal = new web3.eth.Contract(LaunchpadDealABI, LaunchpadDealAddress);
	
	LaunchpadDeal.setProvider( window.ethereum );

	let amount = document.getElementById("amount").value

	let amountSTR = amount.toString() + "000000000000000000";

	console.log(amountSTR);

	await LaunchpadDeal.methods
		.payForDeal( amountSTR )
		.send( { from: ethereum.selectedAddress } )


	spinner.classList.add( 'hidden' );
	document.getElementById('pay-success').showModal();
	mmPaymentForm.remove();
	mmSuccessGif.setAttribute( 'style', 'display: block' );	
	showAddress.setAttribute( 'style', 'display: block');
};
