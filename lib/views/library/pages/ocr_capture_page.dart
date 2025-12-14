import 'package:flutter/material.dart';

class OcrCapturePage extends StatelessWidget {
  const OcrCapturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 2. Các nút điều khiển Flash/Grid ở góc trên phải
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

          // 3. Khung Crop ở giữa (Mô phỏng)
          Center(
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Đặt tài liệu trong khung hình\nOCR sẽ tự động trích xuất văn bản",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 12),
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

          // 4. Khu vực nút chụp bên dưới
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Nút thư viện ảnh
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.photo_library,
                    color: Colors.white,
                    size: 32,
                  ),
                ),

                // Nút Shutter (Chụp)
                Container(
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

                // Placeholder 
                const SizedBox(width: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget trang trí 4 góc crop
  Widget _buildCorner(bool isTop, bool isLeft) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: Colors.green, width: 3)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: Colors.green, width: 3)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: Colors.green, width: 3)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: Colors.green, width: 3)
              : BorderSide.none,
        ),
      ),
    );
  }
}
