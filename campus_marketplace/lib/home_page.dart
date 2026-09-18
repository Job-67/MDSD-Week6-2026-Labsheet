import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/item.dart';
import 'models/favorites_model.dart';
import 'models/cart_model.dart';
import 'repositories/item_repository.dart';
import 'widgets/item_list_section.dart';
import 'favorites_page.dart';
import 'cart_page.dart';

class HomePage extends StatefulWidget {
  final ItemRepository repository;

  const HomePage({super.key, required this.repository});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Item>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = widget.repository.getItems();
  }

  void _retry() {
    setState(() {
      _itemsFuture = widget.repository.getItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Marketplace'),
        actions: [
          IconButton(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite),
                // .watch ทำให้ตัวเลขนี้อัปเดตเองทุกครั้งที่ FavoritesModel เปลี่ยน ไม่ว่าจะเปลี่ยนจากจุดไหน
                Text(' ${context.watch<FavoritesModel>().itemCount}'),
              ],
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesPage()),
            ),
          ),
          IconButton(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shopping_cart),
                // .watch ทำให้ตัวเลขนี้อัปเดตเองทุกครั้งที่ CartModel เปลี่ยน ไม่ว่าจะเปลี่ยนจากจุดไหน
                Text(' ${context.watch<CartModel>().itemCount}'),
              ],
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Item>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final message = snapshot.error is Exception
                ? snapshot.error.toString().replaceFirst('Exception: ', '')
                : 'เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ';
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _retry,
                      child: const Text('ลองใหม่'),
                    ),
                  ],
                ),
              ),
            );
          }

          final catalog = snapshot.data ?? [];
          return ItemListSection(catalog: catalog);
        },
      ),
    );
  }
}
