pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;
import "./NFTPair.sol";
import "./NFTAuction.sol";
import "./IController.sol";
import "./INFTRoot.sol";
import "./INFT.sol";
contract Controller is BaseContoller{
    // Errors
    uint constant ACCESS_DENIED = 101;
    uint constant NOT_ENOUGH_MONEY = 102;

    uint public client;
    uint public lockedMoney = 0;
    address[] public root_wallets;
    address[] public wallets;
    mapping(address => address) public m_wallets;

    modifier onlyClient {
        require(msg.pubkey() == client,
            ACCESS_DENIED);
        tvm.accept();
        _;
    }

    modifier onlyExchanger {
        require(msg.pubkey() == tvm.pubkey(),
            ACCESS_DENIED);
        tvm.accept();
        _;
    }

    modifier onlyRootWallets {
        require(search(root_wallets,msg.sender),ACCESS_DENIED);
        tvm.accept();
        _;
    }
    

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        client = tvm.pubkey();
    }

    function search(address[] _array, address _wallet) private pure returns (bool){
        for(uint i = 0; i < _array.length; i++) {
            if(_array[i] == _wallet) {
                return true;
            }
        }
        return false;
    }

    function buyNFT(address pair, uint128 price) onlyClient public{
        BasePair(pair).sell{value:price,bounce:true}(client);
    }

    function mintNFT(address rootNFT,bytes metadata) onlyClient public {
        INftRoot(rootNFT).mintNft{value: 2.5 ton}(metadata);
    }
    function transferOwnership(address dataNFT,address addrTo) onlyClient public{
        IData(dataNFT).transferOwnership{value: 1 ton}(addrTo);
    }




    function sendValue(address dest, uint128 amount, bool bounce) onlyClient public {
       dest.transfer(amount, bounce, 0);
    }
    function createNFTPair(address exchanger, uint128 price, uint64 time) onlyClient public {
        BaseExchanger(exchanger).createNFTPairCrystall{value:5 ton,flag:1}(price,time,client);
    }
    function createNFTAuction(address exchanger, uint128 price, uint64 time, uint128 step) onlyClient public {
        BaseExchanger(exchanger).createNFTAuctionCrystall{value:5 ton,flag:1}(price,time,step,client);
    }
    function setCode(TvmCell newcode) public onlyClient {
		tvm.setcode(newcode);
	 	tvm.setCurrentCode(newcode);
	}
}
