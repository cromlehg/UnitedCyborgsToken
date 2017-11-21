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
//    presale.addStage(5000,300);
    presale.setWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
    presale.setStart(1517317200);
    presale.setMinPrice(100000000000000000);
    presale.setPrice(1000);
    token.setSaleAgent(presale);	

    mainsale = new Mainsale();

    mainsale.setToken(token);
  /*  mainsale.addStage(5000,200);
    mainsale.addStage(5000,180);
    mainsale.addStage(10000,170);
    mainsale.addStage(20000,160);
    mainsale.addStage(20000,150);
    mainsale.addStage(40000,130);*/
    mainsale.setPrice(1000);
    mainsale.setWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
    mainsale.setFoundersTokensWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
    mainsale.setBountyTokensWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
    mainsale.setStart(1525352400);
    mainsale.setMinPrice(100000000000000000);
    mainsale.setFoundersTokensPercent(13);
    mainsale.setBountyTokensPercent(5);

    presale.setMainsale(mainsale);

    token.transferOwnership(owner);
    presale.transferOwnership(owner);
    mainsale.transferOwnership(owner);
  }

}

