pragma ton-solidity >= 0.35.0;
interface BaseTONTokenWalletNF {
    function transfer(address dest,uint128 tokenId,uint128 grams) external functionID(12);
    function send_all_token_by_pubkey(uint256 pubkey, address nonce) functionID(13) external;
}


interface BaseRootTokenContractNF {
    function getWalletAddress_response(int8 workchain_id,uint256 pubkey) external responsible functionID(24) returns (address value0);
    function deployWallet_response(int8 workchain_id,uint256 pubkey,uint128 grams, address nonce) external responsible functionID(13) returns (address value0);   
}

