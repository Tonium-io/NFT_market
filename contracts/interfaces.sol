pragma ton-solidity >= 0.35.0;
interface TONTokenWalletNF {
    function transfer(address dest,uint128 tokenId,uint128 grams) external functionID(12);
    function getBalance_response() external responsible functionID(28) returns (uint128 value0);
    function getTokenByIndex_response(uint128 index) external responsible functionID(29) returns  (uint128 value0);
    function transfer_by_pubkey(uint256 pubkey, uint128 tokenId, uint128 grams, address nonce) functionID(31) external;
    function send_all_token_by_pubkey(uint256 pubkey, address nonce) functionID(13) external;
}


interface RootTokenContractNF {
    function deployWallet(int8 workchain_id,uint256 pubkey,uint128 tokenId,uint128 grams, address wallet) external returns (address value0);
    function grant(address dest,uint128 tokenId,uint128 grams) external;
    function mint(uint128 tokenId) external returns (uint128 value0);
    function getName() external returns (bytes value0);
    function getSymbol() external returns (bytes value0);
    function getDecimals() external returns (uint8 value0);
    function getRootKey() external returns (uint256 value0);
    function getTotalSupply() external returns (uint128 value0);
    function getTotalGranted() external returns (uint128 value0);
    function getWalletCode() external returns (TvmCell value0);
    function getLastMintedToken() external returns (uint128 value0);
    function getWalletAddress(int8 workchain_id,uint256 pubkey) external returns (address value0);
    function getWalletAddress_response(int8 workchain_id,uint256 pubkey) external responsible functionID(24) returns (address value0);
    function deployWallet_response(int8 workchain_id,uint256 pubkey,uint128 grams, address nonce) external responsible functionID(13) returns (address value0);
    function getWalletCode_response() external responsible functionID(26) returns (TvmCell value0);
    
}
enum PairState {created,index,close}
interface IExchanger {
    function setCommission(uint128 _commission) external;
    function setTrust(bool _only_trust) external;
    function addTrust(address _root_token) external;
    function delTrust(address _root_token) external;
    function createNFTPairCrystall(uint128 price,uint64 time, uint256 pubkey) external;
    function createNFTAuctionCrystall(uint128 price,uint64 time,uint128 step, uint256 pubkey) external;
    function addIndex(PairState status) external;
    function renderHelloWorld() external returns (bytes value0);
    function touch() external;
    function sendValue(address dest,uint128 amount,bool bounce) external;
    function timestamp() external returns (uint32 timestamp);
    function name() external returns (bytes name);
    function commission() external returns (uint128 commission);
    function highest_commission() external returns (uint256 highest_commission);
    function only_trusted() external returns (bool only_trusted);
    function controller_code() external returns (TvmCell controller_code);
    function pair_code() external returns (TvmCell pair_code);
    function auction_code() external returns (TvmCell auction_code);
    function changableTrusted() external returns (bool changableTrusted);
    function time_limit() external returns (uint64 time_limit);
    function withdraw_address() external returns (address withdraw_address);
}
