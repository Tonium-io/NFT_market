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
    }

    function sell(address client) override public onlyOpen onlyInTime {
        require(msg.value >= m_price,NOT_ENOUGH_MONEY);
        require(!client.isNone(), 102);
        tvm.accept();
        receiver = client;
        Pair.finish_tech();
    }
}
