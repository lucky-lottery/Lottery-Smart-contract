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

/**
 * @title The RandomNumberConsumerV2 contract
 * @notice A contract that gets random values from Chainlink VRF V2
 */
contract RandomNumberGenerator is VRFConsumerBaseV2, IRandomNumberGenerator, Ownable, ReentrancyGuard {
  
  VRFCoordinatorV2Interface immutable COORDINATOR;
  LinkTokenInterface immutable LINKTOKEN;

  // Your subscription ID.
  uint64 immutable s_subscriptionId;

  bytes32 immutable s_keyHash;

  uint32 immutable s_callbackGasLimit = 500000;

  // The default is 3, but you can set this higher.
  uint16 immutable s_requestConfirmations = 3;

  // For this example, retrieve 2 random values in one request.
  // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
  uint32 immutable s_numWords = 6;

  uint256 public currentTicketId_;
  uint256 public lastTicketId_;

  mapping(uint256 => uint256[]) private tickets_;
  mapping(uint256 => bool) private ticketPrizeDrawn_;

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

  function requestRandomTicket() external override onlyOwner {
    // Will revert if subscription is not set and funded.
    currentTicketId_ = COORDINATOR.requestRandomWords(
      s_keyHash,
      s_subscriptionId,
      s_requestConfirmations,
      s_callbackGasLimit,
      s_numWords
    );
    ticketPrizeDrawn_[currentTicketId_] = false;
  }

  function fund(uint96 amount) public {
      LINKTOKEN.transferAndCall(
          address(COORDINATOR),
          amount,
          abi.encode(s_subscriptionId)
      );
  }

  function getTicketOf(uint256 _ticketId) override external view returns (uint256[] memory ticket){
      require(ticketPrizeDrawn_[_ticketId] == true, "Sprinning prize");
      return tickets_[_ticketId];
  }
  
  function getNumberOfTicketOf(uint256 _ticketId, uint32 _index) override external view returns (uint256 number) {
      require(ticketPrizeDrawn_[_ticketId] == true, "Verification in progress");

      return ((tickets_[_ticketId][_index] % 55) +1);
  }

  function prizeDrawn(uint256 _ticketId) override external view returns (bool){
      return ticketPrizeDrawn_[_ticketId];
  }

  function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) override internal virtual {
    require(requestId != 0, "requestId can't be 0");

    lastTicketId_ = requestId;
    
    tickets_[requestId] = randomWords;

    ticketPrizeDrawn_[requestId] = true;
  }
}