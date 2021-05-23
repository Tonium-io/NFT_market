pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;
import "./Pair.sol";


contract NFTPair is Pair {
    NFTPairTypes public type_contract = NFTPairTypes.CrystallPair;
    constructor (uint128 _price) public {
        price = _price;
        receiver = seller;
        receiver_pubkey = seller_pubkey;
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
