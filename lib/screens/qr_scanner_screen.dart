// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:provider/provider.dart';
// import '../providers/event_provider.dart';
// import '../theme/app_theme.dart';
// import 'attendee_details_screen.dart';

// class QrScannerScreen extends StatefulWidget {
//   final String eventId;
//   const QrScannerScreen({super.key, required this.eventId});

//   @override
//   State<QrScannerScreen> createState() => _QrScannerScreenState();
// }

// class _QrScannerScreenState extends State<QrScannerScreen> {
//   final MobileScannerController _controller = MobileScannerController(
//     detectionSpeed: DetectionSpeed.noDuplicates,
//   );
//   bool _handled = false;

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _onDetect(BarcodeCapture capture) {
//     if (_handled) return;
//     final code = capture.barcodes.firstOrNull?.rawValue;
//     if (code == null) return;
//     _handled = true;

//     final attendee = context.read<EventProvider>().lookupByQr(code);

//     Navigator.of(context)
//         .push(
//       MaterialPageRoute(
//         builder: (_) => AttendeeDetailsScreen(
//           eventId: widget.eventId,
//           scannedCode: code,
//           attendee: attendee,
//         ),
//       ),
//     )
//         .then((_) {
//       // Allow scanning again once we return from the details screen.
//       if (mounted) setState(() => _handled = false);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//         title: const Text('Scan Ticket QR', style: TextStyle(color: Colors.white)),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.flash_on),
//             onPressed: () => _controller.toggleTorch(),
//           ),
//           IconButton(
//             icon: const Icon(Icons.cameraswitch),
//             onPressed: () => _controller.switchCamera(),
//           ),
//         ],
//       ),
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           MobileScanner(
//             controller: _controller,
//             onDetect: _onDetect,
//           ),
//           // Dim overlay with a cut-out scan frame.
//           IgnorePointer(
//             child: Center(
//               child: Container(
//                 width: 260,
//                 height: 260,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: AppColors.gold, width: 3),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 40,
//             left: 24,
//             right: 24,
//             child: Text(
//               'Align the QR code on the ticket within the frame',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white.withValues(alpha: 0.85),
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// extension _FirstOrNull<T> on List<T> {
//   T? get firstOrNull => isEmpty ? null : first;
// }



import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../theme/app_theme.dart';
import 'attendee_details_screen.dart';

class QrScannerScreen extends StatefulWidget {
  final String eventId;
  const QrScannerScreen({super.key, required this.eventId});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _handled = false;
  bool _looking = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled || _looking) return;
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null) return;
    debugPrint('QR raw value scanned: $code');
    _handled = true;
    // Ticket QRs encode "unique_number|name|mobile|attending_for" — the
    // scan API only wants the unique number (the Devotee.uniqueNumber
    // field in scan_model.dart), not the whole pipe-delimited string.
    final uniqueNumber = code.split('|').first.trim();
    _lookup(uniqueNumber);
  }

  Future<void> _lookup(String code) async {
    setState(() => _looking = true);

    final provider = context.read<EventProvider>();
    final scan = await provider.getScan(code);

    if (!mounted) return;
    setState(() => _looking = false);

    if (scan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.scanErrorMessage ?? 'Ticket not recognized.'),
          backgroundColor: AppColors.rust,
        ),
      );
      // Allow scanning again after the error is shown.
      _handled = false;
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AttendeeDetailsScreen(
          eventId: widget.eventId,
          scan: scan,
        ),
      ),
    );

    if (mounted) setState(() => _handled = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Scan Ticket QR', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error, child) {
              debugPrint(
                'MobileScanner error: ${error.errorCode.name} - ${error.errorDetails?.message}',
              );
              final isPermissionDenied =
                  error.errorCode == MobileScannerErrorCode.permissionDenied;
              return ColoredBox(
                color: Colors.black,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.videocam_off, color: Colors.white, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          isPermissionDenied
                              ? 'Camera permission was denied. Enable it in system settings to scan tickets.'
                              : 'Could not start the camera (${error.errorCode.name}).',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _controller.start(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          IgnorePointer(
            child: Center(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.gold, width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          if (_looking)
            Container(
              color: Colors.black.withValues(alpha: 0.55),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              ),
            ),
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Text(
              _looking
                  ? 'Looking up ticket...'
                  : 'Align the QR code on the ticket within the frame',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}