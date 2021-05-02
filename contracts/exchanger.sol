pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;
import "./NFTPair.sol";
import "./NFTAuction.sol";
contract exchanger {
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
    enum PairState {created,index,close}
    uint32 public timestamp;
    bytes public name;
    uint128 public commission;
    uint public highest_commission;
    bool public only_trusted;
    mapping(address => bool) public trusted;
    TvmCell public controller_code;
    TvmCell public pair_code;
    TvmCell public auction_code;
    bool public changableTrusted;
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
    TvmCell _controller_code, TvmCell _pair_code, TvmCell _auction_code, bool _changable_trusted, 
    bool _only_trusted, address[] _trusted, uint64 _time_limit, address _withdraw_address) public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);

        //Set fields
        name = _name;
        commission = _commission;
        highest_commission = _highest_commission;
        controller_code = _controller_code;
        pair_code = _pair_code;
        auction_code = _auction_code;
        changableTrusted = _changable_trusted;
        only_trusted = _only_trusted;
        for (uint256 i = 0; i < _trusted.length; i++) {
            trusted[_trusted[i]] = true;
        }
        time_limit = _time_limit;
        withdraw_address = _withdraw_address;
    }

    //Settings

    function setCommission(uint128 _commission) public onlyOwner {
        require(_commission <= highest_commission, COMISSION_HIGHER_POSSIBLE_COMMISSION);
        commission = _commission;
    }

    function setTrust(bool _only_trust) public onlyOwner {
        require(changableTrusted,TRUST_ISNT_CHANGABLE);
        only_trusted = _only_trust;
    }

    function addTrust(address _root_token) public onlyOwner {
        trusted[_root_token] = true;
    }

    function delTrust(address _root_token) public onlyOwner {
        delete trusted[_root_token];
    }

    function createNFTPairCrystall(uint128 price, uint64 time, uint256 pubkey) public {
        require(msg.value >= 2 ton,NOT_ENOUGH_MONEY);
        require(time <= now + time_limit,TIME_LIMIT);
        address adr = new NFTPair{
    value: 1 ton,
    code: pair_code,
    pubkey: pubkey
}(price,time,msg.sender,pubkey,commission,address(this));
        emit pair_change_status(adr,PairState.created);
        pairs[adr] = PairState.created;

    }

    function createNFTAuctionCrystall(uint128 price, uint64 time, uint128 step , uint256 pubkey) public  {
        require(msg.value >= 2 ton,NOT_ENOUGH_MONEY);
        require(time <= now + time_limit,TIME_LIMIT);
        address adr = new NFTAuction{code:auction_code,value:1.5 ton}(price,time,msg.sender,pubkey,commission,address(this), step);
        emit pair_change_status(adr,PairState.created);
        pairs[adr] = PairState.created;
    }

    function addIndex(PairState status) public{
        pairs.at(msg.sender); // Check address
        emit pair_change_status(msg.sender,status);
        if (status == PairState.close) {
            delete pairs[msg.sender];
        }
        else {
            pairs[msg.sender] = status;
        }
    } 
    function withdraw(uint128 amount) public onlyOwner{
        withdraw_address.transfer(amount,true,0);
    }
}
