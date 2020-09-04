pragma solidity ^0.6;
import "https://github.com/hemapallevada/BLOCKINOPENZEPPLIN/blob/master/token/ERC20/ERC20.sol";
contract MyToken is ERC20 {
    address public minter;
   constructor()ERC20("Mytoken","$") public{
       address add=tx.origin;
       _mint(add,21000000);
       minter=add;
       approve(minter,21000000);
    }
   function buyTokens(address payable minter_add,uint tokens_to_purchase) payable public{
       uint amount_required=tokens_to_purchase*2;
        require(msg.value>=amount_required,"Please send enough money to buy tokens");
        uint spend=amount_required;
        minter_add.transfer(spend);
       transferFrom(minter,msg.sender,tokens_to_purchase);

    }
     function getCurrentAddress() public view returns( address ){
 return msg.sender;
  }
  function getMinter() public view returns(address){
  return minter;
  }
}
