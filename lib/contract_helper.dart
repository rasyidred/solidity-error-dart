import 'dart:developer';

import 'package:web3dart/json_rpc.dart';
import 'package:web3dart/web3dart.dart';
import 'error_decoder.dart'; // Import the new error decoder

abstract class ContractHelper {
  final EthereumAddress address;
  final Web3Client web3Client;
  DeployedContract? _cachedContract;
  static const double defaultGasLimitMultiplier = 1.1;

  ContractHelper({
    required this.address,
    required this.web3Client,
  });

  // This method should be implemented by subclasses to provide contract-specific loading
  Future<DeployedContract> loadContract();

  // Get or load contract
  Future<DeployedContract> _getContract() async {
    if (_cachedContract != null) {
      return _cachedContract!;
    }

    _cachedContract = await loadContract();
    return _cachedContract!;
  }

  Future<List<dynamic>> call({
    required String funcName,
    required List<dynamic> args,
  }) async {
    try {
      final DeployedContract contract = await _getContract();
      final ContractFunction function = contract.function(funcName);

      final result = await web3Client.call(
        contract: contract,
        function: function,
        params: args,
      );

      return result;
    } catch (e, stackTrace) {
      log(
        'Failed to send transaction to contract.\nFunction: $funcName\nArgs: $args',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // Updated sendTx method with improved error handling
  Future<String> sendTx({
    required String funcName,
    required List<dynamic> args,
    required String privateKey,
    EtherAmount? value,
    int? maxGas,
  }) async {
    try {
      final DeployedContract contract = await _getContract();
      final ContractFunction ethFunction = contract.function(funcName);

      final result = await web3Client.sendTransaction(
        EthPrivateKey.fromHex(privateKey),
        Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: args,
          value: value,
          maxGas: maxGas,
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );

      return result;
    } catch (e, stackTrace) {
      // Enhanced error handling for RPC errors
      if (e is RPCError) {
        final String? errorData = e.data as String?;

        if (errorData != null && errorData.startsWith('0x')) {
          final DecodedError decodedError = ErrorDecoder.decodeError(errorData);

          // Create a custom exception with decoded error information
          final customException = SolidityCustomException(
            message: decodedError.message,
            errorName: decodedError.name,
            params: decodedError.params,
            originalError: e,
          );

          // Use both log for DevTools and print for console output
          log(
            'Solidity Error in transaction.\n'
            'Function: $funcName\n'
            'Args: $args\n'
            'Error details: ${decodedError.message}\n'
            'Original error data: $errorData',
            error: customException,
          );

          // Add print statement for immediate console visibility
          print('==== SOLIDITY ERROR ====');
          print('Function: $funcName');
          print('Args: $args');
          print('Error name: ${decodedError.name}');
          print('Error details: ${decodedError.message}');
          print('Params: ${_formatErrorParams(decodedError.params)}');
          print('Original error data: $errorData');
          print('========================');

          throw customException;
        } else {
          // Use both log for DevTools and print for console output
          log(
            'RPC Error in transaction.\n'
            'Function: $funcName\n'
            'Args: $args\n'
            'Error message: ${e.message}\n'
            'Error data: ${e.data}\n'
            'Data type: ${e.data?.runtimeType}',
            error: e,
            stackTrace: stackTrace,
          );

          // Add print statement for immediate console visibility
          print('==== RPC ERROR ====');
          print('Function: $funcName');
          print('Args: $args');
          print('Error message: ${e.message}');
          print('Error data: ${e.data}');
          print('Data type: ${e.data?.runtimeType}');
          print('===================');

          rethrow;
        }
      } else {
        log(
          'Failed to send transaction to contract.\n'
          'Function: $funcName\n'
          'Args: $args',
          error: e,
          stackTrace: stackTrace,
        );
        rethrow;
      }
    }
  }

  // Helper method to format error parameters for console output
  String _formatErrorParams(List<dynamic> params) {
    if (params.isEmpty) return 'None';

    final List<String> formattedParams = [];

    for (var param in params) {
      if (param is EthereumAddress) {
        formattedParams.add(param.hex);
      } else {
        formattedParams.add(param.toString());
      }
    }

    return formattedParams.join(', ');
  }

  Future<String> estimateGas({
    required String funcName,
    required List<dynamic> args,
    required EthereumAddress sender,
    EtherAmount? value,
    double gasPriceMultiplier = defaultGasLimitMultiplier,
  }) async {
    try {
      final DeployedContract contract = await _getContract();
      final ContractFunction ethFunction = contract.function(funcName);

      final gasEstimate = await web3Client.estimateGas(
        sender: sender,
        to: contract.address,
        data: ethFunction.encodeCall(args),
        value: value,
      );

      final BigInt finalGasLimit =
          BigInt.from(gasEstimate.toDouble() * gasPriceMultiplier);

      return finalGasLimit.toString();
    } catch (e, stackTrace) {
      log(
        'Failed to estimate gas.\nFunction: $funcName\nArgs: $args',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

// Custom exception class for Solidity errors
class SolidityCustomException implements Exception {
  final String message;
  final String errorName;
  final List<dynamic> params;
  final Exception originalError;

  SolidityCustomException({
    required this.message,
    required this.errorName,
    required this.params,
    required this.originalError,
  });

  @override
  String toString() {
    return 'SolidityCustomException: $message';
  }
}
