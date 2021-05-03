pragma ton-solidity >= 0.35.0;

interface BasePair {
    function createNFTWallet(address root_token) external;
    function createNFTWallet_callback(address value0) external;
    function approveSell() external;
    function pre_finish() external;
    function finish() external;
    function sell(uint256 pubkey) external;
}