pragma solidity ^0.4.18;

import './StagedCrowdsale.sol';
import './UnitedCyborgsToken.sol';

contract CommonSale is StagedCrowdsale {

  address public wallet;

  address public directMintAgent;

  uint public percentRate = 100;

  uint public minPrice;

  uint public price;

  UnitedCyborgsToken public token;
  
  modifier onlyDirectMintAgentOrOwner() {
    require(directMintAgent == msg.sender || owner == msg.sender);
    _;
  }
  
  function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
    directMintAgent = newDirectMintAgent;
  }
  
  function setMinPrice(uint newMinPrice) public onlyOwner {
    minPrice = newMinPrice;
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

  function directMint(address to, uint investedWei) public onlyDirectMintAgentOrOwner saleIsOn {
    mintTokens(to, investedWei);
  }

  function createTokens() public whenNotPaused payable {
    require(msg.value >= minPrice);
    wallet.transfer(msg.value);
    mintTokens(msg.sender, msg.value);
  }

  function mintTokens(address to, uint weiInvested) internal {
    uint milestoneIndex = currentMilestone();
    Milestone storage milestone = milestones[milestoneIndex];
    invested = invested.add(msg.value);
    uint tokens = weiInvested.mul(1 ether).div(price);
    uint bonusTokens = tokens.mul(milestone.bonus).div(percentRate);
    uint tokensWithBonus = tokens.add(bonusTokens);
    token.mint(this, tokensWithBonus);
    token.transfer(to, tokensWithBonus);
  }

  function() external payable {
    createTokens();
  }
  
  function retrieveTokens(address anotherToken, address to) public onlyOwner {
    ERC20 alienToken = ERC20(anotherToken);
    alienToken.transfer(to, alienToken.balanceOf(this));
  }

}

