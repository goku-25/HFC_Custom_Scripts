createcertificatesForOrg1() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/bank1.barclays.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.bank1.barclays.com --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-bank1-barclays-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-bank1-barclays-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-bank1-barclays-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-bank1-barclays-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.bank1.barclays.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.bank1.barclays.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.bank1.barclays.com --id.name bank1admin --id.secret bank1adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

  # -----------------------------------------------------------------------------------
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/barclays.com
  echo
  echo "Register orderer"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  echo
  echo "Register the orderer admin"
  echo

  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  mkdir -p ../crypto-config/ordererOrganizations/barclays.com/orderers

  mkdir -p ../crypto-config/peerOrganizations/bank1.barclays.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/bank1.barclays.com/peers/peer0.bank1.barclays.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/peers/peer0.bank1.barclays.com/msp --csr.hosts peer0.bank1.barclays.com --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/peers/peer0.bank1.barclays.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/peers/peer0.bank1.barclays.com/tls --enrollment.profile tls --csr.hosts peer0.bank1.barclays.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/peers/peer0.bank1.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/peers/peer0.bank1.barclays.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/peers/peer0.bank1.barclays.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/peers/peer0.bank1.barclays.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/peers/peer0.bank1.barclays.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/peers/peer0.bank1.barclays.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/peers/peer0.bank1.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/peers/peer0.bank1.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/tlsca/tlsca.bank1.barclays.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/peers/peer0.bank1.barclays.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/ca/ca.bank1.barclays.com-cert.pem

  # ------------------------------------------------------------------------------------------------
  # peer 0 bank 2
  mkdir -p ../crypto-config/peerOrganizations/bank2.barclays.com/peers/peer0.bank2.barclays.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/peers/peer0.bank2.barclays.com/msp --csr.hosts peer0.bank2.barclays.com --tls.certfiles ${PWD}/fabric-ca/bank2/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/peers/peer0.bank2.barclays.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/peers/peer0.bank2.barclays.com/tls --enrollment.profile tls --csr.hosts peer0.bank2.barclays.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/bank2/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/peers/peer0.bank2.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/peers/peer0.bank2.barclays.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/peers/peer0.bank2.barclays.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/peers/peer0.bank2.barclays.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/peers/peer0.bank2.barclays.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/peers/peer0.bank2.barclays.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/peers/peer0.bank2.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/peers/peer0.bank2.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/tlsca/tlsca.bank2.barclays.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/peers/peer0.bank2.barclays.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/bank2.barclays.com/ca/ca.bank2.barclays.com-cert.pem


  # ------------------------------------------------------------------------------------------------
  # peer 0 NonBank
  mkdir -p ../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/msp --csr.hosts peer0.nonbank.barclays.com --tls.certfiles ${PWD}/fabric-ca/nonbank/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls --enrollment.profile tls --csr.hosts peer0.nonbank.barclays.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/nonbank/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/tlsca/tlsca.nonbank.barclays.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/ca/ca.nonbank.barclays.com-cert.pem



  # --------------------------------------------------------------------------------------------------
  #  Orderer

  mkdir -p ../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/msp --csr.hosts orderer.barclays.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls --enrollment.profile tls --csr.hosts orderer.barclays.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/msp/tlscacerts/tlsca.barclays.com-cert.pem

  mkdir ${PWD}/../crypto-config/ordererOrganizations/barclays.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/msp/tlscacerts/tlsca.barclays.com-cert.pem

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/bank1.barclays.com/users
  mkdir -p ../crypto-config/peerOrganizations/bank1.barclays.com/users/User1@bank1.barclays.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/users/User1@bank1.barclays.com/msp --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/bank1.barclays.com/users/Admin@bank1.barclays.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://bank1admin:bank1adminpw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/users/Admin@bank1.barclays.com/msp --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/bank1.barclays.com/users/Admin@bank1.barclays.com/msp/config.yaml

}

createcertificatesForOrg1
