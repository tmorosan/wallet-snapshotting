set -e
npm install
npx rollup --config rollup.config.ts --configPlugin typescript --bundleConfigAsCjs
rm package.zip || true
zip -j package src/index.js src/index.js.map