// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IRandomNumberGenerator {

   /**
    * @notice Requests randomness
    * Assumes the subscription is funded sufficiently; "Words" refers to unit of data in Computer Science
    */
    function requestRandomTicket() external;

   /**
    * @notice get a ticket by ticketId
    *
    * @param _requestId ticketID
    */
    function getTicketOf(uint256 _requestId) external view returns (uint256[] memory ticket);

    /**
     * @notice get a number by the ticketId and index
     *
     * @param _requestId ticketID
     * @param _index index a number in the ticket
     */
    function getNumberOfTicketOf(uint256 _requestId, uint32 _index) external view returns (uint256 number);
}