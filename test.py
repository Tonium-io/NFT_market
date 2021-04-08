import tonos_ts4.ts4 as ts4
import unittest
import time

class TestPair(unittest.TestCase):
    eq = ts4.eq

    secret = "bc891ad1f7dc0705db795a81761cf7ea0b74c9c2a93cbf9ac1bad8bd30c9b3b75a4889716084010dd2d013e48b366424c8ba9d391c867e46adce51b18718eb67"
    public = "0x5a4889716084010dd2d013e48b366424c8ba9d391c867e46adce51b18718eb67"
    ts4.init('NFT_token', verbose = True)
    code = ts4.load_code_cell('TONTokenWalletNF.tvc')
    constructor = {
        "name":ts4.Bytes("5423"),
        "symbol":ts4.Bytes("5423"),
        "decimals":0,
        "root_public_key":public,
        "wallet_code":code
    }
    #Create NFT Root Token
    NFTtoken = ts4.BaseContract('RootTokenContractNF',constructor,pubkey=public,private_key=secret)

    ts4.init('contracts', verbose = True)
    Pair = ts4.BaseContract('Pair', {},pubkey=public,private_key=secret)
    print(NFTtoken.addr())
    #Create pair for 
    a = Pair.call_method('createNFTWallet',{'root_token':NFTtoken.addr()},private_key=secret)
    print(a)

    #WalletNFT = NFTtoken.call_method('deployWallet',dict(workchain_id=0,pubkey=public,tokenId=0,grams=0),private_key=secret)

    print("AAA")
    print(Pair.call_getter('wallets'))

    addr = NFTtoken.call_getter("getWalletAddress",{"workchain_id":0,"pubkey":public})
    print(addr)
    print(Pair.call_getter("getPubKey",{}))
    ts4.ensure_address(addr)
    ts4.dispatch_messages()
    ts4.init('/home/user/repositories/NFT_Market/NFT_token', verbose = True)
    contract2 = ts4.BaseContract('TONTokenWalletNF', {} ,  address = addr)

    print(ts4.get_balance(addr))