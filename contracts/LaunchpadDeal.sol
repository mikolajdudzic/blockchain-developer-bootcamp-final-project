// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract LauchpadDeal is Ownable {

  // State variables
  address[] public investors;

  uint maxPool;
  uint maxPoolPerUser;
  uint currentPool;
  IERC20 usdt = IERC20(0x110a13FC3efE6A245B50102D2d79B3E76125Ae83);
  IERC20 paymentToken = usdt;
  
  
  struct investorStruct {
    uint pool;
    bool isPaid;
    bool isPaidFull;
  }

  constructor() {
    maxPool = 1000;
    maxPoolPerUser = 200;
  }


  // Mappings

  mapping(address => investorStruct) private investorStructMapping;

  mapping(address => address) public tokenPriceFeedMapping;

  // Events
  
  event getAnInvestor(address _investor, uint _amount);

  event userPaid(address _user, uint _amount);

  event ownerReceivedFunds(address _owner, address _from, uint _amount);

  // Modifiers

  modifier UserCanPay(uint256 _amount) {
    require(investorStructMapping[msg.sender].isPaid != true, "You already paid for this campaign.");
    require(currentPool + _amount <= maxPool, "Try to buy for less ether.");
    require(_amount >= 10, "Your payment must be equal or higher than 10 USDT");
    require(_amount <= maxPoolPerUser, "Your allocation is lower.");
    _;
  }

  // Functions

  function setPriceFeedContract(address _token, address _priceFeed) public onlyOwner {
    tokenPriceFeedMapping[_token] = _priceFeed;
  }

  function getTokenValue(address _token) public view returns(uint256, uint256) {
    address priceFeedAddress = tokenPriceFeedMapping[_token];
    AggregatorV3Interface priceFeed = AggregatorV3Interface(priceFeedAddress);
    (,int256 price,,,) = priceFeed.latestRoundData();
    uint256 decimals = priceFeed.decimals();
    return (uint256(price), decimals);
  }

  function getUserPaymentTokenValue(address _user) public view returns(uint256) {
    (uint256 price, uint256 decimals) = getTokenValue(address(paymentToken));
    return (paymentToken.balanceOf(_user) * price / (10**decimals));
    }

  function payForDeal(uint256 _amount) external payable UserCanPay(_amount) {
    address investor = msg.sender;
    paymentToken.transferFrom(msg.sender, Ownable.owner(), _amount); 
    emit userPaid(investor, _amount);
    investors.push(investor);
    currentPool += _amount;
    uint index = investors.length - 1;
    investorStructMapping[investors[index]].pool = _amount;
    investorStructMapping[investors[index]].isPaid = true;
    if (_amount == maxPoolPerUser) {
      investorStructMapping[investors[index]].isPaidFull = true;
    }
  }

  function getInvestors() public {
    for (uint i = 0; i < investors.length; i++) {
      emit getAnInvestor(investors[i], investorStructMapping[investors[i]].pool);
    }
  }

  function getCurrentPool() public view returns(uint) {
    return currentPool;
  }
}
  
