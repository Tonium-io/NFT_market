pragma ton-solidity >= 0.35.0;
import "./INFT.sol";
import "./IPair.sol";
import "./Variables.sol";
import "./IExchanger.sol";
pragma AbiHeader time;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

abstract contract Pair is BasePair{
    //Errors
    uint constant YOU_ARE_NOT_GOD = 101;
    uint constant NOT_ENOUGH_MONEY = 102;
    uint constant NOT_OPEN = 103;
    uint constant NOT_GOOD_PUBKEY = 104;

    // seller = _seller;
    //     seller_pubkey = _seller_pubkey;
    //     receiver = _seller;
    //     receiver_pubkey = _seller_pubkey;
    //     price = _price;
    //     finish_time = _time;
    //     seller = _seller;
    //     commission = _commission;
    //     step = _step;
    //     exchanger = _exchanger_address;
    //Fields
    address static public seller;
    uint256 static public seller_pubkey;
    address static public exchanger;
    address[] public wallets_root;
    address[] public wallets;
    PairState public status = PairState.created;
    address public receiver; //should be equal to seller on start
    uint256 public receiver_pubkey;
    uint64 static public finish_time;
    uint128 static public commission;
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
        require(status == PairState.created);
        _;
    }

    modifier onlyOpen {
        require(status == PairState.index, NOT_OPEN);
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


    function createNFTWallet(address root_token) onlySeller override public {
        BaseRootTokenContractNF(root_token).deployWallet_response{value:2  ton, flag:64, callback: Pair.createNFTWallet_callback}(0,tvm.pubkey(), 1 ton, address(this)) ;
        wallets_root.push(root_token);
    }

    function createNFTWallet_callback(address value0) override public onlyPreOpen onlyRootWallets { 
        m_wallets[msg.sender] = value0;
		wallets.push(value0);
    }

    //Approve Sell

    function approveSell() override public onlyPreOpen onlySeller{
        status = PairState.index;
        BaseExchanger(exchanger).addIndex(PairState.index);
    }

    function pre_finish() override external onlySeller {
        require(receiver == seller,YOU_ARE_NOT_GOD);
        start_withdraw();
    }
    
    function finish() override external onlyOpen {
        require(finish_time < now,YOU_ARE_NOT_GOD);
        tvm.accept();
        finish_tech();
    }

    function finish_tech() internal {
        status = PairState.close;
        start_withdraw();
        BaseExchanger(exchanger).addIndex(PairState.close);
    }

    function sell(uint256 pubkey) override virtual public;

    //Withdraw    

    function start_withdraw() private inline {
        uint128 balance = 10000000;
        for (uint256 wallet = 0; wallet < wallets.length; wallet++) {
            BaseTONTokenWalletNF(wallets[wallet]).send_all_token_by_pubkey{flag:0,value: 0.01 ton}(receiver_pubkey,receiver);
            balance = balance + 0.01 ton;
        }
        if (seller != receiver) {
            exchanger.transfer((price/ 100) * commission,false,0);
            balance = balance + (price/ 100) * commission;
        }
        seller.transfer(address(this).balance - balance,false,32);
    }
}
