class OtpUriData {
  final String issuer;
  final String account;
  final String secret;
  final String algorithm;
  final int digits;
  final int period;

  const OtpUriData({
    required this.issuer,
    required this.account,
    required this.secret,
    this.algorithm = 'SHA1',
    this.digits = 6,
    this.period = 30,
  });

  @override
  String toString() {
    return 'OtpUriData(issuer: $issuer, account: $account, algorithm: $algorithm, digits: $digits, period: $period)';
  }
}
