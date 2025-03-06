import 'dart:developer';
import 'package:test/test.dart';
import 'test_config.dart';

void main() {
  setUpAll(() async {
    await TestConfig.initialize();
  });

  tearDownAll(() async {
    await TestConfig.dispose();
  });

  test('Call revertAddressZero', () async {
    String txHash = await TestConfig.target.revertAddressZero(
      TestConfig.senderPrivateKey,
    );

    log('Transaction hash: $txHash');
  });

  test('Call revertAlreadyCommitted', () async {
    String commitTime = '1234567890';
    String txHash = await TestConfig.target.revertAlreadyCommitted(
      commitTime,
      TestConfig.senderPrivateKey,
    );

    log('Transaction hash: $txHash');
  });

  // TODO calculate how long the time difference is
  test('Call revertCodeExpired', () async {
    String deadline = '1000';
    String currentTime = '5000';

    String txHash = await TestConfig.target.revertCodeExpired(
      deadline,
      currentTime,
      TestConfig.senderPrivateKey,
    );

    log('Transaction hash: $txHash');
  });

  test('Call revertCommitmentInactive', () async {
    String txHash = await TestConfig.target.revertCommitmentInactive(
      TestConfig.senderPrivateKey,
    );

    log('Transaction hash: $txHash');
  });

  test('Call revertCommitmentInvalid', () async {
    String txHash = await TestConfig.target.revertCommitmentInvalid(
      TestConfig.senderPrivateKey,
    );

    log('Transaction hash: $txHash');
  });

  test('Call revertDirectEthTransferNotAllowed', () async {
    String txHash = await TestConfig.target.revertDirectEthTransferNotAllowed(
      TestConfig.senderPrivateKey,
    );

    log('Transaction hash: $txHash');
  });

  test('Call revertFunctionDoesNotExist', () async {
    String txHash = await TestConfig.target.revertFunctionDoesNotExist(
      TestConfig.senderPrivateKey,
    );

    log('Transaction hash: $txHash');
  });

  test('Call revertInsufficient', () async {
    String value = '1000000000000000123';
    String txHash = await TestConfig.target.revertInsufficient(
      value,
      TestConfig.senderPrivateKey,
    );

    log('Transaction hash: $txHash');
  });

  test('Call revertNoCommitmentFound', () async {
    String txHash = await TestConfig.target.revertNoCommitmentFound(
      TestConfig.senderPrivateKey,
    );

    log('Transaction hash: $txHash');
  });

  test('Call revertReferralCodeInvalid', () async {
    String txHash = await TestConfig.target.revertReferralCodeInvalid(
      TestConfig.senderPrivateKey,
    );

    log('Transaction hash: $txHash');
  });
}
