import 'package:flutter_riverpod/all.dart';
import 'package:yaanyo/services/auth_service.dart';
import 'package:yaanyo/services/shopping_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

final shoppingServiceProvider = Provider((ref) => ShoppingService());
