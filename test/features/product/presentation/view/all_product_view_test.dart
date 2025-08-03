import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';

import 'package:servzz/features/product/presentation/view/all_products_view.dart';
import 'package:servzz/features/product/presentation/view_model/product_view_model.dart';
import 'package:servzz/features/product/presentation/view_model/product_state.dart';
import 'package:servzz/features/product/presentation/view_model/product_event.dart';
import 'package:servzz/features/product/domain/entity/product_entity.dart';
import 'package:servzz/features/product/domain/entity/add_on_entity.dart';
import 'package:servzz/features/category/domain/entity/category_entity.dart';
import 'package:servzz/app/service_locator/service_locator.dart';

// Mock classes
class MockProductBloc extends Mock implements ProductBloc {}

// Mock data
final mockCategory = CategoryEntity(categoryId: 'cat1', name: 'Test Category');

final mockAddons = [
  const AddonEntity(name: 'Extra Cheese', price: 20.0),
  const AddonEntity(name: 'Extra Sauce', price: 15.0),
];

final mockProducts = [
  ProductEntity(
    productId: '1',
    name: 'Test Product 1',
    description: 'Test description 1',
    imageUrl: 'https://test.com/image1.jpg',
    price: 100.0,
    category: mockCategory,
    sellerId: 'seller1',
    addons: mockAddons,
  ),
  ProductEntity(
    productId: '2',
    name: 'Test Product 2',
    description: 'Test description 2',
    imageUrl: 'https://test.com/image2.jpg',
    price: 150.0,
    category: mockCategory,
    sellerId: 'seller2',
    addons: [],
  ),
  ProductEntity(
    productId: '3',
    name: 'Test Product Without Image',
    description: 'Test description 3',
    imageUrl: null,
    price: 75.0,
    category: mockCategory,
    sellerId: 'seller3',
    addons: mockAddons,
  ),
];

