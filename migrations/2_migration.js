var Migrations = artifacts.require("./StringUsage.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
