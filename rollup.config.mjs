import commonjs from "@rollup/plugin-commonjs";
import json from "@rollup/plugin-json";
import { nodeResolve } from "@rollup/plugin-node-resolve";
import ts from "@rollup/plugin-typescript";

const plugins = [
  nodeResolve({
    preferBuiltins: false,
    exportConditions: ["node"],
  }),
  commonjs(),
  json(),
  ts({ tsconfig: "./tsconfig.json", include: ["*.ts+(|x)", "**/*.ts+(|x)"], exclude: ["*.test.ts"] }),
];

const format = "cjs";

const config = [
  {
    input: "index.ts",
    output: {
      file: "../src/index.js",
      sourcemap: true,
      format,
    },
    plugins,
  },
];

export default config;
