// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./VehicularNFT.sol";

contract Vehicular {
  address owner;
  uint ownerBalance;
  VehicularNFT nftAddress;

  event AddRenterEvent(
    address indexed _walletAddress,
    string _firstName,
    string _lastName,
    bool _canRent,
    bool _active,
    uint _balance,
    uint _due,
    uint _start,
    uint _end,
    uint256 indexed _tokenId
  );

  event TakingCarEvent(address indexed _walletAddress, uint256 indexed _tokenId, uint _start);

  event BringingCarBackEvent(address indexed _walletAddress, uint256 indexed _tokenId, uint _end);

  constructor(address _nftAddress) {
    owner = msg.sender;
    nftAddress = VehicularNFT(_nftAddress);
  }

  // Add yourself as a Renter
  struct Renter {
    address walletAddress;
    string firstName;
    string lastName;
    bool canRent;
    bool active;
    uint balance;
    uint due;
    uint start;
    uint end;
    uint tokenId;
    string image_string;
  }

  mapping(address => Renter[]) private renters;
  mapping(uint256 => bool) private listedCars;

  function addRenter(
    string memory _firstName,
    string memory _lastName,
    bool _canRent,
    bool _active,
    uint _balance,
    uint _due,
    uint _start,
    uint _end,
    uint256 _tokenId,
    string memory _image_string
  ) public {
    require(!nftAddress.isOwner(_tokenId), "You dont own the car ");
    require(listedCars[_tokenId] != true, "Car has already been listed");

    Renter memory renting = Renter(
      msg.sender,
      _firstName,
      _lastName,
      _canRent,
      _active,
      _balance,
      _due,
      _start,
      _end,
      _tokenId,
      _image_string
    );
    renters[msg.sender].push(renting);
    listedCars[_tokenId] = true;
    emit AddRenterEvent(msg.sender, _firstName, _lastName, _canRent, _active, _balance, _due, _start, _end, _tokenId);
  }

  modifier isRenter(address walletAddress) {
    require(msg.sender != walletAddress, "You can only manage your account");
    _;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "You are not allowed to access this");
    _;
  }

  // Checkout bike
  function takingCarOut(address walletAddress, uint _index) public isRenter(walletAddress) {
    require(renters[walletAddress][_index].due == 0, "You have a pending balance.");
    require(renters[walletAddress][_index].canRent == true, "You cannot rent at this time.");
    renters[walletAddress][_index].active = true;
    renters[walletAddress][_index].start = block.timestamp;
    renters[walletAddress][_index].canRent = false;
    emit TakingCarEvent(walletAddress, renters[walletAddress][_index].tokenId, renters[walletAddress][_index].start);
  }

  // Check in a Car
  function bringingCarBack(address walletAddress, uint _index) public isRenter(walletAddress) {
    require(renters[walletAddress][_index].active == true, "Please check out a car first.");
    renters[walletAddress][_index].active = false;
    renters[walletAddress][_index].end = block.timestamp;
    setDue(walletAddress, _index);

    emit BringingCarBackEvent(
      walletAddress,
      renters[walletAddress][_index].tokenId,
      renters[walletAddress][_index].end
    );
  }

  // Get total duration of Car use
  function renterTimespan(uint start, uint end) internal pure returns (uint) {
    return end - start;
  }

  function getTotalDuration(address walletAddress, uint _index) public view isRenter(walletAddress) returns (uint) {
    if (renters[walletAddress][_index].start == 0 || renters[walletAddress][_index].end == 0) {
      return 0;
    } else {
      uint timespan = renterTimespan(renters[walletAddress][_index].start, renters[walletAddress][_index].end);
      uint timespanInMinutes = timespan / 60;
      return timespanInMinutes;
    }
  }

  // Get Contract balance
  function balanceOf() public view onlyOwner returns (uint) {
    return address(this).balance;
  }

  function getOwnerBalance() public view onlyOwner returns (uint) {
    return ownerBalance;
  }

  // 0x02b7137922AF6F0B6ec34a67dD4a3cE1b6C5B948

  function withdrawOwnerBalance() public payable {
    payable(owner).transfer(ownerBalance);
  }

  // Get Renter's balance
  function balanceOfRenter(address walletAddress, uint _index) public view isRenter(walletAddress) returns (uint) {
    return renters[walletAddress][_index].balance;
  }

  // Set Due amount
  function setDue(address walletAddress, uint _index) internal {
    uint timespanMinutes = getTotalDuration(walletAddress, _index);
    uint fiveMinuteIncrements = timespanMinutes / 5;
    renters[walletAddress][_index].due = fiveMinuteIncrements * 5000000000000000;
  }

  function canRentCar(address walletAddress, uint _index) public view isRenter(walletAddress) returns (bool) {
    return renters[walletAddress][_index].canRent;
  }

  // Deposit
  function deposit(address walletAddress, uint _index) public payable isRenter(walletAddress) {
    renters[walletAddress][_index].balance += msg.value;
  }

  // Make Payment
  function makePayment(address walletAddress, uint amount, uint _index) public isRenter(walletAddress) {
    require(renters[walletAddress][_index].due > 0, "You do not have anything due at this time.");
    require(
      renters[walletAddress][_index].balance > amount,
      "You do not have enough funds to cover payment. Please make a deposit."
    );
    renters[walletAddress][_index].balance -= amount;
    ownerBalance += amount;
    renters[walletAddress][_index].canRent = true;
    renters[walletAddress][_index].due = 0;
    renters[walletAddress][_index].start = 0;
    renters[walletAddress][_index].end = 0;
  }

  function getDue(address walletAddress, uint _index) public view isRenter(walletAddress) returns (uint) {
    return renters[walletAddress][_index].due;
  }

  function getRenter(
    address walletAddress,
    uint _index
  )
    public
    view
    isRenter(walletAddress)
    returns (string memory firstName, string memory lastName, bool canRent, bool active)
  {
    firstName = renters[walletAddress][_index].firstName;
    lastName = renters[walletAddress][_index].lastName;
    canRent = renters[walletAddress][_index].canRent;
    active = renters[walletAddress][_index].active;
  }

  function renterExists(address walletAddress, uint _index) public view isRenter(walletAddress) returns (bool) {
    if (renters[walletAddress][_index].walletAddress != address(0)) {
      return true;
    }
    return false;
  }
}
