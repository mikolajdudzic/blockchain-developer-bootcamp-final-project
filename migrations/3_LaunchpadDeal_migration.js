const LaunchpadDeal = artifacts.require("LaunchpadDeal");

module.exports = function (deployer) {
  deployer.deploy(LaunchpadDeal);
};