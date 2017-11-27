pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

import './UnitedCyborgsToken.sol';
import './Presale.sol';
import './Mainsale.sol';

contract Configurator is Ownable {

  UnitedCyborgsToken public token; 

  Presale public presale;

  Mainsale public mainsale;

  function deploy() public onlyOwner {
    owner = 0x95EA6A4ec9F80436854702e5F05d238f27166A03;

    token = new UnitedCyborgsToken();

    presale = new Presale();

    presale.setToken(token);
    presale.addMilestone(14, 50);
    presale.addMilestone(14, 40);
    presale.setWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
    presale.setStart(1517317200);
    presale.setMinInvestedLimit(100000000000000000);
    presale.setPrice(1000000000000000000000);
    presale.setHardcap(6000000000000000000000);
    token.setSaleAgent(presale);	

    mainsale = new Mainsale();

    mainsale.setToken(token);
    presale.addMilestone(7, 30);
    presale.addMilestone(7, 20);
    presale.addMilestone(7, 10);
    presale.addMilestone(7, 0);
    mainsale.setPrice(1000000000000000000000);
    mainsale.setWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
    mainsale.setFoundersTokensWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
    mainsale.setBountyTokensWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
    mainsale.setStart(1525352400);
    mainsale.setMinInvestedLimit(100000000000000000);
    presale.setHardcap(60000000000000000000000);
    mainsale.setFoundersTokensPercent(13);
    mainsale.setBountyTokensPercent(5);

    presale.setMainsale(mainsale);

    token.transferOwnership(owner);
    presale.transferOwnership(owner);
    mainsale.transferOwnership(owner);
  }

}

