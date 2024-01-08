module.exports.handler = async (event: any) => {
  console.log("Received event:", JSON.stringify(event, null, 2));

  return {
    statusCode: 200,
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      message: "Hello from Second Lambda!",
    }),
  };
};
