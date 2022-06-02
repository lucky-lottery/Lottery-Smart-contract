// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

import "./interfaces/IBEP20.sol";
import "./interfaces/IRandomNumberGenerator.sol";
import "./interfaces/ILottery.sol";
import "./SafeBEP20.sol";

/** 
 * @title Lottery Power 6/55.
 * @notice It is a contract for a lottery system using
 * randomness provided externally.
 */
contract Power655 is Ownable, ReentrancyGuard, ILottery{
    using SafeMath for uint256;
    using SafeBEP20 for IBEP20;
    uint256 lotteryID_;
    uint256 ticketID_;

    // Random
    address public randomGeneraterAddress_;
    // BUSD token
    IBEP20 BUSD;

    // Represents the status of the lottery
    enum Status { 
        NotStarted,     // The lottery has not started yet
        Open,           // The lottery is open for ticket purchases 
        Closed,         // The lottery is no longer open for ticket purchases
        Completed       // The lottery has been closed and the numbers drawn
    }

    modifier notContract() {
        require(!_isContract(msg.sender), "Contract not allowed");
        _;
    }

    modifier onlyRandomGenerater() {
        require(msg.sender == randomGeneraterAddress_, "caller is not the random generater address");
        _;
    }

    struct Lottery {
        uint256 lotteryID;          // ID for lotto
        uint256 requestId;          // The requestId of random generat
        Status status;              // Status for lotto
        uint256 prizePool;          // The amount of prize money
        uint8[6] winningNumbers;    // The winning numbers
        uint8 specialNumber;
    }

    struct Ticket {
        uint8[6] number;
        address owner;
    }

    // Mapping are cheaper than arrays
    mapping(uint256 => Lottery) private lotteries_;
    mapping(uint256 => Ticket) private tickets_;

    // Keep track of user ticket ids for a given lotteryId
    mapping(address => mapping(uint256 => uint256[])) private userTicketIdsPerLotteryId_;


    event LotteryOpen(uint256 lotteryId);
    event LotteryClose(uint256 lotteryId);
    event TicketsPurchase(address indexed buyer, uint256 indexed lotteryId, uint256 numberTickets);

    constructor(){
        
    }

    function createNewLotto() external onlyOwner{
        lotteryID_ = block.timestamp;
        
        lotteries_[lotteryID_] = Lottery({
            lotteryID: lotteryID_,
            requestId: 0,
            status: Status.Open,
            prizePool: 0,
            winningNumbers: [uint8(0),uint8(0),uint8(0),uint8(0),uint8(0),uint8(0)],
            specialNumber: 0
        });

        emit LotteryOpen(lotteryID_);
    }
    
    function changeRandomGenerator(address _address) external onlyOwner{
        randomGeneraterAddress_ = _address;
    }

    function changePriceOfTikect(uint256 _amount) external onlyOwner{

    }

    function buyTickets(uint8[] calldata _ticketNumbers) external {
        require(_ticketNumbers.length ==  6, "No ticket specified");
        require(lotteries_[lotteryID_].status == Status.Open, "Lottery is not open");

        ticketID_++;
        userTicketIdsPerLotteryId_[msg.sender][ticketID_] = _ticketNumbers;
    }

    function closeLottery(uint256 _ticketID) external onlyOwner{
       lotteries_[_ticketID].status = Status.Closed;
       emit LotteryClose(lotteryID_);
    }

    function lotteryResults(uint256 _requestId, uint256[] memory _ticket) external override onlyRandomGenerater {
        require(lotteries_[lotteryID_].status == Status.Closed, "Lottery is not closed" );
        
        lotteries_[lotteryID_].requestId = _requestId;

        lotteries_[lotteryID_].winningNumbers[0] = uint8(_ticket[0]);
        lotteries_[lotteryID_].winningNumbers[1] = uint8(_ticket[1]);
        lotteries_[lotteryID_].winningNumbers[2] = uint8(_ticket[2]);
        lotteries_[lotteryID_].winningNumbers[3] = uint8(_ticket[3]);
        lotteries_[lotteryID_].winningNumbers[4] = uint8(_ticket[4]);
        lotteries_[lotteryID_].winningNumbers[5] = uint8(_ticket[5]);

        lotteries_[lotteryID_].specialNumber = uint8(_ticket[6]);



        lotteries_[lotteryID_].status = Status.Completed;
    }



    function currentLotteryId() external view returns (uint256){
        return lotteryID_;
    }

    /**
     * @notice Check if an address is a contract
     */
    function _isContract(address _addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(_addr)
        }
        return size > 0;
    }
}