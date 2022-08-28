export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/msp/tlscacerts/tlsca.barclays.com-cert.pem
export PEER0_ORG1_CA=${PWD}/crypto-config/peerOrganizations/bank1.barclays.com/peers/peer0.bank1.barclays.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/crypto-config/peerOrganizations/bank2.barclays.com/peers/peer0.bank2.barclays.com/tls/ca.crt
export PEER0_ORG3_CA=${PWD}/crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../artifacts/channel/config/

export CHANNEL_NAME=channelcbdc

setGlobalsForPeer0Bank1(){
    export CORE_PEER_LOCALMSPID="Bank1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/bank1.barclays.com/users/Admin@bank1.barclays.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer0Bank2(){
    export CORE_PEER_LOCALMSPID="Bank2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/bank2.barclays.com/users/Admin@bank2.barclays.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
}

setGlobalsForPeer0NonBank(){
    export CORE_PEER_LOCALMSPID="NonbankMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/nonbank.barclays.com/users/Admin@nonbank.barclays.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
}
# setGlobalsForPeer1Org1(){
#     export CORE_PEER_LOCALMSPID="Bank1MSP"
#     export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/bank1.barclays.com/users/Admin@bank1.barclays.com/msp
#     export CORE_PEER_ADDRESS=localhost:8051
# }

createChannel(){
    rm -rf ./channel-artifacts/*
    setGlobalsForPeer0Bank1
    
    # Replace localhost with your orderer's vm IP address
    peer channel create -o localhost:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.barclays.com \
    -f ../artifacts/channel/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

# createChannel

joinChannel(){
    setGlobalsForPeer0Bank1
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForPeer1Bank2
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

    setGlobalsForPeer0NonBank
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
}

# joinChannel

updateAnchorPeers(){
    setGlobalsForPeer0Bank1
    # Replace localhost with your orderer's vm IP address
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.barclays.com -c $CHANNEL_NAME -f ../artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    setGlobalsForPeer0Bank2
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.barclays.com -c $CHANNEL_NAME -f ../artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

    setGlobalsForPeer0NonBank
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.barclays.com -c $CHANNEL_NAME -f ../artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

# updateAnchorPeers

# removeOldCrypto

createChannel
joinChannel
updateAnchorPeers