pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;
import "./Pair.sol";


contract NFTPair is Pair {
    NFTPairTypes public type_contract = NFTPairTypes.CrystallPair;
    uint128 static public price;
    constructor () public {
        m_price = price;
        receiver = seller;
        receiver_pubkey = seller_pubkey;
    }

    function sell(uint256 pubkey) override public onlyOpen onlyInTime {
        require(msg.value >= m_price,NOT_ENOUGH_MONEY);
        require(pubkey != 0, 102);
        tvm.accept();
        receiver = msg.sender;
        receiver_pubkey = pubkey;
        Pair.finish_tech();
    }
}
