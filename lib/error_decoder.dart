// ignore_for_file: constant_identifier_names

import 'package:web3dart/web3dart.dart';

enum ErrorType {
  AddressZero,
  AlreadyCommitted,
  CodeExpired,
  CommitmentInactive,
  CommitmentInvalid,
  DirectEthTransferNotAllowed,
  FunctionDoesNotExist,
  Insufficient,
  NoCommitmentFound,
  ReferralCodeInvalid,
  RevealNotAllowed,
  SignatureInvalid,
  TokenExist,
  WalletStatus,
  Unknown,
}

enum DataType {
  address,
  bool,
  uint256,
  bytes32,
}

class ErrorDecoder {
  // Map error signatures to their names and parameter types
  static final Map<String, ErrorInfo> _errorSignatures = {
    '0x9fabe1c1': ErrorInfo(
      '${ErrorType.AddressZero.name}()',
      [],
    ),
    '0x1b6804f4': ErrorInfo(
      '${ErrorType.AlreadyCommitted.name}(${DataType.uint256.name})',
      [DataType.uint256.name],
    ),
    '0x0167c17d': ErrorInfo(
      '${ErrorType.CodeExpired.name}(${DataType.uint256.name}, ${DataType.uint256.name})',
      [DataType.uint256.name, DataType.uint256.name],
    ),
    '0x9dcdb076': ErrorInfo(
      '${ErrorType.CommitmentInactive.name}()',
      [],
    ),
    '0xa3a93fee': ErrorInfo(
      '${ErrorType.CommitmentInvalid.name}()',
      [],
    ),
    '0x161a0f06': ErrorInfo(
      '${ErrorType.DirectEthTransferNotAllowed.name}()',
      [],
    ),
    '0xa9ad62f8': ErrorInfo(
      '${ErrorType.FunctionDoesNotExist.name}()',
      [],
    ),
    '0x91bcc564': ErrorInfo(
      '${ErrorType.Insufficient.name}(${DataType.uint256.name})',
      [DataType.uint256.name],
    ),
    '0xc6c155d8': ErrorInfo(
      '${ErrorType.NoCommitmentFound.name}()',
      [],
    ),
    '0x35af8267': ErrorInfo(
      '${ErrorType.ReferralCodeInvalid.name}()',
      [],
    ),
    '0x44300a99': ErrorInfo(
      '${ErrorType.RevealNotAllowed.name}()',
      [],
    ),
    '0xd6fe72d8': ErrorInfo(
      '${ErrorType.SignatureInvalid.name}(${DataType.bytes32.name})',
      [DataType.bytes32.name],
    ),
    '0x8bc4193e': ErrorInfo(
      '${ErrorType.TokenExist.name}()',
      [],
    ),
    '0xb4c62e27': ErrorInfo(
      '${ErrorType.WalletStatus.name}(${DataType.address.name},${DataType.bool.name})',
      [DataType.address.name, DataType.bool.name],
    ),
  };

  // Decode an error from a transaction
  static DecodedError decodeError(String errorData) {
    int sigLength = 10; //the error signature (first 4 bytes + 0x prefix)

    if (errorData.length < sigLength) {
      return DecodedError('Unknown', 'Error data too short', []);
    }

    // Extract the error signature (first 4 bytes + 0x prefix)
    final signature = errorData.substring(0, sigLength);
    final ErrorInfo? errorInfo = _errorSignatures[signature];

    if (errorInfo == null) {
      return DecodedError('Unknown', 'Error signature not found', []);
    }

    // If there are no parameters, just return the error name
    if (errorInfo.paramTypes.isEmpty) {
      return DecodedError(errorInfo.name, errorInfo.name, []);
    }

    // Parse parameters from error data
    try {
      final params = _decodeParameters(
        errorData.substring(sigLength),
        errorInfo.paramTypes,
      );
      return DecodedError(
        errorInfo.name,
        _formatErrorMessage(errorInfo.name, params),
        params,
      );
    } catch (e) {
      return DecodedError(
        errorInfo.name,
        'Error parsing parameters: $e',
        [],
      );
    }
  }

  // Format a human-readable error message
  static String _formatErrorMessage(String errorName, List<dynamic> params) {
    // Extract base name without parameters
    final baseName = errorName.split('(')[0];

    switch (baseName) {
      case 'AddressZero':
        return 'Address cannot be zero';
      case 'WalletStatus':
        final address = params[0] as EthereumAddress;
        final isActive = params[1] as bool;
        return 'Wallet ${address.hex} is ${isActive ? 'active' : 'inactive'}';
      case 'AlreadyCommitted':
        return 'Already committed on timestamp: ${params[0]}';
      case 'CodeExpired':
        final deadline = params[0] as BigInt;
        final currentTime = params[1] as BigInt;
        final difference = currentTime - deadline;

        return 'Code expired $difference seconds ago. Deadline: $deadline, current time: $currentTime.';
      // Add other error message formats as needed

      default:
        // Return a generic message with parameters
        // Useful for errors without parameter-specific messages
        return '$errorName: ${params.join(', ')}';
    }
  }

  // Decode parameters based on their Solidity types
  static List<dynamic> _decodeParameters(String data, List<String> types) {
    final List<dynamic> result = [];
    int offset = 0;

    for (final type in types) {
      final decodedValue = _decodeSingleParameter(data, offset, type);
      result.add(decodedValue.value);
      offset += decodedValue.bytesUsed;
    }

    return result;
  }

  // Decode a single parameter
  static DecodedValue _decodeSingleParameter(
    String data,
    int offset,
    String type,
  ) {
    // 64 hex characters = 32 bytes
    int charLength = 64;
    // Hexadecimal or base 16 (remember that Ethereum uses base 16)
    int baseNumber = 16;

    // Make sure data has '0x' prefix removed and is padded properly
    if (data.startsWith('0x')) {
      data = data.substring(2);
    }

    // Ensure data is long enough
    if (offset + charLength > data.length) {
      throw 'Data too short for parameter of type $type';
    }

    String chunk = data.substring(offset, offset + charLength);

    switch (type) {
      case 'address':
        // Ethereum addresses are 20 bytes, padded to 32 bytes
        // The first 12 bytes (24 chars) are zero, so we can skip them
        int paddedZeroesLen = 24;
        String addressHex = '0x${chunk.substring(paddedZeroesLen)}';
        return DecodedValue(EthereumAddress.fromHex(addressHex), charLength);

      case 'bool':
        // Booleans are represented as 0 or 1
        bool boolValue = BigInt.parse(chunk, radix: baseNumber) != BigInt.zero;
        return DecodedValue(boolValue, charLength);

      case 'uint256':
        BigInt intValue = BigInt.parse(chunk, radix: baseNumber);
        return DecodedValue(intValue, charLength);

      case 'bytes32':
        return DecodedValue('0x$chunk', charLength);

      // Add more types as needed

      default:
        throw 'Unsupported parameter type: $type';
    }
  }
}

// Class to hold error signature information
class ErrorInfo {
  final String name;
  final List<String> paramTypes;

  ErrorInfo(this.name, this.paramTypes);
}

// Class to hold decoded values with bytes used for parsing
class DecodedValue {
  final dynamic value;
  final int bytesUsed;

  DecodedValue(this.value, this.bytesUsed);
}

// Class to represent a decoded error
class DecodedError {
  final String name;
  final String message;
  final List<dynamic> params;

  DecodedError(this.name, this.message, this.params);

  @override
  String toString() {
    return message;
  }
}
