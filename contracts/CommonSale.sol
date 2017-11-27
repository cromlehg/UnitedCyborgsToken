pragma solidity ^0.4.18;

import './StagedCrowdsale.sol';
import './UnitedCyborgsToken.sol';

contract CommonSale is StagedCrowdsale {

  address public wallet;

  address public directMintAgent;

  uint public percentRate = 100;

  uint public price;

  UnitedCyborgsToken public token;
  
  modifier onlyDirectMintAgentOrOwner() {
    require(directMintAgent == msg.sender || owner == msg.sender);
    _;
  }
  
  function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
    directMintAgent = newDirectMintAgent;
  }
  
  function setWallet(address newWallet) public onlyOwner {
    wallet = newWallet;
  }

  function setPrice(uint newPrice) public onlyOwner {
    price = newPrice;
  }

  function setToken(address newToken) public onlyOwner {
    token = UnitedCyborgsToken(newToken);
  }

  function directMint(address to, uint investedWei) public onlyDirectMintAgentOrOwner {
    mintTokens(to, investedWei);
  }

  function createTokens() public whenNotPaused payable {
    wallet.transfer(msg.value);
    mintTokens(msg.sender, msg.value);
  }

  function mintTokens(address to, uint weiInvested) internal minInvestLimited(weiInvested) {
    uint milestoneIndex = currentMilestone();
    Milestone storage milestone = milestones[milestoneIndex];
    invested = invested.add(weiInvested);
    uint tokens = weiInvested.mul(price).div(1 ether);
    if(milestone.bonus > 0) tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
    token.mint(this, tokens);
    token.transfer(to, tokens);
  }

  function() external payable {
    createTokens();
  }
  
  function retrieveTokens(address anotherToken, address to) public onlyOwner {
    ERC20 alienToken = ERC20(anotherToken);
    alienToken.transfer(to, alienToken.balanceOf(this));
  }

}

