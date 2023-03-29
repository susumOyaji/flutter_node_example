
//Hello World の例
//ここで紹介するのは基本的に、作成できる最も単純な Express アプリケーションです。このアプリケーションは単一ファイル・アプリケーションであり、Express ジェネレーター を使用して得られるものでは ありません 。このジェネレーターは、さまざまな目的で多数の JavaScript ファイル、Jade テンプレート、サブディレクトリーを使用する完全なアプリケーション用のスキャフォールディングを作成します。

//最初に、myapp という名前のディレクトリーを作成して、そのディレクトリーに移動し、npm init を実行します。次に、インストール・ガイドに従い、依存関係として express をインストールします。

//myapp ディレクトリーで、app.js というファイルを作成して、以下のコードを追加します。


const express = require('express');
const cors = require('cors');

// expressアプリを生成する
const app = express();
const port = 3000;

var reqArray = [];//new Array();

app.use(cors());

app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

// webフォルダの中身を公開する
//app.use(express.static('./Node/'));


app.get('/', (req, res) => {
  console.log(`Example app get()`)
  const data = JSON.parse(req.query.data);
  console.log(data);

  const arr1 = Array.from(data);
 
  console.log(arr1[0][0]);
  console.log(arr1[1][0]);
  console.log(arr1[2][0]);
  console.log(arr1.length);

  //const values = req.query.data;
  //console.log(values);
  //console.log(`Query parameters: ${JSON.stringify(req.query)}`);


  res.send('Hello Node-World!')
  //res.send(JSON.stringify('Hello World!'));
})




app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})

//アプリケーションは、サーバーを始動して、ポート 3000 で接続を listen します。
//アプリケーションは、ルート URL (/) またはルート に対する要求に「Hello World!」と応答します。
//その他すべてのパスについては、「404 Not Found」と応答します。

//req (要求) と res (応答) は、Node が提供するのとまったく同じオブジェクトであるため、Express が関与しない場合と同じように、req.pipe()、req.on('data', callback) などを呼び出すことができます。

//次のコマンドを使用してアプリケーションを実行します。

//$ node app.js
//次に、ブラウザーに http://localhost:3000/ をロードして、出力を確認します。





