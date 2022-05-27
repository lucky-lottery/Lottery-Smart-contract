const BEP20Token = artifacts.require("LotteryToken.sol");
module.exports = function (deployer){
    deployer.deploy(BEP20Token);
};