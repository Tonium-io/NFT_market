pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;
import "./Pair.sol";

contract NFTAuction is Pair {
    NFTPairTypes public type_contract = NFTPairTypes.CrystallAuction;
    uint128 public step;
    constructor (uint128 _price, uint64 _time, address _seller, uint256 _seller_pubkey, uint128 _commission, address _exchanger_address, uint128 _step) public {
        seller = _seller;
        seller_pubkey = _seller_pubkey;
        receiver = _seller;
        receiver_pubkey = _seller_pubkey;
        price = _price;
        finish_time = _time;
        seller = _seller;
        commission = _commission;
        step = _step;
        exchanger = _exchanger_address;
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
