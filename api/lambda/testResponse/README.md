# Lambda resolver for api endpoint

Lambda resolver example, structure is as follows:
```shell
# Contains source code, config.json can be used to override default lambda config
main/
  index.ts
  package.json
  tsconfig.json
  config.json  
  unit.test.ts
# Contains code bundled by rollup, using global rollup config
src/
  index.js
  index.js.map
# Contains archive of bundled code for deployment
dist/
    index.zip
```