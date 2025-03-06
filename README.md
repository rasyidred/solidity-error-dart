# Solidity Custom Error Fetcher

This repo catches Solidity smart contract's custom errors. 

## Error List

The list of errors is located in `lib/error_decoder.dart`, in internal variable `_errorSignatures`.

The method ID equals to `bytes4(keccak256("CUSTOM_ERROR(DATA_TYPE1, DATA_TYPE2)"))` from Solidity. 

For example: 
- `0x9fabe1c1` is derived from `bytes4(keccak256("AddressZero()"))`
- `0x1b6804f4` is derived from `bytes4(keccak256("AlreadyCommitted(uint256)"))`

