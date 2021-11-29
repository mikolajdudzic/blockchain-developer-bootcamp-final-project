const DudzicToken = artifacts.require("DudzicToken");

module.exports = function (deployer) {
  deployer.deploy(DudzicToken);
};