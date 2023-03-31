
//Hello World の例
//ここで紹介するのは基本的に、作成できる最も単純な Express アプリケーションです。このアプリケーションは単一ファイル・アプリケーションであり、Express ジェネレーター を使用して得られるものでは ありません 。このジェネレーターは、さまざまな目的で多数の JavaScript ファイル、Jade テンプレート、サブディレクトリーを使用する完全なアプリケーション用のスキャフォールディングを作成します。

//最初に、myapp という名前のディレクトリーを作成して、そのディレクトリーに移動し、npm init を実行します。次に、インストール・ガイドに従い、依存関係として express をインストールします。

//myapp ディレクトリーで、app.js というファイルを作成して、以下のコードを追加します。


const express = require('express');
const jsdom = require('jsdom');
const cors = require('cors');

// expressアプリを生成する
const app = express();
const port = 3000;

var reqArray = [];//new Array();
var stock = [];


app.use(cors());

app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

// webフォルダの中身を公開する
//app.use(express.static('./Node/'));
const {
  JSDOM
} = require('jsdom')

var options_dji = {
  url: 'https://finance.yahoo.co.jp/quote/%5EDJI',
  method: 'GET',
  json: true
}

var options_nk = {
  url: 'https://finance.yahoo.co.jp/quote/998407.O',
  method: 'GET',
  json: true
}


async function getdji() {
  const dom = await JSDOM.fromURL('https://finance.yahoo.co.jp/quote/%5EDJI');
  const body = dom.window.document.querySelector('body');
  const spanElements = body.querySelectorAll('span');
  const spanTexts = Array.from(spanElements).map(spanElement => spanElement.textContent);
  return spanTexts;
}

async function getnk() {
  const dom = await JSDOM.fromURL('https://finance.yahoo.co.jp/quote/998407.O');
  const body = dom.window.document.querySelector('body');
  const spanElements = body.querySelectorAll('span');
  const spanTexts = Array.from(spanElements).map(spanElement => spanElement.textContent);
  return spanTexts;
}


app.get('/', (req, res) => {
  stock = [];

  console.log(`Example app get()`)
  const data = JSON.parse(req.query.data);
  console.log(data);

  const arr1 = Array.from(data);

  console.log(arr1[0][0]);
  console.log(arr1[1][0]);
  console.log(arr1[2][0]);
  console.log(arr1.length);


  (async function () {
    const resultPromise = getdji();
    //const result = await resultPromise;
    dji_span = await resultPromise;
    //dji_span = result;
    //console.log(result); // Hello, World!
  })();


  (async function () {
    const resultPromise = getnk();
    //const result = await resultPromise;
    nk_span = await resultPromise;
    //nk_span = result;
    //console.log(result); // Hello, World!
  })();



  dji_polarity = dji_span[23] == null ? "-" : dji_span[23].slice(0, 1);
  stock.push({ Code: '^DJI', Name: '^DJI1', Price: dji_span[18], Reshio: dji_span[23], Percent: dji_span[28], Polarity: dji_polarity });
  
  nk_polarity = nk_span[23] == null ? "-" : nk_span[23].slice(0, 1);
  stock.push({ Code: 'NIKKEI', Name: 'NIKKEI', Price: nk_span[19], Reshio: nk_span[23], Percent: nk_span[29], Polarity: nk_polarity });

  //const values = req.query.data;
  //console.log(values);
  //console.log(`Query parameters: ${JSON.stringify(req.query)}`);

  console.log(stock);
  //console.log(stock.length);
  // JSONを送信する
  //res.json(todoList);
  res.json(stock);
  //res.send('Hello Node-World!')
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





