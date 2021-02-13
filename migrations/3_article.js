const Article = artifacts.require('Article');

module.exports = function(deployer){
    deployer.deploy(Article);
}