// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ILottery{

 /**
  * Change random generator
  */
  function changeRandomGenerator(address _address) external;

  function changePriceOfTikect(uint256 _amount) external;

  function buyTickets(uint8[] calldata _ticketNumbers) external;

  function currentLotteryId() external view returns (uint256);

  function lotteryResults(uint256 _requestId, uint256[] memory _ticket) external;
}