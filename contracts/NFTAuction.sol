pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;
import "./Pair.sol";

contract NFTAuction is Pair {
    NFTPairTypes public type_contract = NFTPairTypes.CrystallAuction;
    uint128 static public step;
    uint128 static public price;
    constructor () public {
        m_price = price;
        receiver = seller;
    }

    function sell(address client) override public onlyOpen onlyInTime{
        require(msg.value >= m_price,NOT_ENOUGH_MONEY);
        require(!client.isNone(), 102);
        tvm.commit();
        if (seller != receiver) {receiver.transfer(m_price - step,false,0);}
        receiver = client;
        m_price = msg.value + step;
    }
}
