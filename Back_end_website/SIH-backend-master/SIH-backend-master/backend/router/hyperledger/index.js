const express = require('express');
const { Gateway, Wallets } = require('fabric-network');
const fs = require('fs');
const path = require('path');
const DumContract = require('./DumContaract');

const hyperledger = express.Router();

async function authenticateUser(req, res, next) {
    try {
        const walletPath = path.join(__dirname, 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        
        const identity = 'user1'; // Get the user identity from the request (e.g., from JWT token)
        
        const userExists = await wallet.exists(identity);
        if (!userExists) {
            throw new Error('User does not exist in the wallet');
        }

        // Perform additional checks for user permissions if required

        // Attach the user's identity to the request object
        req.userIdentity = identity;
        next();
    } catch (error) {
        res.status(401).send('Authentication failed');
    }
}
app.use(authenticateUser);
// Connect to Fabric network and load contract
async function connectToNetwork() {
    const ccpPath = path.resolve(__dirname, '..', 'connection.json');
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

    const contract = new DumContract(); // Instantiate the contract class directly
    await contract.setupNetwork(network);

    return contract;
}

// Define API endpoints

// Add a dumpster
hyperledger.post('/api/dumpster', async (req, res) => {
    try {
        const contract = await connectToNetwork();
        const { id, status, location, shovelId } = req.body;
        const result = await contract.addDumpster(id, status, location, shovelId);
        res.json(result);
    } catch (error) {
        res.status(500).send(error.toString());
    }
});

// Get dumpster by ID
hyperledger.get('/api/dumpster/:id', async (req, res) => {
    try {
        const contract = await connectToNetwork();
        const result = await contract.readDumpster(req.params.id);
        res.json(result);
    } catch (error) {
        res.status(500).send(error.toString());
    }
});

// Get dumpsters
hyperledger.get('/api/dumpsters', async (req, res) => {
    try {
        const contract = await connectToNetwork();
        const result = await contract.getDumpsters();
        res.json(result);
    } catch (error) {
        res.status(500).send(error.toString());
    }
});

// Update a dumpster by ID
hyperledger.put('/api/dumpster/:id', async (req, res) => {
    try {
        const contract = await connectToNetwork();
        const { newValue } = req.body;
        const result = await contract.updateDumpster(req.params.id, newValue);
        res.json(result);
    } catch (error) {
        res.status(500).send(error.toString());
    }
});

// Delete a dumpster by ID
hyperledger.delete('/api/dumpster/:id', async (req, res) => {
    try {
        const contract = await connectToNetwork();
        const result = await contract.deleteDumpster(req.params.id);
        res.json(result);
    } catch (error) {
        res.status(500).send(error.toString());
    }
});

module.exports=hyperledger;