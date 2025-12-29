import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../services/google_books_service.dart';
import '../../../models/book_model.dart';
import 'add_bookshelf_page.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );
  final GoogleBooksService _googleBooksService = GoogleBooksService();

  bool _isProcessing = false;
  bool _hasScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing || _hasScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    final String? code = barcode.rawValue;

    if (code == null || code.isEmpty) return;

    // Check if it's an ISBN barcode (EAN-13 starting with 978 or 979)
    if (!_isValidISBN(code)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mã vạch không phải ISBN sách'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
      _hasScanned = true;
    });

    try {
      final BookModel? book = await _googleBooksService.getBookByISBN(code);

      if (!mounted) return;

      if (book != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AddBookPreviewPage(book: book),
          ),
        );
      } else {
        setState(() {
          _isProcessing = false;
          _hasScanned = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không tìm thấy sách với mã ISBN này'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _hasScanned = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _isValidISBN(String code) {
    // ISBN-13 starts with 978 or 979, ISBN-10 is 10 digits
    final cleanCode = code.replaceAll('-', '').replaceAll(' ', '');
    if (cleanCode.length == 13) {
      return cleanCode.startsWith('978') || cleanCode.startsWith('979');
    }
    if (cleanCode.length == 10) {
      return RegExp(r'^[0-9X]+$').hasMatch(cleanCode);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Quét Mã Vạch',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Camera Scanner
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Overlay with scanning frame
          Container(
            decoration: ShapeDecoration(
              shape: _ScannerOverlayShape(
                borderColor: Colors.green,
                borderWidth: 3,
                overlayColor: Colors.black.withOpacity(0.5),
                borderRadius: 12,
                borderLength: 30,
                cutOutSize: 260,
              ),
            ),
          ),

          // Loading indicator
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Đang tìm kiếm sách...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Đưa mã vạch ISBN vào khung hình',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),

          // Flash toggle button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.flash_on, color: Colors.white, size: 32),
                onPressed: () => _controller.toggleTorch(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom scanner overlay shape
class _ScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const _ScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 12,
    this.borderLength = 30,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: rect.center,
          width: cutOutSize,
          height: cutOutSize,
        ),
        Radius.circular(borderRadius),
      ));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path.combine(
      PathOperation.difference,
      Path()..addRect(rect),
      getInnerPath(rect),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(getOuterPath(rect), paint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final cutOutRect = Rect.fromCenter(
      center: rect.center,
      width: cutOutSize,
      height: cutOutSize,
    );

    // Draw corner borders
    final corners = [
      // Top-left
      [Offset(cutOutRect.left, cutOutRect.top + borderLength), cutOutRect.topLeft, Offset(cutOutRect.left + borderLength, cutOutRect.top)],
      // Top-right  
      [Offset(cutOutRect.right - borderLength, cutOutRect.top), cutOutRect.topRight, Offset(cutOutRect.right, cutOutRect.top + borderLength)],
      // Bottom-right
      [Offset(cutOutRect.right, cutOutRect.bottom - borderLength), cutOutRect.bottomRight, Offset(cutOutRect.right - borderLength, cutOutRect.bottom)],
      // Bottom-left
      [Offset(cutOutRect.left + borderLength, cutOutRect.bottom), cutOutRect.bottomLeft, Offset(cutOutRect.left, cutOutRect.bottom - borderLength)],
    ];

    for (final corner in corners) {
      final path = Path()
        ..moveTo(corner[0].dx, corner[0].dy)
        ..lineTo(corner[1].dx, corner[1].dy)
        ..lineTo(corner[2].dx, corner[2].dy);
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  ShapeBorder scale(double t) => this;
}
