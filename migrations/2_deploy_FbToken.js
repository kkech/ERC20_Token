const FbToken = artifacts.require("./FbToken.sol");

module.exports = function(deployer) {
  deployer.deploy(FbToken, 1000000);
};
