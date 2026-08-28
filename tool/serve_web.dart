import 'dart:io';

Future<void> main() async {
  final root = Directory('build/web');
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8099);
  stdout.writeln('Serving ${root.path} at http://127.0.0.1:8099');
  await for (final request in server) {
    var path = request.uri.path;
    if (path == '/') path = '/index.html';
    final file = File('${root.path}$path');
    if (file.existsSync()) {
      request.response.headers.contentType = ContentType.parse(_mime(path));
      await request.response.addStream(file.openRead());
    } else {
      request.response.statusCode = 404;
    }
    await request.response.close();
  }
}

String _mime(String path) {
  if (path.endsWith('.html')) return 'text/html; charset=utf-8';
  if (path.endsWith('.js')) return 'text/javascript; charset=utf-8';
  if (path.endsWith('.css')) return 'text/css; charset=utf-8';
  if (path.endsWith('.json')) return 'application/json';
  if (path.endsWith('.wasm')) return 'application/wasm';
  if (path.endsWith('.png')) return 'image/png';
  if (path.endsWith('.woff2')) return 'font/woff2';
  if (path.endsWith('.otf')) return 'font/otf';
  return 'application/octet-stream';
}
