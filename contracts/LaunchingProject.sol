pragma solidity >=0.7.0 <0.9.0;

contract LaunchingProject {

  //State variables
  address[] public investors;

  //uint allocation;
  uint maxPool;
  uint maxPoolPerUser;
  uint currentPool;
  address owner;

  struct investorStruct {
      uint pool;
  }

  constructor() {
      owner = msg.sender;
  }

  //Mappings

  mapping(address => investorStruct) private investorStructs;

  //Events
  // event gdy zostanie zdeklarowana maks. alokacja dla projektu.
  event maxAlocationSet(address indexed _by, uint indexed _value);

  event maxAllocationPerUserSet(address indexed _by, uint indexed _value);

  event userPaidForItsPool(address indexed _user, uint _value);

  event ownerReceiveFunds(address indexed _owner, uint _value);

  event LogAnInvestor(address _investor, uint _value);

  event LogOwnerAddress(address _owner);

  //Enums
    

  //Modifiers
  modifier onlyOwner() {
      require(msg.sender == owner);
      _;
  }
  //Functions
  function setMaxPoolTo(uint _maxPool) public onlyOwner {
      maxPool = _maxPool;
      emit maxAlocationSet(msg.sender, _maxPool);
  }

  function setMaxPoolPerUserTo(uint _maxAllo) public onlyOwner {
      maxPoolPerUser = _maxAllo;
      emit maxAllocationPerUserSet(msg.sender, _maxAllo);

  }

  function transferFundsIn(uint _value) public payable {
      require(_value <= maxPoolPerUser); 
      require( maxPoolPerUser + _value <= maxPool);
      address investor = msg.sender;
      payable(investor).transfer(_value);
      emit userPaidForItsPool(investor, _value);
      transferFundsOut(_value);
      currentPool += _value;
      investors.push(investor);
      uint index = investors.length - 1;
      investorStructs[investors[index]].pool = _value;
      
  }

  function transferFundsOut(uint _value) public payable onlyOwner {
      payable(owner).transfer(_value);
      emit ownerReceiveFunds(owner, _value);
  }

  function showFullListOfInvestors() public {
      for (uint i=0; i<investors.length; i++) {
          emit LogAnInvestor(investors[i], investorStructs[investors[i]].pool);
      }
  }


  function showOwnerAddress() public {
      emit LogOwnerAddress(owner);
  }

}