// Widget smoke test for the Le Revenu app.
//
// Tests that the home screen renders successfully with a ProviderScope,
// and that the wordmark is visible on the app bar.

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lerevenu/main.dart';

void main() {
  setUpAll(() {
    // Bind mock HttpOverrides globally so NetworkImage load requests succeed.
    HttpOverrides.global = TestHttpOverrides();
  });

  testWidgets('App renders and shows the Le Revenu wordmark', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: LeRevenuApp()));

    // Pump frames for a fixed duration to allow initial async futures/providers to settle.
    // Avoid using pumpAndSettle() as infinite shimmer animations will cause a timeout.
    await tester.pump(const Duration(seconds: 2));

    // The logo image should be visible in the SliverAppBar
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is Image &&
            w.image is AssetImage &&
            (w.image as AssetImage).assetName == 'assets/logo.jpg',
      ),
      findsOneWidget,
    );
  });
}

/// A mock [HttpOverrides] that intercepts all HTTP client instantiation.
class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

/// Mock HttpClient returning null for all unstubbed members.
class MockHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    return Future.value(MockHttpClientRequest());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Mock HttpClientRequest returning null for all unstubbed members.
class MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() {
    return Future.value(MockHttpClientResponse());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Mock HttpHeaders returning null for all unstubbed members.
class MockHttpHeaders implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Mock HttpClientResponse returning null for all unstubbed members.
class MockHttpClientResponse extends StreamView<List<int>>
    implements HttpClientResponse {
  MockHttpClientResponse() : super(Stream.value(_imageBytes));

  @override
  int get statusCode => 200;

  @override
  int get contentLength => _imageBytes.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

// 1x1 transparent PNG bytes to safely load in image decoder tests
final List<int> _imageBytes = [
  137,
  80,
  78,
  71,
  13,
  10,
  26,
  10,
  0,
  0,
  0,
  13,
  73,
  72,
  68,
  82,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  1,
  8,
  6,
  0,
  0,
  0,
  31,
  21,
  196,
  137,
  0,
  0,
  0,
  11,
  73,
  68,
  65,
  84,
  120,
  156,
  99,
  96,
  0,
  0,
  0,
  2,
  0,
  1,
  226,
  33,
  188,
  51,
  0,
  0,
  0,
  0,
  73,
  69,
  78,
  68,
  174,
  66,
  96,
  130,
];
