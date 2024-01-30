import commonjs from "@rollup/plugin-commonjs";
import ts from "@rollup/plugin-typescript";
import { defineConfig } from "rollup";

const config = defineConfig({
  input: "./src/index.ts",
  output: {
    file: "./src/index.js",
    sourcemap: true,
    format: "cjs",
  },
  external: ["@aws-sdk/client-dynamodb"],
  plugins: [commonjs(), ts()],
});

export default config;
