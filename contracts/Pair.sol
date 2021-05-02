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
    address public seller;
    uint256 public seller_pubkey;
    address public exchanger;
    address[] public wallets_root;
    address[] public wallets;
    StatusPair public status = StatusPair.pre_open;
    address public receiver; //should be equal to seller on start
    uint256 public receiver_pubkey;
    uint64 public finish_time;
    uint128 public commission;
    uint128 public price;
    mapping(address => address) public m_wallets;
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
        require(search(wallets,msg.sender),YOU_ARE_NOT_GOD);
        tvm.accept();
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

    //CreateNFTWallet


    function createNFTWallet(address root_token) onlySeller public {
        RootTokenContractNF(root_token).deployWallet_response{value:1  ton, flag:64, callback: Pair.createNFTWallet_callback}(0,tvm.pubkey(), 1 ton, address(this)) ;
        wallets_root.push(root_token);
    }

    function createNFTWallet_callback(address value0) public onlyPreOpen onlyRootWallets { 
        m_wallets[msg.sender] = value0;
		wallets.push(value0);
    }

    //Approve Sell

    function approveSell() public onlyPreOpen onlySeller{
        status = StatusPair.open;
        IExchanger(exchanger).addIndex(PairState.index);
    }

    function pre_finish() external onlySeller {
        require(receiver == seller,YOU_ARE_NOT_GOD);
        start_withdraw();
    }
    
    function finish() external onlyOpen {
        require(finish_time < now,YOU_ARE_NOT_GOD);
        tvm.accept();
        finish_tech();
    }

    function finish_tech() internal {
        status = StatusPair.close;
        start_withdraw();
        IExchanger(exchanger).addIndex(PairState.close);
    }

    //Withdraw    

    function start_withdraw() private inline {
        uint128 balance = 10000000;
        for (uint256 wallet = 0; wallet < wallets.length; wallet++) {
            TONTokenWalletNF(wallets[wallet]).send_all_token_by_pubkey{flag:0,value: 0.01 ton}(receiver_pubkey,receiver);
            balance = balance + 0.01 ton;
        }
        if (seller != receiver) {
            exchanger.transfer((price/ 100) * commission,false,0);
            balance = balance + (price/ 100) * commission;
        }
        seller.transfer(address(this).balance - balance,false,32);
    }
}
