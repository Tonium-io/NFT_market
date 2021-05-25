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
        receiver_pubkey = seller_pubkey;
    }

    function sell(uint256 pubkey) override public onlyOpen onlyInTime{
        require(msg.value >= m_price,NOT_ENOUGH_MONEY);
        require(pubkey != 0, 102);
        tvm.commit();
        if (seller != receiver) {receiver.transfer(m_price - step,false,0);}
        receiver = msg.sender;
        receiver_pubkey = pubkey;
        m_price = msg.value + step;
    }
}
