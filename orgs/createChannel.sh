export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/msp/tlscacerts/tlsca.barclays.com-cert.pem
export PEER0_ORG1_CA=${PWD}/crypto-config/peerOrganizations/bank1.barclays.com/peers/peer0.bank1.barclays.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../artifacts/channel/config/

export CHANNEL_NAME=channelcbdc

setGlobalsForPeer0Org1(){
    export CORE_PEER_LOCALMSPID="Bank1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/bank1.barclays.com/users/Admin@bank1.barclays.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

# setGlobalsForPeer1Org1(){
#     export CORE_PEER_LOCALMSPID="Bank1MSP"
#     export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/bank1.barclays.com/users/Admin@bank1.barclays.com/msp
#     export CORE_PEER_ADDRESS=localhost:8051
# }

createChannel(){
    rm -rf ./channel-artifacts/*
    setGlobalsForPeer0Org1
    
    # Replace localhost with your orderer's vm IP address
    peer channel create -o localhost:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.barclays.com \
    -f ../artifacts/channel/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

# createChannel

joinChannel(){
    setGlobalsForPeer0Org1
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    # setGlobalsForPeer1Org1
    # peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
}

# joinChannel

updateAnchorPeers(){
    setGlobalsForPeer0Org1
    # Replace localhost with your orderer's vm IP address
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.barclays.com -c $CHANNEL_NAME -f ../artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
}

# updateAnchorPeers

# removeOldCrypto

createChannel
joinChannel
updateAnchorPeers