# Kinganimals

## Requirements
Node version < v14 (recommend v12.22.8)

## Install tronbox
```
npm install -g tronbox
```

## Migration
Create a .env_migrate file (it must be gitignored) containing something like

```
export PRIVATE_KEY_MAINNET=4E7FECCB71207B867C495B51A9758B104B1D4422088A87F4978BE64636656243
```

Then, run the migration with:
```
source .env_migrate && tronbox migrate --network mainnet
```

## Test 
```
yarn test test_manually/ten_file
```

## Run tasks mainnet
```
node tasks/mainnet.js
```

## Run tasks testnet
```
node tasks/testnet.js
```
