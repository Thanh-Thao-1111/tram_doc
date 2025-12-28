import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrCapturePage extends StatefulWidget {
  const OcrCapturePage({super.key});

  @override
  State<OcrCapturePage> createState() => _OcrCapturePageState();
}

class _OcrCapturePageState extends State<OcrCapturePage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  
  // 1. Khởi tạo bộ nhận diện văn bản
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  // Hàm khởi động Camera
  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high, // Chọn độ phân giải cao để đọc chữ rõ hơn
      enableAudio: false,
    );

    _initializeControllerFuture = _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    _textRecognizer.close(); // Nhớ đóng bộ nhận diện để tránh rò rỉ bộ nhớ
    super.dispose();
  }

  // Hàm xử lý chụp và đọc chữ
  Future<void> _scanImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() => _isProcessing = true);

    try {
      // 1. Chụp ảnh
      final image = await _controller!.takePicture();

      // 2. Tạo InputImage từ file ảnh vừa chụp
      final inputImage = InputImage.fromFilePath(image.path);

      // 3. Gọi Google ML Kit để đọc chữ
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      // 4. Lấy kết quả text
      String result = recognizedText.text;

      if (mounted) {
        if (result.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Không tìm thấy văn bản nào!")),
          );
        } else {
          // Trả kết quả về trang trước
          Navigator.pop(context, result);
        }
      }
    } catch (e) {
      print("Lỗi OCR: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Lỗi: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. MÀN HÌNH CAMERA (Thay cho Container đen)
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Camera đã sẵn sàng -> Hiển thị Preview
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CameraPreview(_controller!),
                );
              } else {
                // Đang tải Camera -> Hiện vòng xoay
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),

          // Lớp phủ mờ (Overlay) để làm nổi bật khung crop
          _buildOverlay(),

          // Nút Close
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Các nút điều khiển góc phải
          const Positioned(
            top: 50,
            right: 20,
            child: Row(
              children: [
                Icon(Icons.flash_off, color: Colors.white, size: 28),
                SizedBox(width: 20),
                Icon(Icons.grid_on, color: Colors.white, size: 28),
              ],
            ),
          ),

          // 2. KHUNG CROP Ở GIỮA
          Center(
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCorner(true, true),
                        _buildCorner(true, false),
                      ],
                    ),
                    if (_isProcessing)
                      const Column(
                        children: [
                          CircularProgressIndicator(color: Colors.green),
                          SizedBox(height: 10),
                          Text("Đang đọc văn bản...", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                        ],
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Giữ yên thiết bị\nOCR sẽ tự động trích xuất văn bản",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 12, shadows: [Shadow(blurRadius: 2, color: Colors.black)]),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCorner(false, true),
                        _buildCorner(false, false),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. NÚT CHỤP
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.photo_library, color: Colors.white, size: 32),
                ),
                
                // Nút Shutter kích hoạt hàm _scanImage
                GestureDetector(
                  onTap: _isProcessing ? null : _scanImage, // Bấm chụp
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 32), // Placeholder cân đối
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget làm tối vùng bên ngoài khung crop
  Widget _buildOverlay() {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.5),
        BlendMode.srcOut,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              backgroundBlendMode: BlendMode.dstOut,
            ),
          ),
          Center(
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(bool isTop, bool isLeft) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: Colors.green, width: 3) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: Colors.green, width: 3) : BorderSide.none,
          left: isLeft ? const BorderSide(color: Colors.green, width: 3) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: Colors.green, width: 3) : BorderSide.none,
        ),
      ),
    );
  }
}