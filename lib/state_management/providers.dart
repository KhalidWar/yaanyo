import 'package:flutter_riverpod/all.dart';
import 'package:yaanyo/services/auth_service.dart';
import 'package:yaanyo/services/database/shopping_database_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

final shoppingDatabaseServiceProvider =
    Provider((ref) => ShoppingDatabaseService());
