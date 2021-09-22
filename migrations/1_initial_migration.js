const MambaCoin = artifacts.require("MambaCoin");
const MambaNFT = artifacts.require("MambaNFT");

module.exports = function(deployer) {
  deployer.deploy(MambaCoin);
  deployer.deploy(MambaNFT);
};
