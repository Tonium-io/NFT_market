pragma ton-solidity >= 0.35.0;
import "./Variables.sol";
interface BaseExchanger {
    function setCommission(uint128 _commission) external;
    function createNFTPairCrystall(uint128 price,uint64 time, address client, uint256 pubkey) external;
    function createNFTAuctionCrystall(uint128 price,uint64 time,uint128 step, address client, uint256 pubkey) external;
    function addIndex(PairState status) external;
    function withdraw(uint128 amount) external;
}
