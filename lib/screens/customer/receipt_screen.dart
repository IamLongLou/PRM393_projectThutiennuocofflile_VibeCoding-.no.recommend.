import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/customer.dart';
import '../../models/bill.dart';
import 'package:intl/intl.dart';

class ReceiptScreen extends StatefulWidget {
  final Customer customer;
  final Bill bill;
  const ReceiptScreen({super.key, required this.customer, required this.bill});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _shareReceipt() async {
    try {
      final Uint8List? imageBytes = await _screenshotController.capture(
        delay: const Duration(milliseconds: 100),
        pixelRatio: 2.0,
      );

      if (imageBytes != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = await File('${directory.path}/receipt_${widget.bill.billCode}.png').create();
        await imagePath.writeAsBytes(imageBytes);

        await Share.shareXFiles(
          [XFile(imagePath.path)],
          text: 'Biên lai tiền nước - ${widget.customer.name} - ${widget.bill.billCode}',
        );
      }
    } catch (e) {
      debugPrint('Error sharing receipt: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi khi chia sẻ biên lai')),
        );
      }
    }
  }

  Future<void> _printReceipt() async {
    try {
      final Uint8List? imageBytes = await _screenshotController.capture(
        delay: const Duration(milliseconds: 100),
        pixelRatio: 2.0,
      );

      if (imageBytes != null) {
        await Printing.layoutPdf(
          onLayout: (format) async => imageBytes,
          name: 'Biên lai ${widget.bill.billCode}',
        );
      }
    } catch (e) {
      debugPrint('Error printing receipt: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi khi in biên lai')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Biên lai điện tử', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: _shareReceipt,
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined, color: Colors.black),
            onPressed: _printReceipt,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.check_circle, color: Colors.black, size: 50),
            const SizedBox(height: 15),
            const Text('Thanh toán thành công!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text('Giao dịch của bạn đã được ghi nhận', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 5),
            const Text('Đã hoàn thành', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 30),
            Screenshot(
              controller: _screenshotController,
              child: _buildMainReceipt(format),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Về màn hình chính', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Text('bản quyền thuộc về FieldFlow © 2024', style: TextStyle(color: Colors.grey, fontSize: 10)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMainReceipt(NumberFormat format) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF2196F3),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.water_drop, color: Colors.black, size: 24),
                    SizedBox(width: 8),
                    Text('FieldFlow', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('MÃ HÓA ĐƠN', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(widget.bill.billCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Padding(padding: EdgeInsets.symmetric(vertical: 25), child: Divider(height: 1, color: Colors.grey, thickness: 0.1)),
                
                _infoItem(Icons.person_outline, 'Khách hàng', widget.customer.name, 'ID: ${widget.customer.code}'),
                const SizedBox(height: 20),
                _infoItem(Icons.location_on_outlined, 'Địa chỉ', widget.customer.address, null),
                const SizedBox(height: 20),
                _infoItem(Icons.calendar_today_outlined, 'Thời gian', DateFormat('dd/MM/yyyy HH:mm').format(widget.bill.date), null),
                
                const Padding(padding: EdgeInsets.symmetric(vertical: 25), child: Divider(height: 1, color: Colors.grey, thickness: 0.1)),
                
                _billDetail('Chỉ số cũ', '${widget.bill.oldReading} m³'),
                _billDetail('Chỉ số mới', '${widget.bill.newReading} m³'),
                _billDetail('Tiêu thụ', '${widget.bill.consumption.toInt()} m³', isBlue: true),
                _billDetail('Đơn giá', '12.000đ'),
                _billDetail('VAT (10%)', format.format(widget.bill.vat)),
                
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F7FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('TỔNG TIỀN', style: TextStyle(color: Color(0xFF2196F3), fontWeight: FontWeight.bold, fontSize: 12)),
                      Text(format.format(widget.bill.totalAmount), style: const TextStyle(color: Color(0xFF2196F3), fontWeight: FontWeight.bold, fontSize: 22)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                  ),
                  child: Image.network(
                    'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${widget.bill.billCode}',
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.qr_code, size: 80, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 15),
                const Text('Quét mã QR để kiểm tra tính hợp lệ của hóa\nđơn trên hệ thống FieldFlow', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value, String? subValue) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Color(0xFFF0F7FF), shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: const Color(0xFF2196F3)),
      ),
      const SizedBox(width: 15),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            if (subValue != null) Text(subValue, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    ],
  );

  Widget _billDetail(String label, String value, {bool isBlue = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isBlue ? const Color(0xFF2196F3) : Colors.black87)),
      ],
    ),
  );
}
