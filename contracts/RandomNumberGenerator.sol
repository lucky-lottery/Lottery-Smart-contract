// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

import "./interfaces/IRandomNumberGenerator.sol";
import "./interfaces/ILottery.sol";

/**
 * @title The RandomNumberConsumerV2 contract
 * @notice A contract that gets random values from Chainlink VRF V2
 */
contract RandomNumberGenerator is VRFConsumerBaseV2, IRandomNumberGenerator, Ownable, ReentrancyGuard {
  
  VRFCoordinatorV2Interface immutable COORDINATOR;
  LinkTokenInterface immutable LINKTOKEN;

  address private lotteryAddress_;

  // Your subscription ID.
  uint64 immutable s_subscriptionId;

  bytes32 immutable s_keyHash;

  uint32 private callbackGasLimit_ = 500000;

  // The default is 3, but you can set this higher.
  uint16 immutable s_requestConfirmations = 3;

  // For this example, retrieve 2 random values in one request.
  // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
  uint32 private maxNumberTicket_ = 6;

  uint256 public requestId_;

  mapping(uint256 => uint256[]) private tickets_;

 /**
  * @dev Throws if called by any account other than the owner.
  */
  modifier onlyLottery() {
      require(msg.sender == lotteryAddress_, "caller is not the Lottery address");
       _;
  }

  /**
   * @notice Constructor inherits VRFConsumerBaseV2
   *
   * @param subscriptionId - the subscription ID that this contract uses for funding requests
   * @param vrfCoordinator - coordinator, check https://docs.chain.link/docs/vrf-contracts/#configurations
   * @param keyHash - the gas lane to use, which specifies the maximum gas price to bump to
   */
  constructor(
    uint64 subscriptionId,
    address vrfCoordinator,
    address link,
    bytes32 keyHash
  ) VRFConsumerBaseV2(vrfCoordinator) {
    COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
    LINKTOKEN = LinkTokenInterface(link);
    s_keyHash = keyHash;
    s_subscriptionId = subscriptionId;
  }

  function requestRandomTicket() external override onlyOwner onlyLottery {
    // Will revert if subscription is not set and funded.
    requestId_ = COORDINATOR.requestRandomWords(
      s_keyHash,
      s_subscriptionId,
      s_requestConfirmations,
      callbackGasLimit_,
      maxNumberTicket_
    );
  }

  function setLotteryAddress(address _lotteryAddress) external  onlyOwner{
      lotteryAddress_ = _lotteryAddress;
  }

  function setCallbackGasLimit(uint32 _gas) external onlyOwner{
      callbackGasLimit_ = _gas;
  }

  function setMaxNumberTicket(uint32 _max) external onlyOwner{
      maxNumberTicket_ = _max;
  }

  function getTicketOf(uint256 _requestId) override external view returns (uint256[] memory ticket) {
      return tickets_[_requestId];
  }
  
  function getNumberOfTicketOf(uint256 _requestId, uint32 _index) override external view returns (uint256 number) {
      return ((tickets_[_requestId][_index] % 55) +1);
  }

  function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) override internal virtual {
    require(requestId != 0, "requestId can't be 0");
    tickets_[requestId_] = randomWords;
    ILottery(lotteryAddress_).lotteryResults(requestId_, randomWords);
  }
}