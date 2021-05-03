pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;
import "./Pair.sol";


contract NFTPair is Pair {
    NFTPairTypes public type_contract = NFTPairTypes.CrystallPair;
    constructor (uint128 _price, uint64 _time, address _seller, uint256 _seller_pubkey, uint128 _commission, address _exchanger_address) public {
        seller = _seller;
        seller_pubkey = _seller_pubkey;
        receiver = _seller;
        receiver_pubkey = _seller_pubkey;
        price = _price;
        finish_time = _time;
        seller = _seller;
        commission = _commission;
        exchanger = _exchanger_address;
    }

    function sell(uint256 pubkey) override public onlyOpen onlyInTime {
        require(msg.value >= price,NOT_ENOUGH_MONEY);
        require(pubkey != 0, 102);
        tvm.accept();
        receiver = msg.sender;
        receiver_pubkey = pubkey;
        Pair.finish_tech();
    }
}
