
//Hello World の例
//ここで紹介するのは基本的に、作成できる最も単純な Express アプリケーションです。このアプリケーションは単一ファイル・アプリケーションであり、Express ジェネレーター を使用して得られるものでは ありません 。このジェネレーターは、さまざまな目的で多数の JavaScript ファイル、Jade テンプレート、サブディレクトリーを使用する完全なアプリケーション用のスキャフォールディングを作成します。

//最初に、myapp という名前のディレクトリーを作成して、そのディレクトリーに移動し、npm init を実行します。次に、インストール・ガイドに従い、依存関係として express をインストールします。

//myapp ディレクトリーで、app.js というファイルを作成して、以下のコードを追加します。


const express = require('express')
// expressアプリを生成する
const app = express()
const port = 3000


// webフォルダの中身を公開する
//app.use(express.static('./Node/'));


app.get('/', (req, res) => {
  res.send('Hello World!')
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





