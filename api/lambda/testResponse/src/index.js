'use strict';

Object.defineProperty(exports, "__esModule", { value: true });
exports.handler = void 0;
const client_dynamodb_1 = require("@aws-sdk/client-dynamodb");
const lib_dynamodb_1 = require("@aws-sdk/lib-dynamodb");
const crypto_1 = require("crypto");
const safeGetEnvVar = (envName) => {
    const value = process.env?.[envName];
    if (!value) {
        throw new Error(`${envName} is undefined`);
    }
    return value;
};
const dynamodb = new client_dynamodb_1.DynamoDBClient({
    region: safeGetEnvVar("REGION"),
});
const client = lib_dynamodb_1.DynamoDBDocument.from(dynamodb);
async function handler(event) {
    try {
        const now = new Date().toISOString();
        const putCommand = {
            TableName: safeGetEnvVar("COLLECTION_TABLE"),
            Item: {
                Id: (0, crypto_1.randomUUID)(),
                Name: "test",
                createdAt: now,
                updatedAt: now,
            },
        };
        const result = await client.put(putCommand);
        return {
            statusCode: 200,
            body: JSON.stringify(result, null, "\t"),
        };
    }
    catch (e) {
        return {
            statusCode: 500,
            body: JSON.stringify(e, null, "\t"),
        };
    }
}
exports.handler = handler;
//# sourceMappingURL=index.js.map
