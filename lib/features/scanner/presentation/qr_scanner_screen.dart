import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/services/qr_parser_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../accounts/domain/models/account.dart';
import '../../accounts/domain/models/otp_uri_data.dart';
import '../../accounts/presentation/account_providers.dart';
import 'import_success_screen.dart';

class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key});

  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false;
  Account? _importedAccount;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final rawValue = barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      final uriData = QrParserService.parseUri(rawValue);
      final account = await ref
          .read(accountRepositoryProvider)
          .addAccount(uriData);

      if (mounted) {
        setState(() {
          _importedAccount = account;
        });
      }
    } catch (e) {
      if (mounted) {
        CustomToast.show(context, e.toString(), isError: true);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) setState(() => _isProcessing = false);
        });
      }
    }
  }

  void _showManualEntryDialog() {
    final issuerController = TextEditingController();
    final accountController = TextEditingController();
    final secretController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: context.colors.paper,
        title: Text('Enter Key Manually', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: issuerController,
                decoration: InputDecoration(labelText: 'Issuer (e.g. GitHub)'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: accountController,
                decoration: InputDecoration(labelText: 'Account / Email'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: secretController,
                decoration: InputDecoration(labelText: 'Secret Key (Base32)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text('Cancel', style: TextStyle(color: context.colors.ink2)),
          ),
          ElevatedButton(
            onPressed: () async {
              final issuer = issuerController.text.trim();
              final accountName = accountController.text.trim();
              final secret = secretController.text.trim();

              if (issuer.isEmpty || accountName.isEmpty || secret.isEmpty) {
                CustomToast.show(dialogCtx, 'Please fill in all fields', isError: true);
                return;
              }

              try {
                final uriData = OtpUriData(
                  issuer: issuer,
                  account: accountName,
                  secret: secret,
                );
                final account = await ref
                    .read(accountRepositoryProvider)
                    .addAccount(uriData);

                if (mounted) {
                  Navigator.pop(dialogCtx);
                  setState(() {
                    _importedAccount = account;
                  });
                }
              } catch (e) {
                CustomToast.show(dialogCtx, 'Invalid secret key format', isError: true);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_importedAccount != null) {
      return ImportSuccessScreen(
        account: _importedAccount!,
        onScanAnother: () {
          setState(() {
            _importedAccount = null;
            _isProcessing = false;
          });
        },
      );
    }

    return Scaffold(
      backgroundColor: context.colors.ink,
      body: SafeArea(
        child: Stack(
          children: [
            MobileScanner(
              controller: _scannerController,
              onDetect: _onDetect,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 21.0, vertical: 14.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Bar Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Text(
                          'CLOSE',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.0,
                            color: Color(0xFFC9C7BE),
                          ),
                        ),
                      ),
                      Text(
                        'SCAN',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.0,
                          color: Color(0xFF7A786F),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _scannerController.toggleTorch(),
                        child: Text(
                          'TORCH',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.0,
                            color: Color(0xFFC9C7BE),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Corner Ticks Finder Frame
                  Center(
                    child: SizedBox(
                      width: 170,
                      height: 170,
                      child: Stack(
                        children: [
                          // Top Left
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: context.colors.paper, width: 1.5),
                                  top: BorderSide(color: context.colors.paper, width: 1.5),
                                ),
                              ),
                            ),
                          ),
                          // Top Right
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: context.colors.paper, width: 1.5),
                                  top: BorderSide(color: context.colors.paper, width: 1.5),
                                ),
                              ),
                            ),
                          ),
                          // Bottom Left
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: context.colors.paper, width: 1.5),
                                  bottom: BorderSide(color: context.colors.paper, width: 1.5),
                                ),
                              ),
                            ),
                          ),
                          // Bottom Right
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: context.colors.paper, width: 1.5),
                                  bottom: BorderSide(color: context.colors.paper, width: 1.5),
                                ),
                              ),
                            ),
                          ),
                          // Accent Scan Line
                          Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 14),
                              height: 1,
                              color: context.colors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Manual Entry & Hint
                  Column(
                    children: [
                      Text(
                        'Hold steady over the QR code.\nHypAuth imports it the moment it reads.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9C9A91),
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _showManualEntryDialog,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFFC9C7BE),
                            side: BorderSide(color: Color(0xFF3A3835), width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text('Enter key manually'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
