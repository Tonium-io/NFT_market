pragma ton-solidity >= 0.35.0;

interface BaseContoller {
    function buyNFT(address pair, uint128 price) external;
    function createNFTWallet_callback(address value0) external;
    function deployNFT(address root_token) external;
    function sendNFTToken(address wallet,address dest, uint128 tokenId) external;
    function sendValue(address dest, uint128 amount, bool bounce) external;
    function createNFTPair(address exchanger, uint128 price, uint64 time) external;
    function createNFTAuction(address exchanger, uint128 price, uint64 time, uint128 step) external;
    function setCode(TvmCell newcode) external;
}