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
import "./interfaces/IPower655.sol";
import "./SafeBEP20.sol";

/** 
 * @title Lottery Power 6/55.
 * @notice It is a contract for a lottery system using
 * randomness provided externally.
 */
contract Power655 is Ownable, ReentrancyGuard, IPower655{
    using SafeMath for uint256;
    using SafeBEP20 for IBEP20;

    // Random
    IRandomNumberGenerator public randomGenerater;
    // BUSD token
    IBEP20 BUSD;

    modifier notContract() {
        require(!_isContract(msg.sender), "Contract not allowed");
        require(msg.sender == tx.origin, "Proxy contract not allowed");
        _;
    }

    uint256 public maxNumberTickets = 10;
    uint256 public priceOfTikect = 1000000000000000000;

    uint256 public currentLotteryId;
    uint256 public currentTicketId;

    uint256 public constant MIN_LENGTH_LOTTERY = 3 days -5 minutes;
    uint256 public constant MAX_LENGTH_LOTTERY = 3 days +5 minutes;
    uint256 public constant MAX_TRANSACTION_FEE = 200000000000000000; // 20%

    event NewRandomGenerator(address indexed randomGenerator);
    event NewMaxNumberTickets(uint256 indexed maxNumberTickets);
    event NewPriceOfTikect(uint256 indexed priceOfTikect);

    event TicketsPurchase(address indexed buyer, uint256 indexed lotteryId, uint256 numberTickets);

    // Struct
    struct Lottery{
        uint256 startTime;
        uint256 endTime;
        uint256 priceOfTikect;
        uint32 finalNumber;
    }

    struct Ticket{
        uint32 number;
        address owner;
    }

    // Mapping are cheaper than arrays
    mapping(uint256 => Lottery) private _lotteries;
    mapping(uint256 => Ticket) private _tickets;

    // Keeps track of number of ticket per unique combination for each lotteryId
    mapping(uint256 => mapping(uint32 => uint256)) private _numberTicketsPerLotteryId;

    // Keep track of user ticket ids for a given lotteryId
    mapping(address => mapping(uint256 => uint256[])) private _userTicketIdsPerLotteryId;


    constructor(address _BUSD, address _randomGenerater) {
        BUSD = IBEP20(_BUSD);
        randomGenerater = IRandomNumberGenerator(_randomGenerater);
    }
    
    function changeRandomGenerator(address _randomGenerater) external override onlyOwner {
        randomGenerater = IRandomNumberGenerator(_randomGenerater);
        emit NewRandomGenerator(_randomGenerater);
    }

    function changeMaxNumberTickets(uint256 _amount) external override onlyOwner {
        maxNumberTickets = _amount;
        emit NewMaxNumberTickets(_amount);
    }
    
    function changePriceOfTikect(uint256 _amount) external override onlyOwner {
        priceOfTikect = _amount;
         emit NewPriceOfTikect(_amount);
    }

    function startLottery() external nonReentrant onlyOwner{
        currentLotteryId++;
        _lotteries[currentLotteryId] = Lottery({
            startTime: block.timestamp,
            endTime: block.timestamp + MAX_LENGTH_LOTTERY,
            priceOfTikect: priceOfTikect,
            finalNumber: 0
        });
    }

    function buyTickets(uint256 _lotteryId, uint32[] calldata _ticketNumbers) external override notContract nonReentrant {
        require(_ticketNumbers.length != 0, "No ticket specified");
        require(_ticketNumbers.length <= maxNumberTickets, "Too many tickets");

        for (uint32 i =0; i< _ticketNumbers.length; i++){
            uint32 thisTicketNumber = _ticketNumbers[i];
            
            require((thisTicketNumber > 1000000) && (thisTicketNumber <=1999999), "Outside range");

            _numberTicketsPerLotteryId[_lotteryId][1 + (thisTicketNumber % 10)]++;
            _numberTicketsPerLotteryId[_lotteryId][11 + (thisTicketNumber % 100)]++;
            _numberTicketsPerLotteryId[_lotteryId][111 + (thisTicketNumber % 1000)]++;
            _numberTicketsPerLotteryId[_lotteryId][1111 + (thisTicketNumber % 10000)]++;
            _numberTicketsPerLotteryId[_lotteryId][11111 + (thisTicketNumber % 100000)]++;
            _numberTicketsPerLotteryId[_lotteryId][111111 + (thisTicketNumber % 1000000)]++;

            _userTicketIdsPerLotteryId[msg.sender][_lotteryId].push(currentTicketId);

            _tickets[currentTicketId] = Ticket({number: thisTicketNumber, owner: msg.sender});

            // Increase lottery ticket number
            currentTicketId++;
        }

        emit TicketsPurchase(msg.sender, _lotteryId, _ticketNumbers.length);
    }

    /**
     * @notice View current lottery id
     */
    function viewCurrentLotteryId() external view override returns (uint256) {
        return currentLotteryId;
    }

    /**
     * @notice View lottery information
     * @param _lotteryId: lottery id
     */
    function viewLottery(uint256 _lotteryId) external view returns (Lottery memory) {
        return _lotteries[_lotteryId];
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