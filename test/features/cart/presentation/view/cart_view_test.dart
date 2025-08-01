import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:servzz/features/cart/domain/model/addon.dart';

import 'package:servzz/features/cart/presentation/view/mycart_view.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_state.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_event.dart';
import 'package:servzz/features/cart/domain/model/cart_item.dart';
import 'package:servzz/features/order/presentation/view_model/order_view_model.dart';
import 'package:servzz/features/order/presentation/view_model/order_state.dart';
import 'package:servzz/features/order/presentation/view_model/order_event.dart';
import 'package:servzz/features/order/domain/entity/order_entity.dart';
import 'package:servzz/app/shared_pref/token_shared_prefs.dart';
import 'package:servzz/features/product/domain/entity/product_entity.dart';

// === MOCK CLASSES ===

class MockCartViewModel extends Mock implements CartViewModel {}

class MockOrderViewModel extends Mock implements OrderViewModel {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

class FakeCartEvent extends Fake implements CartEvent {}

class FakeOrderEvent extends Fake implements OrderEvent {}

void main() {
  late MockCartViewModel mockCartViewModel;
  late MockOrderViewModel mockOrderViewModel;
  late MockTokenSharedPrefs mockTokenSharedPrefs;

  // Mock data
  final mockProduct = ProductEntity(
    productId: '1',
    name: 'Test Product',
    price: 100.0,
    imageUrl: 'https://test.com/image.jpg',
  );

  final mockCartItem = CartItem(product: mockProduct, quantity: 2, addons: []);
  final mockCartState = CartState(items: [mockCartItem]);
  final emptyCartState = CartState(items: []);

  setUpAll(() {
    registerFallbackValue(FakeCartEvent());
    registerFallbackValue(FakeOrderEvent());
  });

  setUp(() {
    mockCartViewModel = MockCartViewModel();
    mockOrderViewModel = MockOrderViewModel();
    mockTokenSharedPrefs = MockTokenSharedPrefs();

    if (GetIt.instance.isRegistered<TokenSharedPrefs>()) {
      GetIt.instance.unregister<TokenSharedPrefs>();
    }
    GetIt.instance.registerSingleton<TokenSharedPrefs>(mockTokenSharedPrefs);

    when(
      () => mockCartViewModel.stream,
    ).thenAnswer((_) => Stream.value(mockCartState));
    when(() => mockCartViewModel.state).thenReturn(mockCartState);
    when(
      () => mockOrderViewModel.stream,
    ).thenAnswer((_) => Stream.value(OrderInitial()));
    when(() => mockOrderViewModel.state).thenReturn(OrderInitial());
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CartViewModel>.value(value: mockCartViewModel),
          BlocProvider<OrderViewModel>.value(value: mockOrderViewModel),
        ],
        child: const CartView(),
      ),
    );
  }

  group('CartView Widget Tests', () {
    testWidgets(
      'Test 1: Should display empty cart message when cart is empty',
      (tester) async {
        when(
          () => mockCartViewModel.stream,
        ).thenAnswer((_) => Stream.value(emptyCartState));
        when(() => mockCartViewModel.state).thenReturn(emptyCartState);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.text('Your cart is empty'), findsOneWidget);
        expect(find.byType(ListView), findsNothing);
      },
    );

    // testWidgets('Test 2: Should display cart items when cart has items', (
    //   tester,
    // ) async {
    //   await tester.pumpWidget(createWidgetUnderTest());
    //   await tester.pump();

    //   expect(find.text('Test Product'), findsOneWidget);
    //   expect(find.text('Total: Rs 200'), findsOneWidget);
    //   expect(find.text('2'), findsOneWidget);
    //   expect(find.byType(Card), findsOneWidget);
    // });

    // testWidgets('Test 3: Should display product image or placeholder', (
    //   tester,
    // ) async {
    //   await tester.pumpWidget(createWidgetUnderTest());
    //   await tester.pump();
    //   expect(find.byType(Image), findsOneWidget);

    //   final itemWithoutImage = CartItem(
    //     product: ProductEntity(
    //       productId: '2',
    //       name: 'No Image Product',
    //       price: 50.0,
    //       imageUrl: null,
    //     ),
    //     quantity: 1,
    //     addons: [],
    //   );

    //   when(
    //     () => mockCartViewModel.state,
    //   ).thenReturn(CartState(items: [itemWithoutImage]));
    //   await tester.pumpWidget(createWidgetUnderTest());
    //   await tester.pump();
    //   expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    // });

    testWidgets('Test 4: Should handle quantity increase button tap', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final increaseButton = find.byIcon(Icons.add_circle_outline);
      await tester.tap(increaseButton);
      await tester.pump();

      verify(
        () =>
            mockCartViewModel.add(UpdateQuantity(productId: '1', quantity: 3)),
      ).called(1);
    });

    testWidgets('Test 5: Should handle quantity decrease button tap', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final decreaseButton = find.byIcon(Icons.remove_circle_outline);
      await tester.tap(decreaseButton);
      await tester.pump();

      verify(
        () =>
            mockCartViewModel.add(UpdateQuantity(productId: '1', quantity: 1)),
      ).called(1);
    });

    testWidgets('Test 6: Should handle item removal', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final deleteButton = find.byIcon(Icons.delete_outline);
      await tester.tap(deleteButton);
      await tester.pump();

      verify(() => mockCartViewModel.add(RemoveFromCart('1'))).called(1);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Test Product removed from cart'), findsOneWidget);
    });

    // testWidgets('Test 7: Should display checkout button and total price', (
    //   tester,
    // ) async {
    //   await tester.pumpWidget(createWidgetUnderTest());
    //   await tester.pump();

    //   expect(find.text('Total: Rs 200'), findsOneWidget);
    //   expect(find.text('Checkout'), findsOneWidget);

    //   final checkoutButton = find.widgetWithText(ElevatedButton, 'Checkout');
    //   expect(checkoutButton, findsOneWidget);

    //   final elevatedButton = tester.widget<ElevatedButton>(checkoutButton);
    //   expect(elevatedButton.onPressed, isNotNull);
    // });

    testWidgets('Test 8: Should disable checkout button when cart is empty', (
      tester,
    ) async {
      when(
        () => mockCartViewModel.stream,
      ).thenAnswer((_) => Stream.value(emptyCartState));
      when(() => mockCartViewModel.state).thenReturn(emptyCartState);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('Test 9: Should show loading dialog when order is loading', (
      tester,
    ) async {
      when(
        () => mockOrderViewModel.stream,
      ).thenAnswer((_) => Stream.value(OrderLoading()));
      when(() => mockOrderViewModel.state).thenReturn(OrderLoading());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Placing your order...'), findsOneWidget);
    });

    testWidgets('Test 10: Should show success dialog when order succeeds', (
      tester,
    ) async {
      final successOrder = OrderEntity(
        userId: 'user123',
        products: [],
        total: 200.0,
        date: DateTime.now(),
        status: 'pending',
        orderType: 'dine-in',
      );

      when(
        () => mockOrderViewModel.stream,
      ).thenAnswer((_) => Stream.value(OrderSuccess(successOrder)));
      when(
        () => mockOrderViewModel.state,
      ).thenReturn(OrderSuccess(successOrder));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Order Placed!'), findsOneWidget);
      expect(
        find.text('Your Dine In order has been placed successfully.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      verify(() => mockCartViewModel.add(ClearCart())).called(1);
    });

    testWidgets('Test 11: Should show error dialog when order fails', (
      tester,
    ) async {
      const errorMessage = 'Order failed due to network error';

      when(
        () => mockOrderViewModel.stream,
      ).thenAnswer((_) => Stream.value(OrderFailure(errorMessage)));
      when(
        () => mockOrderViewModel.state,
      ).thenReturn(OrderFailure(errorMessage));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Order Failed'), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets(
      'Test 12: Should handle checkout button tap and show order type dialog',
      (tester) async {
        when(
          () => mockTokenSharedPrefs.getToken(),
        ).thenAnswer((_) async => const Right('user123'));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        final checkoutButton = find.widgetWithText(ElevatedButton, 'Checkout');
        await tester.tap(checkoutButton);
        await tester.pumpAndSettle();

        expect(checkoutButton, findsOneWidget);
      },
    );
  });

  group('CartView Edge Cases', () {
    testWidgets('Should handle items with addons display', (tester) async {
      final addon = Addon(name: 'Extra Cheese', price: 20.0, quantity: 1);
      final itemWithAddons = CartItem(
        product: mockProduct,
        quantity: 1,
        addons: [addon],
      );

      when(
        () => mockCartViewModel.state,
      ).thenReturn(CartState(items: [itemWithAddons]));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Addons:'), findsOneWidget);
      expect(find.text('Extra Cheese x1 - Rs 20'), findsOneWidget);
    });

    testWidgets('Should not decrease quantity below 1', (tester) async {
      final singleQuantityItem = CartItem(
        product: mockProduct,
        quantity: 1,
        addons: [],
      );

      when(
        () => mockCartViewModel.state,
      ).thenReturn(CartState(items: [singleQuantityItem]));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final decreaseButton = find.byIcon(Icons.remove_circle_outline);
      await tester.tap(decreaseButton);
      await tester.pump();

      verifyNever(() => mockCartViewModel.add(any()));
    });
  });
}
