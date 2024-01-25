'use strict';

const { ContractLoader } = require('fabric-network');
const { Gateway, Wallets } = require('fabric-network');
const fs = require('fs');
const path = require('path');
const DumContract = require('./DumContaract');

async function main() {
    const ccpPath = path.resolve(__dirname, '..', 'connection.json'); // Path to your connection profile
    const ccpJSON = fs.readFileSync(ccpPath, 'utf8');
    const ccp = JSON.parse(ccpJSON);

    const walletPath = path.join(__dirname, 'wallet');
    const wallet = await Wallets.newFileSystemWallet(walletPath);

    const identity = 'user1'; // Identity in the wallet

    const gateway = new Gateway();
    await gateway.connect(ccp, {
        wallet,
        identity,
        discovery: { enabled: true, asLocalhost: true }
    });

    const network = await gateway.getNetwork('mychannel'); // Replace 'mychannel' with your channel name

    const contract = new ContractLoader(network);
    await contract.loadContract(DumContract);

    // Start the chaincode server
    const server = contract.startServer();
    console.log('Chaincode server started...');
}

main().catch((err) => {
    console.error(`Error: ${err}`);
    process.exit(1);
});
