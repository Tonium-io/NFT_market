pragma ton-solidity >= 0.35.0;
import "./Variables.sol";
interface BaseExchanger {
    function setCommission(uint128 _commission) external;
    function setTrust(bool _only_trust) external;
    function addTrust(address _root_token) external;
    function delTrust(address _root_token) external;
    function createNFTPairCrystall(uint128 price,uint64 time, uint256 pubkey) external;
    function createNFTAuctionCrystall(uint128 price,uint64 time,uint128 step, uint256 pubkey) external;
    function addIndex(PairState status) external;
    function withdraw(uint128 amount) external;
}
