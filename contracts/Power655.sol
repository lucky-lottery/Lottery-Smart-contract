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

    // Random
    address public randomGeneraterAddress_;
    // BUSD token
    IBEP20 BUSD;

    modifier notContract() {
        require(!_isContract(msg.sender), "Contract not allowed");
        require(msg.sender == tx.origin, "Proxy contract not allowed");
        _;
    }

    modifier onlyRandomGenerater() {
        require(msg.sender == randomGeneraterAddress_, "caller is not the random generater address");
        _;
    }
    
    function changeRandomGenerator(address _address) external onlyOwner{
        randomGeneraterAddress_ = _address;
    }

    function changePriceOfTikect(uint256 _amount) external onlyOwner{

    }

     function buyTickets(uint256[] calldata _ticketNumbers) external {
         
     }

     function lotteryResults(uint256 _requestId, uint256[] memory _ticket) external onlyRandomGenerater {

     }

     function currentLotteryId() external view returns (uint256){

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