// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

//@title Funding a promising project
//@author Mikolaj Dudzic
//@notice Contract was not build for commercial use.


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract LaunchpadDeal is Ownable {

  //@notice State variables

  //@notice array of investors
  address[] public investors;
  //@notice max limit of investors contribution
  uint256 maxPool;
  //@notice max contribution for 1 investor
  uint256 maxPoolPerUser;
  //@notice min contribution for 1 investor
  uint256 minPoolPerUser;
  //@notice current number of raised money
  uint256 currentPool;
  //@notice erc20 token which will be used for payments
  IERC20 public paymentToken;
  //@notice
  uint256 tokenDecimals;

  
  struct investorStruct {
    //@notice Users overall contribution.
    uint pool;
    bool isPaidFull;
  }


  // Mappings

  mapping(address => investorStruct) private investorStructMapping;

  
  // Events
  
  event GetAnInvestor(address _investor, uint256 _amount);
  
  event UserPaid(address _investor, uint256 _amount);

  event OwnerReceivedFunds(address _owner, address _from, uint256 _amount);

  
  //@notice Modifiers

  //@notice modifier checks if user is aligible to pay for deal
  //@param the amount that user wants to pay
  modifier UserCanPay(uint256 _amount) {
    uint256 formatedAmount = formatValue(_amount); 
    // Check whether user has the payment token in his wallet in the first place.
    require(paymentToken.balanceOf(msg.sender) > 0);
    // Checks whether user already paid for this campaign. 
    require(investorStructMapping[msg.sender].isPaidFull != true, "You already paid for this campaign.");
    // Checks whether the amount fits in max limit.
    require(currentPool + formatedAmount <= maxPool, "Try to buy for less money.");
    // Checks if the user provided enough contribution.
    require(formatedAmount >= minPoolPerUser, "Your payment must be equal or higher than 10 pToken");
    // Makes sure user cant buy more than max limit.
    require(formatedAmount <= maxPoolPerUser, "Your allocation is lower.");
    _;
  }
  
  //@notice modifier check if caller of the function is an investor
  modifier isAnInvestor() {
    for (uint i = 0; i < investors.length; i++) {
      if (investors[i] == msg.sender) {
        _;
      }
    }
    revert("You are not an investor!");
  }


  // Functions

  //@notice Owner of the contract can set deal parameters after deploying the contract
  function setParameters(uint256 _maxPool, uint256 _maxPoolPerUser, uint256 _minPoolPerUser, address _pToken, uint256 _tokenDecimals) external onlyOwner {
    maxPool = formatValue(_maxPool);
    maxPoolPerUser = formatValue(_maxPoolPerUser);
    minPoolPerUser = formatValue(_minPoolPerUser);
    paymentToken = IERC20(_pToken);
    tokenDecimals = _tokenDecimals;
    currentPool = 0;
  }

  //@notice function format the value provide by a user to value with 18 zeros to match the solidity format
  function formatValue(uint256 _amount) public view returns(uint) {
    uint256 currentFormatedValue = _amount * 10**tokenDecimals;
    return currentFormatedValue;
  }
  
  //@notice transfers payment token from users address to the owners one. 
  function payForDeal(uint256 _amount) public UserCanPay(_amount) {
    address investor = msg.sender;
    uint256 formatedAmount = formatValue(_amount);

    paymentToken.transferFrom(investor, Ownable.owner(), formatedAmount);

    // 
    emit UserPaid(investor, _amount);

    //@notice Contract adds user to the "investors" array
    investors.push(investor);
    currentPool += formatedAmount;
    uint256 index = investors.length - 1;
    investorStructMapping[investors[index]].pool = formatedAmount;
    if (formatedAmount == maxPoolPerUser) {
      investorStructMapping[investors[index]].isPaidFull = true;
    }
  }

  //@notice returns a list of investors addresses and its pools emitting the GetAnInvestor event 
  function getInvestors() external onlyOwner {
    for (uint i = 0; i < investors.length; i++) {
      emit GetAnInvestor(investors[i], investorStructMapping[investors[i]].pool);
    }
  }

  //@notice returns a current status of investors contribution
  function getCurrentPool() external view returns(uint) {
    return currentPool;
  }

  //@notice returns a balance of some ERC20 token on provided address
  function getBalance(address _address) public view returns(uint) {
    return paymentToken.balanceOf(_address);
  }


  //@notice this function is for test purposes only.
  function getNum(uint256 _amount) external view UserCanPay(_amount) returns(uint) {
    return _amount;
  }
}