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
    # Legacy code
    # def test_nft(self):
    #     ts4.reset_all() # reset all data
    #     ts4.init('NFT_token', verbose = True)

    #     code = ts4.load_code_cell('TONTokenWalletNF.tvc')
    #     constructor = {
    #         "name":ts4.Bytes("5423"),
    #         "symbol":ts4.Bytes("5423"),
    #         "tokenURI":ts4.Bytes("5423"),
    #         "decimals":0,
    #         "root_public_key":self.public,
    #         "wallet_code":code
    #     }

    #     NFTtoken = ts4.BaseContract('RootTokenContractNF',constructor,pubkey=self.public,private_key=self.secret) # create root token
    #     NFTtoken.call_method('mint',dict(tokenId=1),private_key=self.secret) # mint token
        
    #     NFTwallet = NFTtoken.call_method('deployWallet',dict(workchain_id=0,pubkey=self.public,grams=1_000_000_000,tokenId=0, nonce=ts4.Address("0:0000000000000000000000000000000000000000000000000000000000000000")),private_key=self.secret) # Deploy wallet
    #     NFTwallet0 = NFTtoken.call_method('deployWallet',dict(workchain_id=0,pubkey=self.public,grams=1_000_000_000,tokenId=0, nonce=ts4.Address("-1:0000000000000000000000000000000000000000000000000000000000000000")),private_key=self.secret) # Deploy another wallet
    #     ts4.dispatch_messages()

    #     NFTtoken.call_method('grant',dict(dest=NFTwallet,tokenId=1,grams=1_000_000_000),private_key=self.secret) # give first wallet token
        
    #     ts4.dispatch_messages()

    #     self.assertNotEqual(NFTwallet0,NFTwallet) # check if they not equal

    #     ts4.ensure_address(NFTwallet) # Register address
    #     ts4.ensure_address(NFTwallet0)
        
    #     NFTWallet = ts4.BaseContract('TONTokenWalletNF', {} ,  address = NFTwallet)
    #     NFTWallet0 = ts4.BaseContract('TONTokenWalletNF', {} ,  address = NFTwallet0)

    #     self.assertTrue(NFTWallet.call_getter("getBalance")) # check empty balance
    #     self.assertFalse(NFTWallet0.call_getter("getBalance")) # check not empty balance
    #     print(NFTWallet0.call_getter("getNonce",{}))
    #     #self.assertEqual(NFTtoken.call_getter("getWalletAddress",dict(workchain_id=0,pubkey=self.public,nonce=NFTWallet0.call_getter("getNonce",{}))), NFTwallet0) # Check getWalletAddress function

    #     NFTWallet.call_method('transfer',dict(dest=NFTwallet0,tokenId=1,grams=1_000_000_000),private_key=self.secret)
    #     ts4.dispatch_messages()

    #     self.assertFalse(NFTWallet.call_getter("getBalance")) # check empty balance
    #     self.assertTrue(NFTWallet0.call_getter("getBalance")) # check not empty balance
        
    #     self.assertEqual(NFTWallet0.call_getter("getTokenByIndex",{"index":0}),1)
    
    # def test_controller_nft_pair(self):
    #     #NFT Pair
    #     ts4.reset_all() # reset all data
    #     ts4.init('contracts', verbose = True)
    #     key1 = ts4.make_keypair()
    #     self.public1 = key1[1]
    #     self.secret1 = key1[0]
    #     Controller0 = ts4.BaseContract('Controller',dict(public_key=self.public),pubkey=self.public,private_key=self.secret,balance=150_000_000_000) # create root token
    #     Controller1 = ts4.BaseContract('Controller',dict(public_key=self.public1),pubkey=self.public1,private_key=self.secret1,balance=150_000_000_000) # create root token
        
    #     ts4.init('NFT_token', verbose = True)
    #     code = ts4.load_code_cell('TONTokenWalletNF.tvc')
    #     constructor = {
    #         "name":ts4.Bytes("5423"),
    #         "symbol":ts4.Bytes("5423"),
    #         "tokenURI":ts4.Bytes("5423"),
    #         "decimals":0,
    #         "root_public_key":self.public,
    #         "wallet_code":code
    #     }

    #     NFTtoken = ts4.BaseContract('RootTokenContractNF',constructor,pubkey=self.public,private_key=self.secret) # create root token
    #     #NFTwallet = NFTtoken.call_method('deployWallet',dict(workchain_id=0,pubkey=self.public,grams=1_000_000_000,tokenId=0, wallet=Controller0.addr()),private_key=self.secret) # Deploy wallet
    #     ts4.dispatch_messages()
    #     NFTtoken.call_method('mint',dict(tokenId=1),private_key=self.secret) # mint token

    #     ts4.dispatch_messages()
    #     print(NFTtoken.address())
    #     Controller0.call_method('deployNFT',dict(root_token=NFTtoken.address()),private_key=self.secret)
    #     Controller1.call_method('deployNFT',dict(root_token=NFTtoken.address()),private_key=self.secret1)
    #     ts4.dispatch_messages()
    #     ts4.init('contracts', verbose = True)
    #     Pair = ts4.BaseContract('NFTPair', dict( _price = 100_000_000_000, _time=int(time.time()) + 100, _seller=Controller0.addr(), _seller_pubkey = self.public, _commission=3,_exchanger_address=ts4.Address("-1:7777777777777777777777777777777777777777777777777777777777777777")),pubkey=self.public,private_key=self.secret)
        
    #     #Create nft wallet
    #     a = Pair.call_method('createNFTWallet',{'root_token':NFTtoken.addr()},private_key=self.secret)
    #     ts4.dispatch_messages()
    #     q = Pair.call_getter('wallets')[0]
    #     ts4.init('NFT_token', verbose = True)
    #     wallet_pair = ts4.BaseContract('TONTokenWalletNF', {} ,  address = q)
    #     NFTtoken.call_method('grant',dict(dest=wallet_pair.addr(),tokenId=1,grams=0),private_key=self.secret) # give first wallet token
    #     ts4.dispatch_messages()
    #     ts4.core.set_now(int(time.time()) + 100)
    #     #wallet_pair.call_method('transfer',dict(dest=Controller1.call_getter("wallets")[0],tokenId=1,grams=0),private_key=self.secret)
    #     #time.sleep(7)
    #     ts4.core.set_now(int(time.time()) + 1050)
    #     ts4.dispatch_messages()
    #     Pair.call_method('approveSell',private_key=self.secret)
    #     # print(ts4.get_balance(wallet_pair.addr))
    #     #wallet_pair.call_method('transfer',dict(dest=Controller1.addr(),tokenId=1,grams=0),private_key=self.secret)
    #     ts4.dispatch_messages()
    #     #wallet_pair
    #     #time.sleep(7)
    #     ts4.core.set_now(int(time.time()) + 2000)
    #     ts4.dispatch_messages()
    #     print(Pair.call_getter("status"))
    #     print(Pair.call_getter("wallets"))
    #     print(Pair.call_getter("receiver_pubkey"))
    #     print(Pair.call_getter("tokenIdStorage"))
    #     print(wallet_pair.call_getter("getBalance"))
    #     print(wallet_pair.call_getter("getTokenByIndex",{"index":0}))
    #     print("AA")
    #     # Controller1.call_method('buyNFT',dict(pair=Pair.addr(),price=100_000_000_000),private_key=self.secret1)
    #     # ts4.dump_queue()
    #     # ts4.dispatch_messages()
    #     # controller1_pair = ts4.BaseContract('TONTokenWalletNF', {} ,  address = Controller1.call_getter("wallets")[0])
    #     # ts4.dispatch_messages()
    #     # print(controller1_pair.call_getter("getBalance"))
    #     # print(Controller0.addr())
    #     # print(Controller0.balance())
    #     # print(Pair.balance())
    
    # def test_controller_nft_auction(self):
    #     #NFT Pair
    #     ts4.reset_all() # reset all data
    #     ts4.init('contracts', verbose = True)
    #     key1 = ts4.make_keypair()
    #     self.public1 = key1[1]
    #     self.secret1 = key1[0]
    #     Controller0 = ts4.BaseContract('Controller',dict(),pubkey=self.public,private_key=self.secret,balance=250_000_000_000) # create root token
    #     Controller1 = ts4.BaseContract('Controller',dict(),pubkey=self.public1,private_key=self.secret1,balance=250_000_000_000) # create root token
        
    #     ts4.init('NFT_token', verbose = True)
    #     code = ts4.load_code_cell('TONTokenWalletNF.tvc')
    #     constructor = {
    #         "name":ts4.Bytes("5423"),
    #         "symbol":ts4.Bytes("5423"),
    #         "tokenURI":ts4.Bytes("5423"),
    #         "decimals":0,
    #         "root_public_key":self.public,
    #         "wallet_code":code
    #     }

    #     NFTtoken = ts4.BaseContract('RootTokenContractNF',constructor,pubkey=self.public,private_key=self.secret) # create root token
    #     constructor = {
    #         "name":ts4.Bytes("5423"),
    #         "symbol":ts4.Bytes("5423"),
    #         "tokenURI":ts4.Bytes("5423"),
    #         "decimals":0,
    #         "root_public_key":self.public1,
    #         "wallet_code":code
    #     }
    #     NFTtoken1 = ts4.BaseContract('RootTokenContractNF',constructor,pubkey=self.public,private_key=self.secret) # create root token
    #     print(NFTtoken.addr,NFTtoken1.addr)
    #     #print(NFTtoken.call_getter("getWalletAddress",dict(workchain_id=0,pubkey=self.public,nonce=ts4.Address("0:7777777777777777777777777777777777777777777777777777777777777777"))))
    #     #NFTwallet = NFTtoken.call_method('deployWallet',dict(workchain_id=0,pubkey=self.public,grams=1_000_000_000,tokenId=0, wallet=Controller0.addr()),private_key=self.secret) # Deploy wallet
    #     ts4.dispatch_messages()
    #     NFTtoken.call_method('mint',dict(tokenId=1,name=ts4.Bytes("5423"),type=0,data=ts4.Bytes("5423")),private_key=self.secret) # mint token

    #     ts4.dispatch_messages()
    #     print(NFTtoken.address)
    #     Controller0.call_method('deployNFT',dict(root_token=NFTtoken.address),private_key=self.secret)
    #     Controller1.call_method('deployNFT',dict(root_token=NFTtoken.address),private_key=self.secret1)
    #     ts4.dispatch_messages()
    #     ts4.init('contracts', verbose = True)
    #     Pair = ts4.BaseContract('NFTAuction', dict(),pubkey=self.public,private_key=self.secret)
    #     ts4.dispatch_messages()
    #     #Create nft wallet
    #     print(Pair.call_getter("finish_time"))
    #     a = Pair.call_method('createNFTWallet',{'root_token':NFTtoken.addr},private_key=self.secret)
    #     ts4.dispatch_messages()
    #     q = Pair.call_getter('wallets')[0]
    #     ts4.init('NFT_token', verbose = True)
    #     wallet_pair = ts4.BaseContract('TONTokenWalletNF', {} ,  address = q)
    #     NFTtoken.call_method('grant',dict(dest=wallet_pair.addr,tokenId=1,grams=0),private_key=self.secret) # give first wallet token
    #     ts4.dispatch_messages()
    #     #wallet_pair.call_method('transfer',dict(dest=Controller1.call_getter("wallets")[0],tokenId=1,grams=0),private_key=self.secret)
    #     #time.sleep(7)
    #     ts4.dispatch_messages()
    #     Pair.call_method('approveSell',private_key=self.secret)
    #     # print(ts4.get_balance(wallet_pair.addr))
    #     #wallet_pair.call_method('transfer',dict(dest=Controller1.addr(),tokenId=1,grams=0),private_key=self.secret)
    #     ts4.dispatch_messages()
    #     #wallet_pair
    #     #time.sleep(7)
    #     controller1_pair = ts4.BaseContract('TONTokenWalletNF', {} ,  address = Controller1.call_getter("wallets")[0])
    #     ts4.dispatch_messages()
    #     Controller1.call_method('buyNFT',dict(pair=Pair.addr,price=105_000_000_000),private_key=self.secret1)
    #     ts4.dispatch_messages()
    #     print(contrsellerbalance)
    #     ts4.core.set_now(int(time.time()) + 2000)
    #     Pair.call_method('finish')
    #     ts4.dispatch_messages()
    #     print(controller1_pair.call_getter("getBalance"))
    #     print(Controller0.addr)
    #     print(Controller0.balance)
    #     print(Pair.balance)

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
        ts4.init('NFT_token', verbose = True)
        code = ts4.load_code_cell('TONTokenWalletNF.tvc')
        constructor = {
            "name":ts4.Bytes("5423"),
            "symbol":ts4.Bytes("5423"),
            "tokenURI":ts4.Bytes("5423"),
            "decimals":0,
            "root_public_key":self.public,
            "wallet_code":code
        }
        # Create root token
        NFTtoken = ts4.BaseContract('RootTokenContractNF',constructor,pubkey=self.public,private_key=self.secret,nickname="NFT root token") 

        ts4.dispatch_messages()
        # Mint token for granting
        NFTtoken.call_method('mint',dict(tokenId=1,name=ts4.Bytes("5423"),type=0,data=ts4.Bytes("5423")),private_key=self.secret) 

        ts4.dispatch_messages()
        print(NFTtoken.address)
        # Deploy nft wallet for controllers
        Controller0.call_method('deployNFT',dict(root_token=NFTtoken.address),private_key=self.secret)
        Controller1.call_method('deployNFT',dict(root_token=NFTtoken.address),private_key=self.secret1)
        ts4.dispatch_messages()
        NFTwallet1 = ts4.BaseContract("TONTokenWalletNF",{},address=ts4.Address(Controller1.call_getter("m_wallets")[NFTtoken.addr].addr_))
        print(NFTwallet1.call_getter("getBalance"))
        
        ts4.init('contracts', verbose = True)
        # Create exchanger
        Exchanger = ts4.BaseContract('Exchanger', dict(_name=ts4.Bytes("5423"),_commission=EXCHANGER_COMMISSION,_highest_commission=EXCHANGER_COMMISSION,_pair_code=ts4.load_code_cell('NFTPair.tvc'),_auction_code=ts4.load_code_cell("NFTAuction.tvc"),
        _time_limit=60 * 60 * 48, _withdraw_address=ts4.Address("-1:7777777777777777777777777777777777777777777777777777777777777777")),pubkey=self.public,private_key=self.secret,nickname="Exchanger")
        ts4.dispatch_messages()
        _time = int(time.time()) + 1000
        # Create pair for controller0
        Controller0.call_method("createNFTPair",dict(exchanger=Exchanger.addr,price=1_000_000_000,time=_time),private_key=self.secret)
        ts4.dispatch_messages()
        # Grant token to controller0

        NFTtoken.call_method('grant',dict(dest=Controller0.call_getter("m_wallets")[NFTtoken.addr],tokenId=1,grams=0),private_key=self.secret) # give first wallet token
        ts4.dispatch_messages()
        a = list(Exchanger.call_getter("pairs"))[0]
        ts4.ensure_address(a)
        # Wrap nft pair
        pair = ts4.BaseContract('NFTPair',dict(_price=1_000_000_000,_time=_time,_seller=Controller0.address,_seller_pubkey=self.public,_commission=EXCHANGER_COMMISSION,_exchanger_address=Exchanger.address),pubkey=self.public,address=a,nickname="Pair")
        ts4.dispatch_messages()
        # Create nft wallet on pair
        pair.call_method("createNFTWallet",dict(root_token=NFTtoken.addr),private_key=self.secret)
        ts4.dispatch_messages()
        # Send token to pair
        Controller0.call_method("sendNFTToken",dict(wallet=Controller0.call_getter("m_wallets")[NFTtoken.addr],dest=pair.call_getter("m_wallets")[NFTtoken.addr],tokenId=1),private_key=self.secret)
        ts4.dispatch_messages()
        # Approve sell
        pair.call_method("approveSell",private_key=self.secret)
        ts4.dispatch_messages()
        # Buy token
        Controller1.call_method("buyNFT",dict(pair=pair.addr,price=1_000_000_000),private_key=self.secret1)
        ts4.dispatch_messages()
        # Check balance
        ts4.init('NFT_token', verbose = True)

        # Withdraw from exchanger
        Exchanger.call_method("withdraw",dict(amount=100),private_key=self.secret)
        ts4.dispatch_messages()

    # def test_nftpair(self):
    #     ts4.reset_all()
    #     ts4.init('NFT_token', verbose = True)
    #     eq = ts4.eq
        
    #     #Create NFT Root Token
    #     code = ts4.load_code_cell('TONTokenWalletNF.tvc')
    #     constructor = {
    #         "name":ts4.Bytes("5423"),
    #         "symbol":ts4.Bytes("5423"),
    #         "decimals":0,
    #         "root_public_key":self.public,
    #         "wallet_code":code
    #     }

    #     NFTtoken = ts4.BaseContract('RootTokenContractNF',constructor,pubkey=self.public,private_key=self.secret)
    #     ts4.init('contracts', verbose = True)
    #     constructor = {
    #         "_price":100,
    #         "_time":int(time.time()) + 60,
    #         "_seller":"0:e22c099e0db536c4b1e129c690921c28947fc0add71b43bae23709254e457bda",
    #         "_commission":20,
    #     }
    #     Pair = ts4.BaseContract('NFTPair', constructor,pubkey=self.public,private_key=self.secret)
    #     Pair.call_method('createNFTWallet',{'root_token':NFTtoken.addr()},private_key=self.secret)
    #     Pair.call_method('approveSell',{},private_key=self.secret)
        

if __name__ == '__main__':
    unittest.main()
