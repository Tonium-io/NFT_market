pragma ton-solidity >= 0.35.0;
import "./interfaces.sol";

pragma AbiHeader time;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

contract Pair {
    //Errors
    uint constant YOU_ARE_NOT_GOD = 101;
    uint constant NOT_ENOUGH_MONEY = 102;
    uint constant NOT_OPEN = 103;
    uint constant NOT_GOOD_PUBKEY = 104;

    enum NFTPairTypes {CrystallAuction, FTAuction, CrystallPair, FTPair}
    enum StatusPair {pre_open,open,close}
    //Fields
    TvmCell public code_controller;
    address public seller;
    uint256 public seller_pubkey;
    address public exchanger;
    bytes public description;
    address[] public wallets_root;
    address[] public wallets;
    address[] auth_wallets; //shoud be equal to wallets finish_time 
    StatusPair public status = StatusPair.pre_open;
    address public receiver; //should be equal to seller on start
    uint256 public receiver_pubkey;
    uint64 public finish_time;
    uint128 public commission;
    uint128 public price;
    mapping(address=>uint128[]) public tokenIdStorage;
    uint128 countTokens;
    uint128 countCallback;
    //Modifiers
    modifier onlySeller {
        require((msg.pubkey() != 0) && (msg.pubkey() == seller_pubkey),
            YOU_ARE_NOT_GOD);
        tvm.accept();
        _;
    }

    modifier onlyExchanger {
        require(msg.pubkey() == tvm.pubkey(),
            YOU_ARE_NOT_GOD);
        tvm.accept();
        _;
    }

    modifier onlyWallets {
        tvm.log("recieve");
        require(search(auth_wallets,msg.sender),YOU_ARE_NOT_GOD);
        tvm.accept();
        tvm.log("accept");
        _;
    }

    modifier onlyRootWallets {
        require(search(wallets_root,msg.sender),YOU_ARE_NOT_GOD);
        tvm.accept();
        _;
    }

    modifier onlyInTime {
        if (finish_time < now) {
            tvm.accept();
            finish_tech();
        }
        else {
            _;
        }
    }

    modifier onlyPreOpen {
        require(status == StatusPair.pre_open);
        _;
    }

    modifier onlyOpen {
        require(status == StatusPair.open, NOT_OPEN);
        _;
    }


    //Technical fn
    function search(address[] _array, address _wallet) private pure returns (bool){
        for(uint i = 0; i < _array.length; i++) {
            if(_array[i] == _wallet) {
                return true;
            }
        }
        return false;
    }
    //Metadata
    function getType_response() public responsible returns (NFTPairTypes) {
        return{value: 0, bounce: true, flag: 64} type_contract;  
    }

    function getRootWallets_response() public responsible returns (address []){
        return{value: 0, bounce: true, flag: 64} wallets_root; 
    }

    // function afterSignatureCheck(TvmSlice body, TvmCell message) private inline returns (TvmSlice) {
    //     body.decode(uint64);
    //     uint32 expireAt = body.decode(uint32);
    //     require(expireAt >= now, YOU_ARE_NOT_GOD);   
    //     return body;
    // }

    //CreateNFTWallet


    function createNFTWallet(address root_token) onlySeller public {
        RootTokenContractNF(root_token).deployWallet_response{value:1  ton, flag:64, callback: Pair.createNFTWallet_callback}(0,tvm.pubkey(), 1 ton, address(this)) ;
        wallets_root.push(root_token);
    }

    function createNFTWallet_callback(address value0) public onlyPreOpen onlyRootWallets { 
		wallets.push(value0);
        auth_wallets.push(value0);
    }

    //Approve Sell

    function approveSell() public onlyPreOpen onlySeller{
        countTokens = 0;
        countCallback = 0;
        for (uint128 i = 0; i < wallets.length; i++) {
            TONTokenWalletNF(wallets[i]).getBalance_response{callback: Pair.getBalance_callback}();
        }
    }

    function getBalance_callback(uint128 value0) public onlyWallets { 
        
        countTokens += value0;
        for (uint128 i = 0; i < value0; i++) {
            tvm.log("get token id");
            TONTokenWalletNF(msg.sender).getTokenByIndex_response{callback: Pair.getTokenId_callback}(i);
        }
        
    }

    function getTokenId_callback(uint128 value0) public onlyWallets {
        countCallback += 1;
        tokenIdStorage[msg.sender].push(value0);
        if (countTokens == countCallback) {
            status = StatusPair.open;
        }
    }
    
    function finish() external onlyOpen {
        require(finish_time < now,YOU_ARE_NOT_GOD);
        tvm.accept();
        finish_tech();
    }

    function finish_tech() internal {
        status = StatusPair.close;
        start_withdraw();
    }

    //Withdraw    

    // function send_from_nftWallet(uint128 value0) public onlyWallets {uint128
    function withdraw_handler(address value0) public onlyWallets {
        // if (value0 > 0) {
        //     for (uint128 i = 0; i < value0; i++) {
        //         //TONTokenWalletNF(msg.sender).getTokenByIndex_response{callback: Pair.send_from_nftWallet}(i);
        //     }
        // }
        start_withdraw();
    }

    function start_withdraw() private inline {

        for (uint256 wallet = 0; wallet < wallets.length; wallet++) {
            TONTokenWalletNF(wallets[wallet]).send_all_token_by_pubkey(receiver_pubkey,receiver);
        }
        if (seller != exchanger) {
            exchanger.transfer(math.divr(price, 100) * commission,false,0);
        }
        tvm.log("Goodbye, Elliot");
        seller.transfer(0,false,128 + 32);
    }
}
