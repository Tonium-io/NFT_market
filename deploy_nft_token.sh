
#!/bin/bash
set -e

tos=./tonos-cli
if test -f "$tos"; then
    echo "$tos exists."
else
    echo "$tos not found in current directory. Please, copy it here and rerun script."
    exit
fi

DEBOT_NAME=NFT_token/pair
#giver=0:653b9a6452c7a982c6dc92b2da9eba832ade1c467699ebb3b43dca6d77b780dd
giver=0:841288ed3b55d9cdafa806807f02a0ae0c169aa5edfe88a789a6482429756a94
function giver {
#./tonos-cli --url $NETWORK call --abi ./grant.abi.json $giver grant "{\"addr\":\"${1:2}\"}"
./tonos-cli --url $NETWORK call --abi ./local_giver.abi.json $giver sendGrams "{\"dest\":\"$1\",\"amount\":10000000000}"
}
function get_address {
echo $(cat log.log | grep "Raw address:" | cut -d ' ' -f 3)
}
function genaddr {
./tonos-cli genaddr $1.tvc $1.abi.json --genkey $1.keys.json > log.log
}

LOCALNET=http://127.0.0.1
DEVNET=https://net.ton.dev
MAINNET=https://main.ton.dev
NETWORK=$LOCALNET

echo GENADDR DEBOT
genaddr $DEBOT_NAME
DEBOT_ADDRESS=$(get_address)

echo ASK GIVER
giver $DEBOT_ADDRESS
DEBOT_ABI=$(cat $DEBOT_NAME.abi.json | xxd -ps -c 20000)

echo DEPLOY DEBOT $DEBOT_ADDRESS
#'{"Jurrors": ["0xf66a20b278b2064684b56c99baa5e2703ff7724617148a7a380fbd2133d866a4","0xf66a20b278b2064684b56c99baa5e2703ff7724617148a7a380fbd2133d866a3"], "TimeFinish": 1617942836}'

./tonos-cli --url $NETWORK deploy $DEBOT_NAME.tvc "{}" --sign $DEBOT_NAME.keys.json --abi $DEBOT_NAME.abi.json
./tonos-cli --url $NETWORK call $DEBOT_ADDRESS createNFTWallet "{\"root_token\":\"0:ab6569a63f850617ba4e2efe7afe41cfcc4d0559c476fb97f4e8c8644bf64ee7\"}" --sign $DEBOT_NAME.keys.json --abi $DEBOT_NAME.abi.json

echo DONE
echo $DEBOT_ADDRESS > address.log
echo debot  $DEBOT_ADDRESS
