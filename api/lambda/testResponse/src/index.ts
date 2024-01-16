import type {APIGatewayProxyEventV2, APIGatewayProxyResultV2} from "aws-lambda";
import {DynamoDBClient} from "@aws-sdk/client-dynamodb";
import {DynamoDBDocument} from "@aws-sdk/lib-dynamodb";
import {randomUUID} from "crypto";

const safeGetEnvVar = (envName: string) => {
    const value = process.env?.[envName];
    if (!value) {
        throw new Error(`${envName} is undefined`);
    }
    return value;
};

const dynamodb = new DynamoDBClient({
    region: safeGetEnvVar("REGION"),
});

const client = DynamoDBDocument.from(dynamodb);

export async function handler(event: APIGatewayProxyEventV2): Promise<APIGatewayProxyResultV2> {
    try {
        const now = new Date().toISOString();
        const putCommand = {
            TableName: safeGetEnvVar("COLLECTION_TABLE"),
            Item: {
                Id: randomUUID(),
                Name: "test",
                createdAt: now,
                updatedAt: now,
            },
        }
        const result = await client.put(putCommand);
        return {
            statusCode: 200,
            body: JSON.stringify(result, null, "\t"),
        };
    } catch (e) {
        return {
            statusCode: 500,
            body: JSON.stringify(e, null, "\t"),
        };
    }
}