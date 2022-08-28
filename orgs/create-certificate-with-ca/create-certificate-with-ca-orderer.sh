createCretificateForOrderer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/ordererOrganizations/barclays.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/barclays.com

  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.bank1.barclays.com --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/ordererOrganizations/barclays.com/msp/config.yaml

  echo
  echo "Register orderer"
  echo

  fabric-ca-client register --caname ca.bank1.barclays.com --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

#   echo
#   echo "Register orderer2"
#   echo

#   fabric-ca-client register --caname ca.bank1.barclays.com --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

#   echo
#   echo "Register orderer3"
#   echo

#   fabric-ca-client register --caname ca.bank1.barclays.com --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

  echo
  echo "Register the orderer admin"
  echo

  fabric-ca-client register --caname ca.bank1.barclays.com --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

  mkdir -p ../crypto-config/ordererOrganizations/barclays.com/orderers
  # mkdir -p ../crypto-config/ordererOrganizations/barclays.com/orderers/barclays.com

  # ---------------------------------------------------------------------------
  #  Orderer

  mkdir -p ../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/msp --csr.hosts orderer.barclays.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls --enrollment.profile tls --csr.hosts orderer.barclays.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/msp/tlscacerts/tlsca.barclays.com-cert.pem

  mkdir ${PWD}/../crypto-config/ordererOrganizations/barclays.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/msp/tlscacerts/tlsca.barclays.com-cert.pem

  # -----------------------------------------------------------------------
  #  Orderer 2

#   mkdir -p ../crypto-config/ordererOrganizations/barclays.com/orderers/orderer2.barclays.com

#   echo
#   echo "## Generate the orderer2 msp"
#   echo

#   fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer2.barclays.com/msp --csr.hosts orderer2.barclays.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

#   cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer2.barclays.com/msp/config.yaml

#   echo
#   echo "## Generate the orderer2-tls certificates"
#   echo

#   fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer2.barclays.com/tls --enrollment.profile tls --csr.hosts orderer2.barclays.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

#   cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer2.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer2.barclays.com/tls/ca.crt
#   cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer2.barclays.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer2.barclays.com/tls/server.crt
#   cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer2.barclays.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer2.barclays.com/tls/server.key

#   mkdir ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer2.barclays.com/msp/tlscacerts
#   cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer2.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer2.barclays.com/msp/tlscacerts/tlsca.barclays.com-cert.pem

  # ---------------------------------------------------------------------------
  #  Orderer 3
#   mkdir -p ../crypto-config/ordererOrganizations/barclays.com/orderers/orderer3.barclays.com

#   echo
#   echo "## Generate the orderer3 msp"
#   echo

#   fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer3.barclays.com/msp --csr.hosts orderer3.barclays.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

#   cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer3.barclays.com/msp/config.yaml

#   echo
#   echo "## Generate the orderer3-tls certificates"
#   echo

#   fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer3.barclays.com/tls --enrollment.profile tls --csr.hosts orderer3.barclays.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

#   cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer3.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer3.barclays.com/tls/ca.crt
#   cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer3.barclays.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer3.barclays.com/tls/server.crt
#   cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer3.barclays.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer3.barclays.com/tls/server.key

#   mkdir ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer3.barclays.com/msp/tlscacerts
#   cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer3.barclays.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/barclays.com/orderers/orderer3.barclays.com/msp/tlscacerts/tlsca.barclays.com-cert.pem
  # ---------------------------------------------------------------------------

  mkdir -p ../crypto-config/ordererOrganizations/barclays.com/users
  mkdir -p ../crypto-config/ordererOrganizations/barclays.com/users/Admin@barclays.com

  echo
  echo "## Generate the admin msp"
  echo

  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:7054 --caname ca.bank1.barclays.com -M ${PWD}/../crypto-config/ordererOrganizations/barclays.com/users/Admin@barclays.com/msp --tls.certfiles ${PWD}/fabric-ca/bank1/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/barclays.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/barclays.com/users/Admin@barclays.com/msp/config.yaml

}

createCretificateForOrderer