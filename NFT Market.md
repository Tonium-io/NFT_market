NFT Market
=======================

The main contract: NFT Exchange


Interfaces:
-----------------------

```javascript
interface NFTRootToken {  
    function constructor (uint8 deployWallet, uint256 pubkey, uint128 tokenId, uint128) public returns (address) {}  
    function getName () public view returns (bytes) {}  
    function getSymbol () public view returns (bytes) {}  
    function getDecimals () public view returns (uint8) {}  
}
```

Structures:
-----------------------

```javascript
struct NFTRootContract {  
    address NFTRootAddr;  
}  
```


Fields:
-----------------------

* name - bytes : name in utf8

* commission - uint : % of commission, changable

* highest_commission - uint : the comission couldnt be higher that field

* only_trusted - bool : parameter to check tvc

* trusted - addr[] : the array with trusted contracts

* controller_code - TvmCell : code of controller contract for user

* pair_code TvmCell : code of pair contract for exchanging

* changableTrusted - Bool : this parameter show, is value trust could be change

* pairs - addr[] : available pairs

* time_limit - uint : check on creating nft pairs, if time in function more then that + now time, disallow to create, it exists to prevent long selling thich can do gas leaking

Metadata:
-----------------------

* getName () view returns (bytes) : The name of stock exchange

* getCommission () view returns (uint) : Return percent of commission thich will be send to method recieve

* getHighestCommission () view returns (uint) :

* getTrustFlag () view returns (bool) : return only_trusted

* getChangableTrusted () view returns (bool) : return changeableTrusted

* getTrusted () view returns (addr[]) : return the list with trusted contracts

* getControllerCode () view returns (TvmCell code) : return controller code

* getPairCode () view returns (TvmCell code) : return pair code

* getAuctionCode () view returns (TvmCell code) : return code of auction

Config fn:
-----------------------

* setName (bytes name) public onlyOwnerAccept : set name in utf8

* setCommission (uint commission) public onlyOwnerAccept : commission should be lower then highest commission

* setTrust (bool onlyTrust) public onlyOwnerAccept : change trust

* addTrust (addr contract) public onlyOwnerAccept : add new address to array trusted => allow to create pair with this addr if the only trusted flag setted true

* delTrust (addr contract) public onlyOwnerAccept : delete address from array trusted


Main fn:
-----------------------

* constructor (bytes name, uint commission, uint highest_commission, TvmCell controller_code, TvmCell pair_code)

* createNFTPairCrystall (address[] root_nft_token_adrs, uint price, uint time) : Should create pair and nft wallet there will be tokens for selling, Should take some crystalls (recomended 10 or 20 crystalls)

* createNFTPairFT (address[] root_nft_token_adrs, address root_ft_token_adr, uint price, uint time) : feature 

* createExcahngeController () : create contract with special code

* createNFTAuctionCrystall (address[] root_nft_token_adrs, uint price, uint time) : Should create auction and nft wallet there will be tokens for selling, Should take some crystalls (recomended 10 or 20 crystalls)

* getAvailablePairs () : add pair to pairs, allow site to check it

Money fn:
-----------------------
* recieve () : Get commission from pairs

* getMoney () : should be over 100 tons on the wallet, send money to setted address, can run only by owner

Errors
-----------------------
* TRUST_ALREADY_EXIST_IN_LIST = 101
* PAIR_ALREADY_DEPLOYED = 102
* TOKEN_DIDNT_IN_TRUST_LIST = 103
* CONTROLLER_ALREADY_DEPLOYED = 104
* YOU_ARE_NOT_GOD = 105 : wrong owner

Controller
=======================
From this contract, user will be do some different thing in exchange service, like buying, selling

Interfaces
-----------------------
NFTToken
FTToken

Structures 
-----------------------
‘’’ javascript
struct Pair {
	uint128 amount,
	address dest,
	bool available 
}’’’

Fields
-----------------------

* client - uint : who control crystall and nft wallet. Can send, buy, sell, receive tokens and crystall


Metadata
-----------------------
None, maybe we can add some info about history but now its mvp

Pairs Function
-----------------------
* constructor(uint public_key) 
* getMoney() : get money for trading pair, could be used by pair

* freezeMoney(address pairid, uint128 price) : freeze money for auction, could be used only by user, send request to Auction, getBet

* buyNFT(address pairid) : send crystall for buying nft token

* sendNFTToken(address nft_root_token, address reciever) : send nft token to reciever

* send(address dest, uint128 value, bool bounce) : withdraw crystall from wallet, should stay on wallet freeze money and some for commission

* receive () : get money

Errors
-----------------------
* NOT_ENOUGH_MONEY = 101
* PAIR_DIDNT_EXIST = 102
* WALLET_HADNT_DEPLOYED = 103

Pair 
=======================
This is abstract class from which will be create NFTPair, NFTAuction and some other

Interfaces
-----------------------
NFTToken
FTToken

Errors
-----------------------
* TIME_FINISHED = 101
* TIME_FINISHED_NOT_YET = 102
* WALLET_ALREADY_DEPLOYED = 103
* TOKENS_HADNT_RECEIVED = 104

Structures 
-----------------------
* enum NFTPairTypes {CrystallAuction, FTAuction, CrystallPair, FTPair}

Fields
-----------------------
* seller - addr : the address from will be get nft token and will be send tokens for selling
* exchanger - addr : the address of main contract exchanger
* description - bytes : description about lot in pair
* wallets - addr[] : array with nft wallets
* opened - bool : the field that show, is it available to sell 
* type - NFTPairTypes : show what’s methods exchange need to use 
* receiver - addr : how will get ability to withdraw tokens
* time - uint128 : finish time
Metadata 
-----------------------
* getDescription () view returns (bytes) {}
* getType () view returns (NFTPairTypes) {} 

Pair Function
-----------------------
* createNFTWallet (address root_token) : can use only by seller, create nft wallet on root_token and write address in array wallets
* approveSell () : check in wallets available of any nft tokens and do pair opened, send information about it on exchange
* checkTime () : if time more then it set by seller, return tokens to contract of seller and destroy contract

NFTPair (Pair) 
=======================
This is pair, which change crystall to nft token

Fields
-----------------------
* price - uint128 : amount which seller want to get without commission
* commission - uint8 : how much contract will be sent to exchanger

NFTPair Fn
-----------------------
* constructor (address[] wallets, uint128 price, uint time, address seller, uint8 commission) : should get some tokens for commission, deploy nft token and wait for tokens
* sell (address receiver) : check amount of crystall >= price, send tokens to receiver, send commission to exchanger, send money to controller owned by seller and destroy contract

NFTAuction (Pair)
=======================
This is auction, which allow seller sell like on auction

Fields
-----------------------
* receiver - addr : the latest buyer
* step - uint128 : how many crystall one bet should be different from another bet
* price - uint128 : the latest price to buy

Metadata 
-----------------------
* getPrice () view returns (uint128)
* getStep () view returns (uint128)
* getReceiver () view returns (addr)

NFTAuction Fn
-----------------------
* constructor(address[] wallets, uint128 price,uint128 step, uint time, address seller, uint8 commission) 
* getBet (uint128 value) : value >= price + step, send info to receiver on unfreezing and set new receiver
