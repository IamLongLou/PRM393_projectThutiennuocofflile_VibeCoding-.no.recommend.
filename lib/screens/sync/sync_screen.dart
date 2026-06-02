import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/billing_provider.dart';
import '../../routes/app_routes.dart';
import '../../models/bill.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  bool _isSyncing = false;

  Future<void> _handleSync(BuildContext context) async {
    final billingProvider = context.read<BillingProvider>();
    final unsyncedBills = (await billingProvider.getAllBills()).where((b) => !b.isSynced).toList();

    if (unsyncedBills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có dữ liệu mới cần đồng bộ.')),
      );
      return;
    }

    setState(() => _isSyncing = true);

    // Giả lập gửi dữ liệu lên server
    await Future.delayed(const Duration(seconds: 2));

    // Cập nhật trạng thái đã đồng bộ cho các bill
    for (var bill in unsyncedBills) {
      bill.isSynced = true;
    }

    setState(() => _isSyncing = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đồng bộ thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final billingProvider = context.watch<BillingProvider>();
    return FutureBuilder<List<Bill>>(
      future: billingProvider.getAllBills(),
      builder: (context, snapshot) {
        final allBills = snapshot.data ?? [];
        final unsyncedBills = allBills.where((b) => !b.isSynced).toList();

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Trung tâm Đồng bộ', style: TextStyle(fontWeight: FontWeight.bold)),
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: Column(
            children: [
              _buildHeader(unsyncedBills.length),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('DANH SÁCH PHIẾU THU', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(5)),
                      child: Text('${unsyncedBills.length} bản ghi', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    )
                  ],
                ),
              ),
              Expanded(
                child: unsyncedBills.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: unsyncedBills.length,
                        itemBuilder: (context, index) => _syncCard(unsyncedBills[index]),
                      ),
              ),
              _infoBox(),
              _buildSyncButton(context, unsyncedBills.length),
            ],
          ),
          bottomNavigationBar: _buildBottomNav(context),
        );
      },
    );
  }

  Widget _buildHeader(int count) {
    final bool hasData = count > 0;
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: hasData ? const Color(0xFF00E5FF) : Colors.green[400],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(hasData ? Icons.wifi_off : Icons.cloud_done, color: Colors.white),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasData ? 'Cần Đồng Bộ' : 'Đã Đồng Bộ',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  hasData ? '$count bản ghi đang chờ đẩy lên hệ thống' : 'Dữ liệu của bạn đã được cập nhật mới nhất',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Text(
              hasData ? 'Pending' : 'Synced',
              style: TextStyle(
                color: hasData ? const Color(0xFF00E5FF) : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _syncCard(Bill bill) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('MÃ PHIẾU: ${bill.billCode}', style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.cyan.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(10)),
                child: const Text('CHỜ XỬ LÝ', style: TextStyle(color: Colors.cyan, fontSize: 9, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.person_pin, color: Colors.cyan, size: 18),
              const SizedBox(width: 10),
              Text('Khách hàng: ${bill.customerId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 8),
              Text(DateFormat('dd/MM/yyyy, HH:mm').format(bill.date), style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const Divider(height: 30, thickness: 0.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng thanh toán:', style: TextStyle(color: Colors.black54, fontSize: 12)),
              Text(currencyFormat.format(bill.totalAmount), style: const TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_done_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 15),
          const Text('Tuyệt vời!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text('Tất cả dữ liệu đã được đồng bộ', style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _infoBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.cyan.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.1)),
      ),
      child: const Column(
        children: [
          Icon(Icons.info_outline, color: Colors.cyan, size: 30),
          SizedBox(height: 10),
          Text(
            'Dữ liệu sẽ được lưu trữ an toàn trên thiết bị cho đến\nkhi quá trình đồng bộ hoàn tất.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.cyan, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncButton(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: _isSyncing ? null : () => _handleSync(context),
            icon: _isSyncing 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.sync),
            label: Text(_isSyncing ? 'Đang đồng bộ...' : 'Đồng bộ Ngay'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E5FF),
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          const SizedBox(height: 10),
          const Text('YÊU CẦU KẾT NỐI INTERNET (4G/WIFI)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 2,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 0) Navigator.pushReplacementNamed(context, AppRoutes.home);
        if (index == 1) Navigator.pushReplacementNamed(context, AppRoutes.statistics);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payment'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Sync'),
      ],
    );
  }
}
