String abi = '''
[
	{
		"inputs": [],
		"name": "AddressZero",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "comittedTime",
				"type": "uint256"
			}
		],
		"name": "AlreadyCommitted",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "codeDeadline",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "currentTime",
				"type": "uint256"
			}
		],
		"name": "CodeExpired",
		"type": "error"
	},
	{
		"inputs": [],
		"name": "CommitmentInactive",
		"type": "error"
	},
	{
		"inputs": [],
		"name": "CommitmentInvalid",
		"type": "error"
	},
	{
		"inputs": [],
		"name": "DirectEthTransferNotAllowed",
		"type": "error"
	},
	{
		"inputs": [],
		"name": "FunctionDoesNotExist",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "value",
				"type": "uint256"
			}
		],
		"name": "Insufficient",
		"type": "error"
	},
	{
		"inputs": [],
		"name": "NoCommitmentFound",
		"type": "error"
	},
	{
		"inputs": [],
		"name": "ReferralCodeInvalid",
		"type": "error"
	},
	{
		"inputs": [],
		"name": "RevealNotAllowed",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "bytes32",
				"name": "sigToken",
				"type": "bytes32"
			}
		],
		"name": "SignatureInvalid",
		"type": "error"
	},
	{
		"inputs": [],
		"name": "TokenExist",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "user",
				"type": "address"
			},
			{
				"internalType": "bool",
				"name": "isActive",
				"type": "bool"
			}
		],
		"name": "WalletStatus",
		"type": "error"
	},
	{
		"inputs": [],
		"name": "revertAddressZero",
		"outputs": [],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "commitTime",
				"type": "uint256"
			}
		],
		"name": "revertAlreadyCommitted",
		"outputs": [],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "currentTime",
				"type": "uint256"
			}
		],
		"name": "revertCodeExpired",
		"outputs": [],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "revertCommitmentInactive",
		"outputs": [],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "revertCommitmentInvalid",
		"outputs": [],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "revertDirectEthTransferNotAllowed",
		"outputs": [],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "revertFunctionDoesNotExist",
		"outputs": [],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "value",
				"type": "uint256"
			}
		],
		"name": "revertInsufficient",
		"outputs": [],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "revertNoCommitmentFound",
		"outputs": [],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "revertReferralCodeInvalid",
		"outputs": [],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "revertRevealNotAllowed",
		"outputs": [],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes32",
				"name": "sigToken",
				"type": "bytes32"
			}
		],
		"name": "revertSignatureInvalid",
		"outputs": [],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "revertTokenExist",
		"outputs": [],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "user",
				"type": "address"
			},
			{
				"internalType": "bool",
				"name": "isActive",
				"type": "bool"
			}
		],
		"name": "revertWalletStatus",
		"outputs": [],
		"stateMutability": "pure",
		"type": "function"
	}
]
''';
