createcertificatesForOrg3() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/nonbank.barclays.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca.nonbank.barclays.com --tls.certfiles ${PWD}/fabric-ca/nonbank/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-nonbank-barclays-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-nonbank-barclays-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-nonbank-barclays-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-nonbank-barclays-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.nonbank.barclays.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/nonbank/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.nonbank.barclays.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/nonbank/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.nonbank.barclays.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/nonbank/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.nonbank.barclays.com --id.name nonbankadmin --id.secret nonbankadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/nonbank/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/nonbank.barclays.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.nonbank.barclays.com -M ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/msp --csr.hosts peer0.nonbank.barclays.com --tls.certfiles ${PWD}/fabric-ca/nonbank/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.nonbank.barclays.com -M ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls --enrollment.profile tls --csr.hosts peer0.nonbank.barclays.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/nonbank/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/tlsca/tlsca.nonbank.barclays.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer0.nonbank.barclays.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/ca/ca.nonbank.barclays.com-cert.pem

  # ------------------------------------------------------------------------------------------------

  # Peer1

  mkdir -p ../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer1.nonbank.barclays.com

  echo
  echo "## Generate the peer1 msp"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca.nonbank.barclays.com -M ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer1.nonbank.barclays.com/msp --csr.hosts peer1.nonbank.barclays.com --tls.certfiles ${PWD}/fabric-ca/nonbank/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer1.nonbank.barclays.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca.nonbank.barclays.com -M ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer1.nonbank.barclays.com/tls --enrollment.profile tls --csr.hosts peer1.nonbank.barclays.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/nonbank/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer1.nonbank.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer1.nonbank.barclays.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer1.nonbank.barclays.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer1.nonbank.barclays.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer1.nonbank.barclays.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/peers/peer1.nonbank.barclays.com/tls/server.key

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/nonbank.barclays.com/users
  mkdir -p ../crypto-config/peerOrganizations/nonbank.barclays.com/users/User1@nonbank.barclays.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca.nonbank.barclays.com -M ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/users/User1@nonbank.barclays.com/msp --tls.certfiles ${PWD}/fabric-ca/nonbank/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/nonbank.barclays.com/users/Admin@nonbank.barclays.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://nonbankadmin:nonbankadminpw@localhost:10054 --caname ca.nonbank.barclays.com -M ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/users/Admin@nonbank.barclays.com/msp --tls.certfiles ${PWD}/fabric-ca/nonbank/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/nonbank.barclays.com/users/Admin@nonbank.barclays.com/msp/config.yaml

}

createcertificatesForOrg3

