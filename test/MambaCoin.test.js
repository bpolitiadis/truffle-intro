const Mamba = artifacts.require("MambaCoin");
contract("MambaCoin", accounts => {
    
    let instance;

    beforeEach(async () => {
        instance = await Mamba.deployed();
    });
    
    it("should mint 10000 MambaCoin", async () => {
        //console.log(instance);
        const totalSupply = await instance.totalSupply.call();
        assert.equal(totalSupply.toNumber(),10000,"Minting Failed");            
    });

    it("Account 0xcB7C09fEF1a308143D9bf328F2C33f33FaA46bC2 must have a zero balance", async () => {
        //console.log(instance);
        const balance = await instance.balanceOf.call('0xcB7C09fEF1a308143D9bf328F2C33f33FaA46bC2');
        assert.equal(balance.toNumber(),0,"Account does not have a zero balance");            
    });

    it("Owner should have 10000 tokens", async () => {
        const [owner] = await web3.eth.getAccounts();
        const balance = await instance.balances.call(owner);
        assert.equal(balance, 10000, "Failed: The owner doesn't have 10000 tokens");
    });

});