pragma ton-solidity >= 0.35.0;
import "./interfaces.sol";

pragma AbiHeader time;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

contract Pair {
    //Errors
    uint constant YOU_ARE_NOT_GOD = 101;

    enum NFTPairTypes {CrystallAuction, FTAuction, CrystallPair, FTPair}
    enum StatusPair {pre_open,open,close}
    //Fields
    address public seller;
    address public exchanger;
    bytes public description;
    address[] public wallets_root;
    address[] public wallets;
    address[] auth_wallets; //shoud be equal to wallets finish_time 
    StatusPair public status;
    NFTPairTypes public type_contract;
    address public receiver; //should be equal to seller on start
    uint32 public finish_time;
    uint128 public commission;
    uint128 public price;
    mapping(address=>uint128[]) public tokenIdStorage;
    uint128 countTokens;
    uint128 countCallback;
    //Modifiers
    modifier onlySeller {
        require((msg.pubkey() != 0) && (msg.sender == seller),
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
        require(search(auth_wallets,msg.sender),YOU_ARE_NOT_GOD);
        tvm.accept();
        _;
    }

    modifier onlyRootWallets {
        require(search(wallets_root,msg.sender),YOU_ARE_NOT_GOD);
        tvm.accept();
        _;
    }

    modifier onlyInTime {
        if (now > finish_time) {
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
        require(status == StatusPair.open);
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
        return{value: 0, bounce: false, flag: 64} type_contract;  
    }

    // function afterSignatureCheck(TvmSlice body, TvmCell message) private inline returns (TvmSlice) {
    //     body.decode(uint64);
    //     uint32 expireAt = body.decode(uint32);
    //     require(expireAt >= now, YOU_ARE_NOT_GOD);   
    //     return body;
    // }

    //CreateNFTWallet
    function createNFTWallet(address root_token) public onlyPreOpen onlySeller {
        RootTokenContractNF(root_token).deployWallet_response{value:1  ton, flag:64, callback: Pair.createNFTWallet_callback}(0,tvm.pubkey(), 3 ton);
        wallets_root.push(root_token); 
    }

    function createNFTWallet_callback(address value0) public onlyPreOpen onlyRootWallets { 
		wallets.push(value0);
        auth_wallets.push(value0);
    }

    function getPubKey() public view returns (uint pubkey) {
        return tvm.pubkey();
    }


    //Approve Sell

    function approveSell() public onlyPreOpen onlySeller{
        countTokens = 0;
        countCallback = 0;
        for (uint256 i = 0; i < wallets.length; i++) {
            TONTokenWalletNF(wallets[i]).getBalance_response{callback: Pair.getBalance_callback}();
        }
    }

    function getBalance_callback(uint128 value0) public onlyWallets { 
        countTokens += value0;
        TONTokenWalletNF(msg.sender).getTokenByIndex_response{callback: Pair.getTokenId_callback}(value0);
    }

    function getTokenId_callback(uint128 value0) public onlyWallets {
        countCallback += 1;
        tokenIdStorage[msg.sender].push(value0);
        if (countTokens == countCallback) {
            status = StatusPair.open;
        }
    }
    
    function finish() external onlyOpen {
        require(finish_time <= now,YOU_ARE_NOT_GOD);
        tvm.accept();
        finish_tech();
    }

    function finish_tech() private {
        status = StatusPair.close;
        start_withdraw();
    }

    //Withdraw    

    function send_from_nftWallet(uint128 value0) public onlyWallets {
        TONTokenWalletNF(msg.sender).transfer(receiver,value0,0);
    }
    function withdraw_handler(uint128 value0) public onlyWallets {
        if (value0 > 0) {
            for (uint128 i = 0; i < value0; i++) {
                TONTokenWalletNF(msg.sender).getTokenByIndex_response{callback: Pair.send_from_nftWallet}(i);
            }
        }
        start_withdraw();
    }

    function start_withdraw() private {

        for (uint256 wallet = 0; wallet < wallets.length; wallet++) {
            for (uint128 i = 0; i < tokenIdStorage[wallets[wallet]].length; i++) {
                TONTokenWalletNF(wallets[wallet]).transfer(receiver,tokenIdStorage[wallets[wallet]][i],0.1 ton);
            }
        }
        if (seller != exchanger) {
            exchanger.transfer(math.divr(price, commission) * commission,false,0);
        }
        tvm.log("Goodbye, Elliot");
        seller.transfer(0,false,160);
    }
}
