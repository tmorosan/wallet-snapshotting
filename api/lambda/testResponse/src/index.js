'use strict';

Object.defineProperty(exports, "__esModule", { value: true });
module.exports.handler = async (event) => {
    console.log("Received event:", JSON.stringify(event, null, 2));
    return {
        statusCode: 200,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            message: "Hello from Lambda!",
        }),
    };
};
//# sourceMappingURL=index.js.map
