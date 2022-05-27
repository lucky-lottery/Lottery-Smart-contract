// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

interface ILotteryToken {
    function BASE_MINT() external view returns (uint256);
    function mint(address receiver, uint256 amount) external;
    function burn(uint amount) external;
    function treasuryTransfer(address[] memory recipients, uint256[] memory amounts) external;
    function treasuryTransfer(address recipient, uint256 amount) external;
    function transferTaxRate() external view returns (uint16) ;
    function balanceOf(address account) external view returns (uint256) ;
    function transfer(address to, uint value) external returns (bool);
    function isGenesisAddress(address account) external view returns (bool);
}