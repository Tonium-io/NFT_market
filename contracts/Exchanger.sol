pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;
import "./NFTPair.sol";
import "./NFTAuction.sol";
import "./IExchanger.sol";
contract exchanger is BaseExchanger {
    //Events
    event pair_change_status(address indexed pair,PairState status);

    //Errors
    uint constant TRUST_ALREADY_EXIST_IN_LIST = 101;
    uint constant PAIR_ALREADY_DEPLOYED = 102;
    uint constant TOKEN_DIDNT_IN_TRUST_LIST = 103;
    uint constant CONTROLLER_ALREADY_DEPLOYED = 104;
    uint constant YOU_ARE_NOT_GOD = 105;
    uint constant COMISSION_HIGHER_POSSIBLE_COMMISSION = 106;
    uint constant TRUST_ISNT_CHANGABLE = 107;
    uint constant NOT_ENOUGH_MONEY = 108;
    uint constant TIME_LIMIT = 109;

    //Fields
    uint32 public timestamp;
    bytes public name;
    uint128 public commission;
    uint public highest_commission;
    TvmCell public pair_code;
    TvmCell public auction_code;
    mapping(address => PairState) public pairs;
    uint64 public time_limit;
    address public withdraw_address;

    modifier onlyOwner {
        require(msg.pubkey() == tvm.pubkey(),
            YOU_ARE_NOT_GOD);
        tvm.accept();
        _;
    }

    constructor(bytes _name,uint128 _commission, uint128 _highest_commission, 
    TvmCell _pair_code, TvmCell _auction_code,
    uint64 _time_limit, address _withdraw_address) public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        //Set fields
        name = _name;
        commission = _commission;
        highest_commission = _highest_commission;
        pair_code = _pair_code;
        auction_code = _auction_code;
        time_limit = _time_limit;
        withdraw_address = _withdraw_address;
    }

    //Settings

    function setCommission(uint128 _commission) public override onlyOwner {
        require(_commission <= highest_commission, COMISSION_HIGHER_POSSIBLE_COMMISSION);
        commission = _commission;
    }


    function createNFTPairCrystall(uint128 price, uint64 time, address client, uint256 pubkey) override public {
        require(msg.value >= 5 ton,NOT_ENOUGH_MONEY);
        require(time <= now + time_limit,TIME_LIMIT);
        address adr = new NFTPair{value: 4 ton, code: pair_code, pubkey: pubkey, varInit: {finish_time: time,seller:client,seller_pubkey:pubkey,commission:commission, exchanger: address(this), price:price}
        }();
        emit pair_change_status(adr,PairState.created);
        pairs[adr] = PairState.created;

    }

    function createNFTAuctionCrystall(uint128 price, uint64 time, uint128 step, address client, uint256 pubkey) override public  {
        require(msg.value >= 2 ton,NOT_ENOUGH_MONEY);
        require(time <= now + time_limit,TIME_LIMIT);
        address adr = new NFTAuction{code:auction_code,value:1.5 ton, pubkey: pubkey,varInit: {finish_time: time,seller:client,seller_pubkey:pubkey,commission:commission, exchanger: address(this),price:price,step:step}}();
        emit pair_change_status(adr,PairState.created);
        pairs[adr] = PairState.created;
    }

    function addIndex(PairState status) override public{
        require(pairs[msg.sender] != PairState.not_exist,YOU_ARE_NOT_GOD); // Check address
        emit pair_change_status(msg.sender,status);
        if (status == PairState.close) {
            delete pairs[msg.sender];
        }
        else {
            pairs[msg.sender] = status;
        }
    } 
    function withdraw(uint128 amount) override public onlyOwner{
        withdraw_address.transfer(amount,true,0);
    }
}
