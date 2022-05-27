const LotteryToken = artifacts.require("LotteryToken.sol");
module.exports = function (deployer){
    deployer.deploy(LotteryToken);
};