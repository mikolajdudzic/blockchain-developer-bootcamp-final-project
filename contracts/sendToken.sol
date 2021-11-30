// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract sendToken {

	IERC20 pToken = IERC20(0xabeC441aCa68cE757264c89899Ba4820908b801b);

	function sendPToken() public {
		pToken.transfer(msg.sender, 150000000000000000000);
	}
}