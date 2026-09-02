import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

enum OrderStatus {
  placed,
  preparing,
  outForDelivery,
  delivered;

  String get displayName {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.preparing:
        return 'Kitchen Preparing';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  static OrderStatus fromString(String value) {
    switch (value) {
      case 'placed':
        return OrderStatus.placed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'outForDelivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      default:
        return OrderStatus.placed;
    }
  }
}

class FoodOrder {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double taxes;
  final double totalAmount;
  final OrderStatus status;
  final DateTime orderTime;
  final String deliveryAddress;
  final String paymentMethod;
  final String estimatedDeliveryTime;
  final String driverName;
  final String driverPhone;

  const FoodOrder({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.taxes,
    required this.totalAmount,
    required this.status,
    required this.orderTime,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.estimatedDeliveryTime = '25 - 35 min',
    this.driverName = 'Rajesh Kumar',
    this.driverPhone = '+91 98765 43210',
  });

  factory FoodOrder.fromJson(Map<String, dynamic> json) {
    // Handle Firestore Timestamp or DateTime
    DateTime orderTime;
    final rawTime = json['orderTime'];
    if (rawTime is Timestamp) {
      orderTime = rawTime.toDate();
    } else if (rawTime is String) {
      orderTime = DateTime.parse(rawTime);
    } else {
      orderTime = DateTime.now();
    }

    return FoodOrder(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      taxes: (json['taxes'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: OrderStatus.fromString(json['status'] as String),
      orderTime: orderTime,
      deliveryAddress: json['deliveryAddress'] as String,
      paymentMethod: json['paymentMethod'] as String,
      estimatedDeliveryTime:
          json['estimatedDeliveryTime'] as String? ?? '25 - 35 min',
      driverName: json['driverName'] as String? ?? 'Rajesh Kumar',
      driverPhone: json['driverPhone'] as String? ?? '+91 98765 43210',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((i) => i.toJson()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'deliveryFee': deliveryFee,
      'taxes': taxes,
      'totalAmount': totalAmount,
      'status': status.name,
      'orderTime': Timestamp.fromDate(orderTime),
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'driverName': driverName,
      'driverPhone': driverPhone,
    };
  }
}
