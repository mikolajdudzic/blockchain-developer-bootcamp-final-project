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
  uint256 currentPool = 0;
  //@notice erc20 token which will be used for payments
  IERC20 public paymentToken;
  IERC20 public dealToken;

  
  struct investorStruct {
    //@notice Users overall contribution.
    uint pool;
    bool isPaidFull;
    bool isClaimed;
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
    // Checks whether user already paid for this campaign. 
    require(investorStructMapping[msg.sender].isPaidFull != true, "You already paid for this campaign.");
    // Checks whether the amount fits in max limit.
    require(currentPool + _amount <= maxPool, "Try to buy for less money.");
    // Checks if the user provided enough contribution.
    require(_amount >= minPoolPerUser, "Your payment must be equal or higher than 10 pToken");
    // Makes sure user cant buy more than max limit.
    require(_amount <= maxPoolPerUser, "Your allocation is lower.");
    _;
  }
  
  //@notice modifier check if caller of the function is an investor
  modifier isAnInvestor() {
    require(investorStructMapping[msg.sender].isClaimed != true, "You already claimed the tokens!");
    for (uint i = 0; i < investors.length; i++) {
      if (investors[i] == msg.sender) {
        _;
      }
    }
    revert("You are not an investor!");
  }


  // Functions

  //@notice Owner of the contract can set deal parameters after deploying the contract
  function setParameters(
    uint256 _maxPool, 
    uint256 _maxPoolPerUser, 
    uint256 _minPoolPerUser,
     address _pToken, 
     address _dealToken) external onlyOwner returns(bool) {
    maxPool = _maxPool;
    maxPoolPerUser = _maxPoolPerUser;
    minPoolPerUser = _minPoolPerUser;
    paymentToken = IERC20(_pToken);
    dealToken = IERC20(_dealToken);
    return true;
  }
  
  //@notice transfers payment token from users address to the owners one. 
  function payForDeal(uint256 _amount) public UserCanPay(_amount) {
    address investor = msg.sender;

    paymentToken.transferFrom(investor, Ownable.owner(), _amount);
    emit UserPaid(investor, _amount);
    emit OwnerReceivedFunds(Ownable.owner(), investor, _amount);

    dealToken.transfer(msg.sender, _amount);

    //@notice Contract adds user to the "investors" array
    investors.push(investor);
    currentPool += _amount;
    uint256 index = investors.length - 1;
    investorStructMapping[investors[index]].pool = _amount;
    if (_amount == maxPoolPerUser) {
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
}