// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPower655{

    /**
     * Change random generator
     */
   function changeRandomGenerator(address _randomGenerater) external;

   function changeMaxNumberTickets(uint256 _amount) external;

   function changePriceOfTikect(uint256 _amount) external;

   function buyTickets(uint256 _lotteryId, uint32[] calldata _ticketNumbers) external;

   function viewCurrentLotteryId() external returns (uint256);
}