pragma ton-solidity >= 0.35.0;
interface TONTokenWalletNF {
    function transfer(address dest,uint128 tokenId,uint128 grams) external functionID(12);
    // function accept(uint128 tokenId) external;
    // function internalTransfer(uint128 tokenId,uint256 pubkey) external;
    // function getName() external returns (bytes value0);
    // function getSymbol() external returns (bytes value0);
    // function getDecimals() external returns (uint8 value0);
    // function getBalance() external returns (uint128 value0);
    // function getWalletKey() external returns (uint256 value0);
    // function getRootAddress() external returns (address value0);
    // function allowance() external returns (address spender,uint128 allowedToken);
    // function getTokenByIndex(uint128 index) external returns (uint128 value0);
    // function getApproved(uint128 tokenId) external returns (address value0);
    // function approve(address spender,uint128 tokenId) external;
    // function transferFrom(address dest,address to,uint128 tokenId,uint128 grams) external;
    // function internalTransferFrom(address to,uint128 tokenId) external;
    // function disapprove() external;
    function getBalance_response() external responsible functionID(28) returns (uint128 value0);
    function getTokenByIndex_response(uint128 index) external responsible functionID(29) returns  (uint128 value0);
    function transfer_by_pubkey(uint256 pubkey, uint128 tokenId, uint128 grams, address nonce) functionID(31) external;
    function send_all_token_by_pubkey(uint256 pubkey, address nonce) functionID(1) external;
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
    function deployWallet_response(int8 workchain_id,uint256 pubkey,uint128 grams, address nonce) external responsible functionID(25) returns (address value0);
    function getWalletCode_response() external responsible functionID(26) returns (TvmCell value0);
    
}