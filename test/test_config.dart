import 'dart:developer';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:dotenv/dotenv.dart';
import 'package:solidity_error/solidity_error.dart';

class TestConfig {
  static late DotEnv env;
  static late Web3Client web3Client;
  static late int chainId;

  // Define Sender
  static late String senderPrivateKey;
  static late String senderAddress;

  // Define Sender
  static late String recipientPrivateKey;
  static late String recipientAddress;

  // Deployed Contracts
  static late String targetAddress;
  static late SolidityError target;

  // Define rpcUrl here so it's only defined once
  static late String rpcUrl;

  static Future<void> initialize() async {
    await _loadEnvironment();
    await _initializeWeb3ClientAndSetVariables();
    await _initializeContract();
  }

  // final String rpcUrl =
  //     'https://endpoints.omniatech.io/v1/eth/sepolia/public'; // Replace with your RPC URL
  // final String privateKey =
  //     '0xbe908c0c1721ada548b7264c634e1da1344c3c09089b30af896ba32739fc076c'; // Replace with your private key
  // late Web3Client client;
  // late DeployedContract contract;
  // final String contractAddress =
  //     '0xA2Cebc4D9DBD943f8f0bd3ED8788bB3B927A7014'; // Replace with deployed address

  static Future<void> _loadEnvironment() async {
    env = DotEnv(includePlatformEnvironment: true)..load();
  }

  static Future<void> _initializeWeb3ClientAndSetVariables() async {
    rpcUrl = 'https://endpoints.omniatech.io/v1/eth/sepolia/public';

    if (rpcUrl.isEmpty) {
      throw Exception('RPC environment variable is not set');
    }

    // web3Client
    web3Client = Web3Client(rpcUrl, Client());
    chainId = await web3Client.getNetworkId();
    log('Connected to chain id: $chainId');

    // Select privateKey based on chainId
    if (chainId == 1) {
      senderPrivateKey = env['SENDER_PRIVATE_KEY'] ?? '';
      recipientPrivateKey = env['REC_PRIVATE_KEY'] ?? '';
    } else if (chainId == 12341234) {
      senderPrivateKey = env['SENDER_PRIVATE_KEY_ANVIL'] ?? '';
      recipientPrivateKey = env['REC_PRIVATE_KEY_ANVIL'] ?? '';
    } else if (chainId == 11155111) {
      // Sepolia chain ID
      senderPrivateKey = env['SENDER_PRIVATE_KEY_SEPOLIA'] ?? '';
      recipientPrivateKey = env['REC_PRIVATE_KEY_SEPOLIA'] ?? '';
    } else {
      throw Exception('Unsupported chain ID: $chainId');
    }

    if (senderPrivateKey.isEmpty || recipientPrivateKey.isEmpty) {
      throw Exception(
        'Private key environment variable is not set correctly.\n'
        'Sender: ${maskString(senderPrivateKey)} \n'
        'Recipient: ${maskString(recipientPrivateKey)} \n',
      );
    }

    final senderPrivateKeyHex = EthPrivateKey.fromHex(senderPrivateKey);
    senderAddress = senderPrivateKeyHex.address.hexEip55;

    final recipientPrivateKeyHex = EthPrivateKey.fromHex(recipientPrivateKey);
    recipientAddress = recipientPrivateKeyHex.address.hexEip55;

    // Get ETH balance for sender
    final senderBalance = await web3Client.getBalance(
      EthereumAddress.fromHex(senderAddress),
    );

    // Get ETH balance for recipient
    final recipientBalance = await web3Client.getBalance(
      EthereumAddress.fromHex(recipientAddress),
    );

    log('''
    Owner/Sender address: $senderAddress,
    Sender Balance      : $senderBalance,
    Recipient address   : $recipientAddress,
    Recipient Balance   : $recipientBalance,
    ''');
  }

  static Future<void> _initializeContract() async {
    // Get the contract address
    targetAddress = '0x2adba0B0dBB8DACD2E2Ec22548fa9F63B523eDCC';

    // Now Initialize Contract
    target = SolidityError(
      address: EthereumAddress.fromHex(targetAddress),
      web3Client: web3Client,
    );
  }

  static Future<void> waitForTransaction(String txHash) async {
    while (true) {
      final receipt = await web3Client.getTransactionReceipt(txHash);
      if (receipt != null) break;
      await Future.delayed(const Duration(seconds: 20));
    }
  }

  static String maskString(String key) {
    if (key.length <= 10) return key; // Handle short keys

    String firstSix = key.substring(0, 6);
    String lastFour = key.substring(key.length - 4);
    return "$firstSix...$lastFour";
  }

  static Future<void> dispose() => web3Client.dispose();
}
