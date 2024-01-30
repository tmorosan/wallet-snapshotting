import type {APIGatewayProxyEventV2, APIGatewayProxyResultV2} from "aws-lambda";
import {DynamoDBClient, QueryCommand} from "@aws-sdk/client-dynamodb";

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

export async function handler(event: APIGatewayProxyEventV2): Promise<APIGatewayProxyResultV2> {
    try {
        console.log(JSON.stringify(event, null, "\t"));
        const id = event.pathParameters?.id
        if (!id) {
            throw new Error("Id is undefined");
        }

        const result = await dynamodb.send(new QueryCommand({
            TableName: safeGetEnvVar("COLLECTION_TABLE"),
            KeyConditionExpression: "Id = :id",
            ExpressionAttributeValues: {
                ":id": {S: id},
            },
        }));

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