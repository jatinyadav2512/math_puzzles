import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:math_riddles/providers/app_state.dart';

/// Service handling Google Play Billing for Premium access.
class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  static const String premiumProductId = 'premium_3_months';

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Initializes the purchase stream listener.
  void initialize(AppState appState) {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdates(purchaseDetailsList, appState);
      },
      onDone: () => _subscription?.cancel(),
      onError: (error) => debugPrint('Purchase stream error: $error'),
    );
  }

  /// Handles purchase updates and unlocks premium if successful.
  Future<void> _listenToPurchaseUpdates(List<PurchaseDetails> purchaseDetailsList, AppState appState) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased || 
          purchaseDetails.status == PurchaseStatus.restored) {
        
        // Unlock premium for 90 days
        appState.unlockPremium();
        
        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  /// Triggers the purchase flow for the premium product.
  Future<bool> buyPremium() async {
    final ProductDetailsResponse response = await _iap.queryProductDetails({premiumProductId});
    
    if (response.productDetails.isEmpty) {
      debugPrint('Product not found: $premiumProductId');
      return false;
    }

    final ProductDetails productDetails = response.productDetails.first;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    
    // Using buyConsumable so the user can purchase again after the 3-month period expires.
    await _iap.buyConsumable(purchaseParam: purchaseParam);
    return true;
  }

  /// Restores previous purchases.
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  /// Fetches the current price for the premium product.
  Future<String?> getPremiumPrice() async {
    final ProductDetailsResponse response = await _iap.queryProductDetails({premiumProductId});
    if (response.productDetails.isNotEmpty) {
      return response.productDetails.first.price;
    }
    return null;
  }

  void dispose() {
    _subscription?.cancel();
  }
}

void debugPrint(String message) {
  print('[PurchaseService] $message');
}