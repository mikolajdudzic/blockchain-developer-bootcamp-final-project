// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// imports
contract LaunchingProject {

    //State variables
    address[] public investors;

    //uint allocation;
    uint maxPool;
    uint maxPoolPerUser;
    uint currentPool;
    address public owner;

    struct investorStruct {
        uint pool;
        bool isPaid;
    }

    constructor() {
        owner = msg.sender;
        maxPool = 3 ether;
        maxPoolPerUser = 1 ether;
    }

    //Mappings

    mapping(address => investorStruct) private investorStructM;

    //Events
    // event gdy zostanie zdeklarowana maks. alokacja dla projektu.
    event maxAlocationSet(address indexed _by, uint indexed _value);

    event maxAllocationPerUserSet(address indexed _by, uint indexed _value);

    event userPaidForItsPool(address indexed _user, uint _value);

    event ownerReceiveFunds(address indexed _owner, uint _value);

    event LogAnInvestor(address _investor, uint _value);

    event LogOwnerAddress(address _owner);

    event LogCurrentPool(uint _currentPool);

    //Enums
    

  //Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier isPaid() {
        require(investorStructM[msg.sender].isPaid != true, "You already paid for this campaign." );
        _;
    }

    modifier isEnoughSpace() {
        require( currentPool + msg.value <= maxPool, "There isn't enough space for your payment.");
        _;
    }


    modifier cost(uint _amount) {
        require(msg.value > 0, "Your payment must be higher than zero :)");
        require(msg.value <= _amount, "Your allocation is lower.");
        _;
    }  

    //Functions  
    function getBalance() public view returns(uint) {
        return address(msg.sender).balance;
    }
  
    function setMaxPoolTo(uint _maxPool) public onlyOwner {
        maxPool = _maxPool;
        emit maxAlocationSet(msg.sender, _maxPool);
    }

    function setMaxPoolPerUserTo(uint _maxAllo) public onlyOwner {
        maxPoolPerUser = _maxAllo;
        emit maxAllocationPerUserSet(msg.sender, _maxAllo);

    }

    receive() external payable isPaid isEnoughSpace cost(maxPoolPerUser) {
        address investor = msg.sender;
        uint value = msg.value;
        payable(owner).transfer(value);
        investors.push(investor);
        currentPool += value;
        uint index = investors.length - 1;
        investorStructM[investors[index]].pool = value;
        investorStructM[investors[index]].isPaid = true;
  }

    function getInvestors() public {
        for (uint i=0; i<investors.length; i++) {
            emit LogAnInvestor(investors[i], investorStructM[investors[i]].pool);
        }
    }

    function getOwner() public {
        emit LogOwnerAddress(owner);
    }

    function getCurrentPool() public {
        emit LogCurrentPool(currentPool);
    }

}