// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//@notice minting pToken for test purposes only
contract PToken is ERC20 {
	constructor() ERC20("Payment Token", "PToken") {
		_mint(msg.sender, 1000000000000000000000000);
		_mint(0x4Cbe105b497377B53E61B44795706E1ecd6A6696, 1000000000000000000000);
	}
}