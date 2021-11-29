// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract LaunchpadDeal is Ownable {

  // State variables
  address[] public investors;

  uint256 maxPool; // max limit of investors contribution
  uint256 maxPoolPerUser; // max contribution for 1 investor
  uint256 minPoolPerUser; // min contribution for 1 investor
  uint256 currentPool; // current number of raised money
  IERC20 public paymentToken; //

  
  struct investorStruct {
    uint pool; // Users overall contribution.
    bool isPaidFull;
  }


  // Mappings

  mapping(address => investorStruct) private investorStructMapping;

  
  // Events
  
  event GetAnInvestor(address _investor, uint256 _amount);
  
  event UserPaid(address _investor, uint256 _amount);

  event OwnerReceivedFunds(address _owner, address _from, uint256 _amount);

  
  // Modifiers

  modifier UserCanPay(uint256 _amount) {
    uint256 formatedAmount = formatValue(_amount); 
    // Check whether user has the payment token in his wallet in the first place.
    require(paymentToken.balanceOf(msg.sender) > 0);
    // Checks whether user already paid for this campaign. 
    require(investorStructMapping[msg.sender].isPaidFull != true, "You already paid for this campaign.");
    // Checks whether the amount fits in max limit.
    require(currentPool + formatedAmount <= maxPool, "Try to buy for less money.");
    // Checks if the user provided enough contribution.
    require(formatedAmount >= minPoolPerUser, "Your payment must be equal or higher than 5 USDT");
    // Makes sure user cant buy more than max limit.
    require(formatedAmount <= maxPoolPerUser, "Your allocation is lower.");
    _;
  }
  
  modifier isAnInvestor() {
    for (uint i = 0; i < investors.length; i++) {
      if (investors[i] == msg.sender) {
        _;
      }
    }
    revert("You are not an investor!");
  }


  // Functions

  function setParameters(uint256 _maxPool, uint256 _maxPoolPerUser, uint256 _minPoolPerUser, address _pToken) external onlyOwner {
    maxPool = formatValue(_maxPool);
    maxPoolPerUser = formatValue(_maxPoolPerUser);
    minPoolPerUser = formatValue(_minPoolPerUser);
    paymentToken = IERC20(_pToken); // PToken 
  }

  function formatValue(uint256 _amount) public pure returns(uint) {
    uint256 currentFormatedValue = _amount * 10**18;
    return currentFormatedValue;
  }
  
  // Function transfers payment token from users address to the owners one. 
  function payForDeal(uint256 _amount) public UserCanPay(_amount) {
    address investor = msg.sender;
    uint256 formatedAmount = formatValue(_amount);

    paymentToken.transferFrom(investor, Ownable.owner(), formatedAmount);

    // 
    emit UserPaid(investor, _amount);

    // Contract adds user to the "investors" array
    investors.push(investor);
    currentPool += formatedAmount;
    uint256 index = investors.length - 1;
    investorStructMapping[investors[index]].pool = formatedAmount;
    if (formatedAmount == maxPoolPerUser) {
      investorStructMapping[investors[index]].isPaidFull = true;
    }
  }

  function getInvestors() external onlyOwner {
    for (uint i = 0; i < investors.length; i++) {
      emit GetAnInvestor(investors[i], investorStructMapping[investors[i]].pool);
    }
  }

  function getCurrentPool() external view returns(uint) {
    return currentPool;
  }

  function getBalance(address _address) public view returns(uint) {
    return paymentToken.balanceOf(_address);
  }
}