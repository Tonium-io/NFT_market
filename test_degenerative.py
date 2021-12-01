import tonos_ts4.ts4 as ts4
import unittest
import time

EXCHANGER_COMMISSION = 3

class key:
    secret: str
    public: str
class TestPair(unittest.TestCase):
    secret = "bc891ad1f7dc0705db795a81761cf7ea0b74c9c2a93cbf9ac1bad8bd30c9b3b75a4889716084010dd2d013e48b366424c8ba9d391c867e46adce51b18718eb67"
    public = "0x5a4889716084010dd2d013e48b366424c8ba9d391c867e46adce51b18718eb67"

    def test_exchanger(self):
        ts4.reset_all() # reset all data
        ts4.init('contracts', verbose = True)
        key1 = ts4.make_keypair()
        self.public1 = key1[1]
        self.secret1 = key1[0]
        # Prepare controllers 
        Controller0 = ts4.BaseContract('Controller',dict(),pubkey=self.public,private_key=self.secret,balance=150_000_000_000,nickname="Controller0")
        Controller1 = ts4.BaseContract('Controller',dict(),pubkey=self.public1,private_key=self.secret1,balance=150_000_000_000,nickname="Controller1") 
        
        data = ts4.load_data_cell('NFTPair.tvc')
        ts4.init('true-nft/components/true-nft-core/build', verbose = True)
        deGenerateContract = ts4.BaseContract('uploadDeGenerative',dict(),pubkey=self.public1,private_key=self.secret1,balance=150_000_000_000,nickname="Controller1") 
        codeIndex = ts4.load_code_cell('Index.tvc')
        codeData = ts4.load_code_cell('Data.tvc')
        constructor = {
            "codeIndex":codeIndex,
            "codeData":codeData,
            "pay":1_000_000_000,
            "koef": 150
        }
        # Create root token
        NFTtoken = ts4.BaseContract('NftRoot',constructor,pubkey=self.public,private_key=self.secret,nickname="NFT root token",initial_data=dict(_addrOwner=deGenerateContract.addr,_name=ts4.Bytes("5423"))) 

        ts4.dispatch_messages()
        # deGenerate
        deGenerateContract.call_method_signed("sendMetadata",dict(adr=NFTtoken.addr,metadata=ts4.Bytes("1234")))
        ts4.dispatch_messages()
        # Mint token for granting
        Controller0.call_method("generateNFT",dict(metadata=ts4.Bytes("5423"),rootNFT=NFTtoken.addr,value=1_500_000_000),private_key=self.secret)
        ts4.dispatch_messages()
        Controller0.call_method("generateNFT",dict(metadata=ts4.Bytes("5423"),rootNFT=NFTtoken.addr,value=2_000_000_000),private_key=self.secret)
        # NFTtoken.call_method('mintNft',dict(metadata=ts4.Bytes("1234")),private_key=self.secret) 

        ts4.dispatch_messages()
        print(NFTtoken.address)
        # Deploy nft wallet for controllers
        ts4.dispatch_messages()
        
        ts4.init('contracts', verbose = True)
        # Create exchanger
        Exchanger = ts4.BaseContract('Exchanger', dict(_name=ts4.Bytes("5423"),_commission=EXCHANGER_COMMISSION,_highest_commission=EXCHANGER_COMMISSION,_pair_code=ts4.load_code_cell('NFTPair.tvc'),_auction_code=ts4.load_code_cell("NFTAuction.tvc"),
        _time_limit=60 * 60 * 48, _withdraw_address=ts4.Address("-1:7777777777777777777777777777777777777777777777777777777777777777")),pubkey=self.public,private_key=self.secret,nickname="Exchanger")
        ts4.dispatch_messages()
        _time = int(time.time()) + 1000
        Controller0.call_method("createNFTPair",dict(exchanger=Exchanger.addr,price=1_000_000_000,time=_time),private_key=self.secret)
        ts4.dispatch_messages()
        a = list(Exchanger.call_getter("pairs"))[0]
        ts4.ensure_address(a)
        pair = ts4.BaseContract('NFTPair',dict(_price=1_000_000_000,_time=_time,_seller=Controller0.address,_seller_pubkey=self.public,_commission=EXCHANGER_COMMISSION,_exchanger_address=Exchanger.address),pubkey=self.public,address=a,nickname="Pair")
        ts4.dispatch_messages()
        test = Exchanger.call_getter("resolveNFTPair",dict(price=1_000_000_000,time=_time,client=Controller0.address,pubkey=self.public))
        print("ResolveNFTPair",test)
        # Get token addr
        num = NFTtoken.call_getter("_totalMinted",dict())
        print(num)
        addr = NFTtoken.call_getter("resolveData",dict(addrRoot=NFTtoken.addr,id=num - 1,name=ts4.Bytes("5423")))
        print(addr)
        # Send token to pair
        Controller0.call_method("transferOwnership",dict(dataNFT=addr,addrTo=pair.addr),private_key=self.secret)
        ts4.dispatch_messages()
        pair.call_method("addNewToken",dict(token_addr=addr),private_key=self.secret)
        # Approve sell
        pair.call_method("approveSell",private_key=self.secret)
        ts4.dispatch_messages()
        # Buy token
        Controller1.call_method("buyNFT",dict(pair=pair.addr,price=1_000_000_000),private_key=self.secret1)
        ts4.dispatch_messages()
        # Check balance
        ts4.init('NFT_Token', verbose = True)

        # Withdraw from exchanger
        Exchanger.call_method("withdraw",dict(amount=100),private_key=self.secret)
        ts4.dispatch_messages()

        

if __name__ == '__main__':
    unittest.main()
