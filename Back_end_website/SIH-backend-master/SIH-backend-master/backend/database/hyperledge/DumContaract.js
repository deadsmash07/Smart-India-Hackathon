'use strict';

const { Contract } = require('fabric-contract-api');

class DumContract extends Contract {

    async initLedger(ctx) {
    }

    async addDumpster(ctx, id, status, location,shovelId) {
        // Create a new dumster
        const dumster = {
            id:id,//string
            status:status,//boolean
            location:location,//map of lat and long
            shovelId:shovelId,//string
            timestamp: Date.now()//timestamp
        };
        await ctx.stub.putState(id, Buffer.from(JSON.stringify(dumster)));
        return JSON.stringify(dumster);
    }

    async readDumster(ctx, id) {
        // Read an dumster from the ledger
        const dumsterJSON = await ctx.stub.getState(id);
        if (!dumsterJSON || dumsterJSON.length === 0) {
            throw new Error(`dumster ${id} does not exist`);
        }
        return dumsterJSON.toString();
    }
    async getDumster(ctx) {
        const startKey = '';
        const endKey = '';
        const iterator = await ctx.stub.getStateByRange(startKey, endKey);
        let result = null;

        for await (const keyVal of iterator) {
            if (!keyVal.value) {
                continue;
            }
            const resp = JSON.parse(keyVal.value.toString());
            if (resp.status === false) {
                result = resp.id;
                break;
            }
        }
        return result;
    }
    async updateDumster(ctx, id, newValue) {
        // Update an dumster's value
        const dumsterJSON = await ctx.stub.getState(id);
        if (!dumsterJSON || dumsterJSON.length === 0) {
            throw new Error(`dumster ${id} does not exist`);
        }
        const dumster = JSON.parse(dumsterJSON.toString());
        dumster.value = newValue;
        dumster.value.timestamp = Date.now();
        await ctx.stub.putState(id, Buffer.from(JSON.stringify(dumster)));
        return JSON.stringify(dumster);
    }

    async deleteDumster(ctx, id) {
        // Delete an dumster from the ledger
        const dumsterJSON = await ctx.stub.getState(id);
        if (!dumsterJSON || dumsterJSON.length === 0) {
            throw new Error(`dumster ${id} does not exist`);
        }
        await ctx.stub.deleteState(id);
        return `dumster ${id} deleted`;
    }
}

module.exports = DumContract;
