pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;
import "./Pair.sol";

contract NFTAuction is Pair {
    NFTPairTypes public type_contract = NFTPairTypes.CrystallAuction;
    uint128 public step;
    constructor (uint128 _price, uint128 _step) public {
        price = _price;
        step = _step;
        receiver = seller;
        receiver_pubkey = seller_pubkey;
    }

    function sell(uint256 pubkey) override public onlyOpen onlyInTime{
        require(msg.value >= price,NOT_ENOUGH_MONEY);
        require(pubkey != 0, 102);
        tvm.commit();
        if (seller != receiver) {receiver.transfer(price - step,false,0);}
        receiver = msg.sender;
        receiver_pubkey = pubkey;
        price = msg.value + step;
    }
}
