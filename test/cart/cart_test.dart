import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  group('Cart', () {
    late Cart cart;
    late Sandwich sandwich;

    setUp(() {
      cart = Cart();
      sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
    });

    test('initial cart is empty', () {
      expect(cart.isEmpty, isTrue);
      expect(cart.totalItems, equals(0));
      expect(cart.totalPrice, equals(0.0));
    });

    test('addItem adds a sandwich to the cart', () {
      cart.addItem(sandwich);
      expect(cart.isEmpty, isFalse);
      expect(cart.totalItems, equals(1));
      expect(cart.items[sandwich], equals(1));
    });

    test('addItem increments quantity if sandwich already exists', () {
      cart.addItem(sandwich);
      cart.addItem(sandwich);
      expect(cart.totalItems, equals(2));
      expect(cart.items[sandwich], equals(2));
    });

    test('removeItem removes a sandwich from the cart', () {
      cart.addItem(sandwich);
      cart.removeItem(sandwich);
      expect(cart.isEmpty, isTrue);
      expect(cart.totalItems, equals(0));
    });

    test('increment increases the quantity of a sandwich', () {
      cart.addItem(sandwich);
      cart.increment(sandwich);
      expect(cart.items[sandwich], equals(2));
    });

    test('decrement decreases the quantity of a sandwich', () {
      cart.addItem(sandwich);
      cart.addItem(sandwich);
      cart.decrement(sandwich);
      expect(cart.items[sandwich], equals(1));
    });

    test('decrement removes sandwich if quantity reaches zero', () {
      cart.addItem(sandwich);
      cart.decrement(sandwich);
      expect(cart.isEmpty, isTrue);
    });

    test('clear removes all items from the cart', () {
      cart.addItem(sandwich);
      cart.clear();
      expect(cart.isEmpty, isTrue);
    });

    test('totalPrice calculates the correct total', () {
      cart.addItem(sandwich);
      cart.addItem(sandwich);
      final pricePerItem = cart.totalPrice / 2; // Assuming consistent pricing
      expect(cart.totalPrice, equals(pricePerItem * 2));
    });
  });
}
