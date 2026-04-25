import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_supabase_riverpod/src/core/theme/app_text_style.dart';
import 'package:iconsax/iconsax.dart';

import '../../../view_models/riverpods/cart_provider.dart';
import '../../../view_models/riverpods/parent_screen_provider.dart';
import '../../widgets/app_background.dart';
import '../../widgets/secondary_app_bar.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = AppTextStyle.auto(context);

    final cart = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: AppBackground(
        appBar: SecondaryAppBar(
          hasMore: true,
          title: "My Cart",
          onTapBack: () => ref.read(parentScreenProvider.notifier).setPage(0),
        ),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Expanded(
              child: cart.items.isEmpty
                  ? Center(
                      child: Text(
                        "No Products Found in the Cart",
                        style: textTheme.bodyMedium(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];

                        return _cartItem(
                          item: item,
                          onAdd: () => notifier.addItem(item.food),
                          onDecrease: () => notifier.decreaseItem(item.food),
                          onRemove: () => notifier.removeItem(item.cartId),
                        );
                      },
                    ),
            ),

            _buildBottomSection(
              subtotal: cart.subtotal,
              delivery: cart.deliveryFee,
              total: cart.total,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartItem({
    required dynamic item,
    required VoidCallback onAdd,
    required VoidCallback onDecrease,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.network(
              item.food.imageCard,
              height: 80.h,
              width: 80.w,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.food.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  item.food.specialItems,
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
                SizedBox(height: 8.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${item.food.price}",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),

                    Row(
                      children: [
                        _qtyButton(icon: item.quantity > 1 ? Icons.remove : Iconsax.trash, onTap: item.quantity > 1 ? onDecrease : onRemove),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Text(
                            "${item.quantity}",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),

                        _qtyButton(icon: Icons.add, onTap: onAdd),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28.w,
        width: 28.w,
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16.sp, color: Colors.red),
      ),
    );
  }

  Widget _buildBottomSection({
    required double subtotal,
    required double delivery,
    required double total,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _priceRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
          SizedBox(height: 8.h),
          _priceRow("Delivery", "\$${delivery.toStringAsFixed(2)}"),
          Divider(height: 24.h),
          _priceRow("Total", "\$${total.toStringAsFixed(2)}", isTotal: true),
          SizedBox(height: 16.h),

          Container(
            height: 55.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5F6D), Color(0xFFFF9966)],
              ),
            ),
            child: const Center(
              child: Text(
                "Checkout",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // PRICE ROW
  // =========================
  Widget _priceRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 16.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18.sp : 14.sp,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }
}
