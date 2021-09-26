from tonclient.client import TonClient
import base64
import json
import time
from tonclient.errors import TonException
from tonclient.test.test_abi import SAMPLES_DIR
from tonclient.test.helpers import send_grams
from tonclient.types import Abi, DeploySet, CallSet, Signer, FunctionHeader, \
    ParamsOfEncodeMessage, ParamsOfProcessMessage, ProcessingResponseType, \
    ProcessingEvent, ParamsOfSendMessage, ParamsOfWaitForTransaction, ClientConfig, BuilderOp, NetworkConfig, ParamsOfRunGet, ParamsOfQuery, ParamsOfGetCodeFromTvc


client = TonClient(config=ClientConfig(network=NetworkConfig(server_address='https://net.ton.dev')))





def send_grams(address: str):
    giver_abi = Abi.from_path(
        path='grant.abi.json')
    call_set = CallSet(
        function_name='grant', input={'addr': address})
    encode_params = ParamsOfEncodeMessage(
        abi=giver_abi, signer=Signer.NoSigner(), address="0:653b9a6452c7a982c6dc92b2da9eba832ade1c467699ebb3b43dca6d77b780dd",
        call_set=call_set)
    process_params = ParamsOfProcessMessage(
        message_encode_params=encode_params, send_events=False)
    client.processing.process_message(params=process_params)

keypair_exchanger = client.crypto.generate_random_sign_keys()
keypair_controller1 = client.crypto.generate_random_sign_keys()
keypair_controller2 = client.crypto.generate_random_sign_keys()
keypair_NFTowner = client.crypto.generate_random_sign_keys()

exchanger_abi = Abi.from_path(
            path='contracts/Exchanger.abi.json')

controller_abi = Abi.from_path(
            path='contracts/Controller.abi.json')

nftpair_abi = Abi.from_path(
            path='contracts/NFTPair.abi.json')
nftauction_abi = Abi.from_path(
            path='contracts/NFTAuction.abi.json')

roottoken_abi = Abi.from_path(
           path='true-nft/components/true-nft-core/build/NftRoot.abi.json')
#tonwallet_abi = Abi.from_path(
#            path='NFT_token/TONTokenWalletNF.abi.json')

#with open('NFT_token/TONTokenWalletNF.tvc', 'rb') as fp:     
##    tonwallet_code =  base64.b64encode(fp.read()).decode()
with open('contracts/NFTPair.tvc', 'rb') as fp:     
    nftPair_code =  base64.b64encode(fp.read()).decode()
with open('contracts/NFTAuction.tvc', 'rb') as fp:     
    nftauction_code =  base64.b64encode(fp.read()).decode()
with open('./true-nft/components/true-nft-core/build/Index.tvc', 'rb') as fp:     
    codeIndex =  client.boc.get_code_from_tvc(
            params=ParamsOfGetCodeFromTvc(tvc=base64.b64encode(fp.read()).decode()))
with open('./true-nft/components/true-nft-core/build/Data.tvc', 'rb') as fp:     
    codeData =  client.boc.get_code_from_tvc(
            params=ParamsOfGetCodeFromTvc(tvc=base64.b64encode(fp.read()).decode()))
with open('contracts/Exchanger.tvc', 'rb') as fp:     
    deploy_set_exchanger = DeploySet(tvc=base64.b64encode(fp.read()).decode())

with open('contracts/Controller.tvc', 'rb') as fp:     
    deploy_set_controller = DeploySet(tvc=base64.b64encode(fp.read()).decode())



# Deploy Controller1
call_set = CallSet(
            function_name='constructor',
            header=FunctionHeader(pubkey=keypair_controller1.public))
encode_params = ParamsOfEncodeMessage(
            abi=controller_abi, signer=Signer.Keys(keypair_controller1), deploy_set=deploy_set_controller,
            call_set=call_set)
encoded = client.abi.encode_message(params=encode_params)
controller1 = encoded.address
send_grams(address=controller1)
process_params = ParamsOfProcessMessage(
    message_encode_params=encode_params, send_events=False)
result = client.processing.process_message(
    params=process_params)
print("Controller1:",controller1)


with open('true-nft/components/true-nft-core/build/NftRoot.tvc', 'rb') as fp:     
    deploy_set = DeploySet(tvc=base64.b64encode(fp.read()).decode(),initial_data=dict(_name="5423",_addrOwner=controller1)) 


# Deploy nft token
print(keypair_NFTowner.public)
call_set = CallSet(
            function_name='constructor',
            header=FunctionHeader(pubkey=keypair_NFTowner.public),input=dict(codeIndex=codeIndex.code,codeData= codeData.code))
encode_params = ParamsOfEncodeMessage(
            abi=roottoken_abi, signer=Signer.Keys(keypair_NFTowner), deploy_set=deploy_set,
            call_set=call_set)
encoded = client.abi.encode_message(params=encode_params)
NFTToken_adr = encoded.address
send_grams(address=encoded.address)

process_params = ParamsOfProcessMessage(
    message_encode_params=encode_params, send_events=False)
result = client.processing.process_message(
    params=process_params)
print("RootToken:",NFTToken_adr)

# Mint token
call_set = CallSet(
            function_name='mintNFT',
            header=FunctionHeader(pubkey=keypair_controller1.public),input=dict(rootNFT=NFTToken_adr,metadata=json.dumps(dict(name="Name")).encode("utf-8").hex()))
encode_params = ParamsOfEncodeMessage(
            abi=controller_abi, signer=Signer.Keys(keypair_controller1),address=controller1,
            call_set=call_set)
process_params = ParamsOfProcessMessage(
    message_encode_params=encode_params, send_events=False)
result = client.processing.process_message(
    params=process_params)
print('mint nft')

# Deploy exchanger
call_set = CallSet(
            function_name='constructor',
            header=FunctionHeader(pubkey=keypair_exchanger.public),input=dict(_name="4e616d65206f662065786368616e6765720a",
            _commission=3,_highest_commission=10,_pair_code=nftPair_code,_auction_code=nftauction_code,_time_limit=60*60*24*7,_withdraw_address="-1:3333333333333333333333333333333333333333333333333333333333333333"))
encode_params = ParamsOfEncodeMessage(
            abi=exchanger_abi, signer=Signer.Keys(keypair_exchanger), deploy_set=deploy_set_exchanger,
            call_set=call_set)
encoded = client.abi.encode_message(params=encode_params)
exchanger_address = encoded.address
send_grams(address=exchanger_address)
process_params = ParamsOfProcessMessage(
    message_encode_params=encode_params, send_events=False)
result = client.processing.process_message(
    params=process_params)
print("Exchanger:",exchanger_address)


