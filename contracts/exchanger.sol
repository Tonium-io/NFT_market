pragma ton-solidity >= 0.35.0;
//pragma AbiHeader expire;
import "./ArrayHelper.sol";
// This is class that describes you smart contract.
contract exchanger {
    // Contract can have an instance variables.
    // In this example instance variable `timestamp` is used to store the time of `constructor` or `touch`
    // function call

    //Errors
    uint constant TRUST_ALREADY_EXIST_IN_LIST = 101;
    uint constant PAIR_ALREADY_DEPLOYED = 102;
    uint constant TOKEN_DIDNT_IN_TRUST_LIST = 103;
    uint constant CONTROLLER_ALREADY_DEPLOYED = 104;
    uint constant YOU_ARE_NOT_GOD = 105;
    uint constant COMISSION_HIGHER_POSSIBLE_COMMISSION = 106;
    uint constant TRUST_ISNT_CHANGABLE = 107;

    //Fields
    uint32 public timestamp;
    bytes public name;
    uint public commission;
    uint public highest_commission;
    bool public only_trusted;
    mapping(address => bool) public trusted;
    TvmCell public controller_code;
    TvmCell public pair_code;
    TvmCell public auction_code;
    bool public changableTrusted;
    address[] public pairs;
    uint32 public time_limit;
    address public withdraw_address;

    modifier onlyOwner {
        require(msg.pubkey() == tvm.pubkey(),
            YOU_ARE_NOT_GOD);
        tvm.accept();
        _;
    }

    constructor(bytes _name,uint _commission, uint _highest_commission, 
    TvmCell _controller_code, TvmCell _pair_code, TvmCell _auction_code, bool _changable_trusted, 
    bool _only_trusted, address[] _trusted, uint32 _time_limit, address _withdraw_address) public {
        // Check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and
        // message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        // The current smart contract agrees to buy some gas to finish the
        // current transaction. This actions required to process external
        // messages, which bring no value (henceno gas) with themselves.

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

    function setCommission(uint _commission) public onlyOwner {
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



    

    function renderHelloWorld () public pure returns (string) {
        return 'helloWorld';
    }

    // Updates variable `timestamp` with current blockchain time.
    function touch() external {
        // Each function that accepts external message must check that
        // message is correctly signed.
        require(msg.pubkey() == tvm.pubkey(), 102);
        // Tells to the TVM that we accept this message.
        tvm.accept();
        // Update timestamp
        timestamp = now;
    }

    function sendValue(address dest, uint128 amount, bool bounce) public {
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        // It allows to make a transfer with arbitrary settings
        dest.transfer(amount, bounce, 0);
    }
}
