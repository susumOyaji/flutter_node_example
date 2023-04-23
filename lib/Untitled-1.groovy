import 'package:aqueduct/aqueduct.dart';

class MyController extends ResourceController {
  @Operation.get()
  Future<Response> doGetRequest() async {
    // レスポンスヘッダーに Access-Control-Allow-Origin を設定する
    return Response.ok({"data": "example"})
      ..headers.set("Access-Control-Allow-Origin", "*");
  }
}

void main() async {
  final app = Application<MyChannel>()
    ..options.configurationFilePath = "config.yaml"
    ..options.port = 8080; // サーバーポートを設定する
  await app.start(numberOfInstances: 1);
}

class MyChannel extends ApplicationChannel {
  @override
  Future<void> prepare() async {}

  @override
  Controller get entryPoint {
    final router = Router();
    router.route("/example").link(() => MyController());
    return router;
  }
}





