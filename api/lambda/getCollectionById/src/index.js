'use strict';

Object.defineProperty(exports, "__esModule", { value: true });
exports.handler = void 0;
const client_dynamodb_1 = require("@aws-sdk/client-dynamodb");
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
async function handler(event) {
    try {
        console.log(JSON.stringify(event, null, "\t"));
        const id = event.pathParameters?.id;
        if (!id) {
            throw new Error("Id is undefined");
        }
        const result = await dynamodb.send(new client_dynamodb_1.QueryCommand({
            TableName: safeGetEnvVar("COLLECTION_TABLE"),
            KeyConditionExpression: "Id = :id",
            ExpressionAttributeValues: {
                ":id": { S: id },
            },
        }));
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
