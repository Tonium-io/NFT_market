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
    address[] public wallets;
    PairState public status = PairState.created;
    address public receiver; //should be equal to seller on start
    uint64 static public finish_time;
    uint128 static public commission;
    uint128 public m_price;
    
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


    function addNewToken(address token_addr) onlySeller override public {
        wallets.push(token_addr); // IMPORTANT TO CHECK THAT address(this) == token_addr.getOwner()
    }

    //TODO delete wallets_root
    // rewrite tests
    // rewrite controller

    
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

    function sell(address client) override virtual public;

    //Withdraw    

    function start_withdraw() private inline {
        uint128 balance = 10000000;
        for (uint256 wallet = 0; wallet < wallets.length; wallet++) {
            IData(wallets[wallet]).transferOwnership{flag:1,value: 1 ton}(receiver);
            balance = balance + 1 ton;
        }
        if (seller != receiver) {
            exchanger.transfer((m_price/ 100) * commission,false,0);
            balance = balance + (m_price/ 100) * commission;
        }
        seller.transfer(address(this).balance - balance,false,32);
    }
}
