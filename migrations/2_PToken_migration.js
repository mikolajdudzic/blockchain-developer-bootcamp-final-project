const PToken = artifacts.require("PToken");

module.exports = function (deployer) {
  deployer.deploy(PToken);
};