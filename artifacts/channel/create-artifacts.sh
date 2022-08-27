
chmod -R 0755 ./crypto-config
# Delete existing artifacts
rm -rf ./crypto-config
rm genesis.block mychannel.tx
rm -rf ../../channel-artifacts/*

#Generate Crypto artifactes for organizations
# cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/



# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "mychannel"
CHANNEL_NAME="channelcbdc"

echo $CHANNEL_NAME

# Generate System Genesis block
configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block


# Generate channel configuration block
configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./mychannel.tx -channelID $CHANNEL_NAME

echo "#######    Generating anchor peer update for Bank1MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./Bank1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Bank1MSP

echo "#######    Generating anchor peer update for Bank2MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./Bank2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Bank2MSP

echo "#######    Generating anchor peer update for NonbankMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./NonbankMSPanchors.tx -channelID $CHANNEL_NAME -asOrg NonbankMSP