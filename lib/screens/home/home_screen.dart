import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final DateFormat formatter = DateFormat('EEEE, d MMMM, yyyy', 'vi_VN');
    final String formattedDate = formatter.format(now);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Chào buổi sáng, 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Hôm nay: $formattedDate', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 20),
                    _buildReadyBanner(),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildStatCard('42', 'CHƯA GHI', Colors.orange),
                        const SizedBox(width: 15),
                        _buildStatCard('158', 'HOÀN TẤT', Colors.green),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CHỨC NĂNG CHÍNH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Xem tất cả', style: TextStyle(color: Colors.blue, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildFunctionGrid(context),
                    const SizedBox(height: 20),
                    _buildNoticeBanner(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.water_drop, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          const Text('Water Billing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          const Stack(
            children: [
              Icon(Icons.notifications_none, size: 28),
              Positioned(right: 0, top: 0, child: CircleAvatar(radius: 5, backgroundColor: Colors.red)),
            ],
          ),
          const SizedBox(width: 15),
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a'),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyBanner() {
    final String lastSync = DateFormat('HH:mm a').format(DateTime.now().subtract(const Duration(minutes: 45)));
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Dữ liệu đã sẵn sàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Đồng bộ lần cuối: $lastSync', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.green)),
            child: const Text('Ổn định', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
        child: Row(
          children: [
            Icon(Icons.access_time, color: color, size: 24),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildFunctionGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.2,
      children: [
        _funcCard(context, 'Khách hàng', 'Danh sách hộ dân & ghi chỉ số nước', Icons.people_outline, Colors.blue, AppRoutes.customerList, hasBadge: true),
        _funcCard(context, 'Đồng bộ', 'Tải lên kết quả & cập nhật dữ liệu', Icons.sync, Colors.green, AppRoutes.sync),
        _funcCard(context, 'Thống kê', 'Báo cáo sản lượng & hiệu suất thu', Icons.bar_chart, Colors.purple, AppRoutes.statistics),
        _funcCard(context, 'Lịch sử', 'Nhật ký hoạt động & biên lai đã xuất', Icons.history, Colors.grey, AppRoutes.history),
      ],
    );
  }

  Widget _funcCard(BuildContext context, String title, String desc, IconData icon, Color color, String route, {bool hasBadge = false}) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 10), maxLines: 2),
              ],
            ),
          ),
          if (hasBadge)
            Positioned(
              right: 10, top: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: const Text('12', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoticeBanner() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(15)),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Thông báo từ hệ thống', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 4),
                Text('Khu vực Phường 5 đang có lịch bảo trì đường ống vào ngày mai. Vui lòng nhắc nhở các hộ dân tích trữ nước.', 
                  style: TextStyle(color: Colors.black54, fontSize: 12)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 1) Navigator.pushReplacementNamed(context, AppRoutes.statistics);
        if (index == 2) Navigator.pushReplacementNamed(context, AppRoutes.sync);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payment'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Sync'),
      ],
    );
  }
}
