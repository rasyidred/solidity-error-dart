import 'package:solidity_error/contract_helper.dart';
import 'package:web3dart/web3dart.dart';
import 'package:solidity_error/abi/abi.dart';

// This class is a wrapper for the target contract
class SolidityError extends ContractHelper {
  SolidityError({
    required super.address,
    required super.web3Client,
  });

  /// @notice Loads the contract
  /// @dev Caches the contract instance for reuse
  /// @return DeployedContract instance of the PureWallet contract
  @override
  Future<DeployedContract> loadContract() async {
    return DeployedContract(
      ContractAbi.fromJson(abi, 'Solidity Error'),
      address,
    );
  }

  // Function to call setAddressZero
  Future<String> revertAddressZero(
    String privateKey,
  ) async {
    return await sendTx(
      funcName: 'revertAddressZero',
      args: [],
      privateKey: privateKey,
    );
  }

  Future<String> revertAlreadyCommitted(
    String commitTime,
    String privateKey,
  ) async {
    return await sendTx(
      funcName: 'revertAlreadyCommitted',
      args: [BigInt.parse(commitTime)],
      privateKey: privateKey,
    );
  }

  Future<String> revertCodeExpired(
    String deadline,
    String currentTime,
    String privateKey,
  ) async {
    return await sendTx(
      funcName: 'revertCodeExpired',
      args: [BigInt.parse(deadline), BigInt.parse(currentTime)],
      privateKey: privateKey,
    );
  }

  Future<String> revertCommitmentInactive(
    String privateKey,
  ) async {
    return await sendTx(
      funcName: 'revertCommitmentInactive',
      args: [],
      privateKey: privateKey,
    );
  }

  Future<String> revertCommitmentInvalid(
    String privateKey,
  ) async {
    return await sendTx(
      funcName: 'revertCommitmentInvalid',
      args: [],
      privateKey: privateKey,
    );
  }

  Future<String> revertDirectEthTransferNotAllowed(
    String privateKey,
  ) async {
    return await sendTx(
      funcName: 'revertDirectEthTransferNotAllowed',
      args: [],
      privateKey: privateKey,
    );
  }

  Future<String> revertFunctionDoesNotExist(
    String privateKey,
  ) async {
    return await sendTx(
      funcName: 'revertFunctionDoesNotExist',
      args: [],
      privateKey: privateKey,
    );
  }

  Future<String> revertInsufficient(
    String value,
    String privateKey,
  ) async {
    return await sendTx(
      funcName: 'revertInsufficient',
      args: [BigInt.parse(value)],
      privateKey: privateKey,
    );
  }

  Future<String> revertNoCommitmentFound(
    String privateKey,
  ) async {
    return await sendTx(
      funcName: 'revertNoCommitmentFound',
      args: [],
      privateKey: privateKey,
    );
  }

  Future<String> revertReferralCodeInvalid(
    String privateKey,
  ) async {
    return await sendTx(
      funcName: 'revertReferralCodeInvalid',
      args: [],
      privateKey: privateKey,
    );
  }
}
