# This file is generated by deploy script and will be rewritten on each deploy
lambdas = [
{
path="../api/lambda/testResponse",
name="testResponseLambda"
memory="128"
timeout="60"
runtime="nodejs18.x"
},
{
path="../api/lambda/testResponseTheSecond",
name="testResponseTheSecond"
},
]