void main() {
  late MockProductBloc mockProductBloc;

  setUpAll(() {
    registerFallbackValue(FetchProductsEvent());
  });

  setUp(() {
    mockProductBloc = MockProductBloc();

    // Setup service locator
    if (GetIt.instance.isRegistered<ProductBloc>()) {
      GetIt.instance.unregister<ProductBloc>();
    }
    GetIt.instance.registerFactory<ProductBloc>(() => mockProductBloc);

    // Default mock behaviors
    when(
      () => mockProductBloc.stream,
    ).thenAnswer((_) => Stream.value(ProductState.initial()));
    when(() => mockProductBloc.state).thenReturn(ProductState.initial());
    when(() => mockProductBloc.add(any())).thenReturn(null);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(home: AllProductsView());
  }

  group('AllProductsView Widget Tests', () {
    testWidgets(
      'Test 1: Should display loading indicator when products are loading and list is empty',
      (WidgetTester tester) async {
        // Arrange
        final loadingState = ProductState.initial().copyWith(
          isLoading: true,
          products: [],
        );
        when(
          () => mockProductBloc.stream,
        ).thenAnswer((_) => Stream.value(loadingState));
        when(() => mockProductBloc.state).thenReturn(loadingState);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        expect(find.text('All Products'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(GridView), findsNothing);
        expect(find.text('Search products...'), findsOneWidget);
      },
    );

    testWidgets(
      'Test 2: Should display error message when there is an error and no products',
      (WidgetTester tester) async {
        // Arrange
        const errorMessage = 'Failed to fetch products';
        final errorState = ProductState.initial().copyWith(
          isLoading: false,
          products: [],
          error: errorMessage,
        );
        when(
          () => mockProductBloc.stream,
        ).thenAnswer((_) => Stream.value(errorState));
        when(() => mockProductBloc.state).thenReturn(errorState);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        expect(find.text('Error: $errorMessage'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(GridView), findsNothing);
      },
    );

    testWidgets(
      'Test 3: Should display "No products found" when products list is empty and not loading',
      (WidgetTester tester) async {
        // Arrange
        final emptyState = ProductState.initial().copyWith(
          isLoading: false,
          products: [],
          error: null,
        );
        when(
          () => mockProductBloc.stream,
        ).thenAnswer((_) => Stream.value(emptyState));
        when(() => mockProductBloc.state).thenReturn(emptyState);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        expect(find.text('No products found'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(GridView), findsNothing);
      },
    );

    testWidgets(
      'Test 4: Should display products in grid view when products are available',
      (WidgetTester tester) async {
        // Arrange
        final productsState = ProductState.initial().copyWith(
          isLoading: false,
          products: mockProducts,
          error: null,
        );
        when(
          () => mockProductBloc.stream,
        ).thenAnswer((_) => Stream.value(productsState));
        when(() => mockProductBloc.state).thenReturn(productsState);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        expect(find.byType(GridView), findsOneWidget);
        expect(find.text('Test Product 1'), findsOneWidget);
        expect(find.text('Test Product 2'), findsOneWidget);
        expect(find.text('Test Product Without Image'), findsOneWidget);
        expect(find.text('Rs 100.0'), findsOneWidget);
        expect(find.text('Rs 150.0'), findsOneWidget);
        expect(find.text('Rs 75.0'), findsOneWidget);
      },
    );

    testWidgets('Test 5: Should display search field and handle search input', (
      WidgetTester tester,
    ) async {
      // Arrange
      final productsState = ProductState.initial().copyWith(
        isLoading: false,
        products: mockProducts,
        error: null,
      );
      when(
        () => mockProductBloc.stream,
      ).thenAnswer((_) => Stream.value(productsState));
      when(() => mockProductBloc.state).thenReturn(productsState);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Find search field and enter text
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);
      expect(find.text('Search products...'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);

      await tester.enterText(searchField, 'pizza');
      await tester.pump();

      // Assert
      verify(() => mockProductBloc.add(any())).called(greaterThan(1));
    });

    testWidgets(
      'Test 6: Should handle product card tap and navigate to product detail',
      (WidgetTester tester) async {
        // Arrange
        final productsState = ProductState.initial().copyWith(
          isLoading: false,
          products: [mockProducts[0]], // Single product for easier testing
          error: null,
        );
        when(
          () => mockProductBloc.stream,
        ).thenAnswer((_) => Stream.value(productsState));
        when(() => mockProductBloc.state).thenReturn(productsState);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Find and tap the product card
        final productCard = find.byType(InkWell).first;
        expect(productCard, findsOneWidget);

        await tester.tap(productCard);
        await tester.pumpAndSettle();

        // Assert - Product card should be tappable
        expect(find.text('Test Product 1'), findsOneWidget);
      },
    );

    testWidgets(
      'Test 7: Should display product image or placeholder correctly',
      (WidgetTester tester) async {
        // Arrange - Use product with and without image
        final mixedProducts = [
          mockProducts[0],
          mockProducts[2],
        ]; // One with image, one without
        final productsState = ProductState.initial().copyWith(
          isLoading: false,
          products: mixedProducts,
          error: null,
        );
        when(
          () => mockProductBloc.stream,
        ).thenAnswer((_) => Stream.value(productsState));
        when(() => mockProductBloc.state).thenReturn(productsState);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        expect(find.byType(Image), findsOneWidget); // Product with image
        expect(
          find.byIcon(Icons.image_not_supported),
          findsOneWidget,
        ); // Product without image
        expect(find.text('Test Product 1'), findsOneWidget);
        expect(find.text('Test Product Without Image'), findsOneWidget);
      },
    );

    testWidgets(
      'Test 8: Should display loading indicator at bottom when loading more products',
      (WidgetTester tester) async {
        // Arrange
        final loadingMoreState = ProductState.initial().copyWith(
          isLoading: true,
          products: mockProducts, // Has products but still loading more
          error: null,
        );
        when(
          () => mockProductBloc.stream,
        ).thenAnswer((_) => Stream.value(loadingMoreState));
        when(() => mockProductBloc.state).thenReturn(loadingMoreState);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        expect(find.byType(GridView), findsOneWidget);
        expect(
          find.byType(CircularProgressIndicator),
          findsOneWidget,
        ); // Loading indicator at bottom
        expect(find.text('Test Product 1'), findsOneWidget);
        expect(find.text('Test Product 2'), findsOneWidget);
        expect(find.text('Test Product Without Image'), findsOneWidget);
      },
    );
  });

  group('AllProductsView Edge Cases', () {
    testWidgets('Test 9: Should trigger FetchProductsEvent on initialization', (
      WidgetTester tester,
    ) async {
      // Arrange
      final initialState = ProductState.initial();
      when(
        () => mockProductBloc.stream,
      ).thenAnswer((_) => Stream.value(initialState));
      when(() => mockProductBloc.state).thenReturn(initialState);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      verify(() => mockProductBloc.add(FetchProductsEvent())).called(1);
    });

    testWidgets('Test 10: Should handle scroll to bottom for pagination', (
      WidgetTester tester,
    ) async {
      // Arrange
      final productsState = ProductState.initial().copyWith(
        isLoading: false,
        products: mockProducts,
        error: null,
      );
      when(
        () => mockProductBloc.stream,
      ).thenAnswer((_) => Stream.value(productsState));
      when(() => mockProductBloc.state).thenReturn(productsState);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Find the GridView and scroll to bottom
      final gridView = find.byType(GridView);
      expect(gridView, findsOneWidget);

      // Simulate scroll to bottom
      await tester.drag(gridView, const Offset(0, -1000));
      await tester.pump();

      // Assert - Should trigger additional fetch calls
      verify(() => mockProductBloc.add(any())).called(greaterThan(1));
    });

    testWidgets(
      'Test 11: Should clear search and reset page when search text changes',
      (WidgetTester tester) async {
        // Arrange
        final productsState = ProductState.initial().copyWith(
          isLoading: false,
          products: mockProducts,
          error: null,
        );
        when(
          () => mockProductBloc.stream,
        ).thenAnswer((_) => Stream.value(productsState));
        when(() => mockProductBloc.state).thenReturn(productsState);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Enter search text
        final searchField = find.byType(TextField);
        await tester.enterText(searchField, 'test');
        await tester.pump();

        // Change search text
        await tester.enterText(searchField, 'pizza');
        await tester.pump();

        // Clear search text
        await tester.enterText(searchField, '');
        await tester.pump();

        // Assert - Multiple search events should be triggered
        verify(() => mockProductBloc.add(any())).called(greaterThan(3));
      },
    );

    testWidgets(
      'Test 12: Should handle product card with long names and price formatting',
      (WidgetTester tester) async {
        // Arrange
        final longNameProduct = ProductEntity(
          productId: '4',
          name: 'Very Long Product Name That Should Be Truncated',
          description: 'Test description',
          imageUrl: 'https://test.com/image.jpg',
          price: 999.99,
          category: mockCategory,
          sellerId: 'seller4',
          addons: [],
        );

        final productsState = ProductState.initial().copyWith(
          isLoading: false,
          products: [longNameProduct],
          error: null,
        );
        when(
          () => mockProductBloc.stream,
        ).thenAnswer((_) => Stream.value(productsState));
        when(() => mockProductBloc.state).thenReturn(productsState);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        expect(
          find.text('Very Long Product Name That Should Be Truncated'),
          findsOneWidget,
        );
        expect(find.text('Rs 999.99'), findsOneWidget);

        // Check if text is properly styled
        final priceText = tester.widget<Text>(find.text('Rs 999.99'));
        expect(priceText.style?.fontWeight, FontWeight.w600);
      },
    );
  });
}
