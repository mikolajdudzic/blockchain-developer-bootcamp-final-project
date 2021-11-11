// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DudzicToken is ERC20 {
	constructor() ERC20("Dudzic Token", "DUD") {
		_mint(msg.sender, 1000000000000000000000000);
	}
}