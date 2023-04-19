
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
var stdstock;
var anystock;


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

async function getany(url) {
  const dom = await JSDOM.fromURL(url);
  const body = dom.window.document.querySelector('body');
  const h1Elements = body.querySelectorAll('h1');
  const h1Texts = Array.from(h1Elements).map(h1Element => h1Element.textContent);

  const spanElements = body.querySelectorAll('span');
  const spanTexts = Array.from(spanElements).map(spanElement => spanElement.textContent);

  const values = {
    value1: h1Texts,
    value2: spanTexts
  };
  return values;
}

var dji_span = [];
var nk_span = [];
var any_span = [];
var any_name = [];




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

async function getany(url) {
  const dom = await JSDOM.fromURL(url);
  const body = dom.window.document.querySelector('body');
  const h1Elements = body.querySelectorAll('h1');
  const h1Texts = Array.from(h1Elements).map(h1Element => h1Element.textContent);

  const spanElements = body.querySelectorAll('span');
  const spanTexts = Array.from(spanElements).map(spanElement => spanElement.textContent);

  const values = {
    value1: h1Texts,
    value2: spanTexts
  };
  return values;
}




app.get('/', (req, res) => {
  stock = [];
  stdstock = [];
  anystock = [];

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


  for (let i = 0; i < data.length; i++) {
    element = data[i][0];


    (async function () {
      url = `https://finance.yahoo.co.jp/quote/${element}.T`;
      //console.log(url);
      const resultPromise = getany(url);
      any_name[i] = (await resultPromise).value1;
      //const result = await resultPromise;
      any_span[i] = (await resultPromise).value2;
      //console.log(any_span);
      //nk_span = result;
      //console.log(result); // Hello, World!
    })();
  }






  //Reshio to undefined
  if (dji_span[23] === undefined || dji_span[23] === null) {
    // undefinedまたはnullの場合の処理
    dji_polarity = "-";
    dji_span[18] = "---";
    dji_span[23] = "---";
    dji_span[28] = "---";
  } else {
    var dji_Firstcharacter = dji_span[23].slice(0, 1);
    dji_polarity = (dji_Firstcharacter !== "+" && dji_Firstcharacter !== "-") ? "-" : dji_Firstcharacter;
  }
  stdstock.push({ "Code": "^DJI", "Name": "DJI1", "Price": dji_span[18], "Reshio": dji_span[23], "Percent": dji_span[28], "Polarity": dji_polarity });







  if (nk_span[23] === undefined || nk_span[23] === null) {
    // undefinedまたはnullの場合の処理
    nk_polarity = "-";
    nk_span[19] = "---";
    nk_span[23] = "---";
    nk_span[29] = "---";
  } else {
    var nk_Firstcharacter = nk_span[23].slice(0, 1);
    nk_polarity = (nk_Firstcharacter !== "+" && nk_Firstcharacter !== "-") ? "-" : nk_Firstcharacter;
  }
  stdstock.push({ "Code": "NIKKEI", "Name": "NIKKEI", "Price": nk_span[19], "Reshio": nk_span[23], "Percent": nk_span[29], "Polarity": nk_polarity });





  //const numberWithCommas = '1,000,000';
  //const numberWithoutCommas = parseInt(numberWithCommas.replace(/,/g, ''));
  //console.log(numberWithoutCommas); // 1000000

  var Investment//投資額
  var MarketCap;//時価総額
  var Unitprice;//単価
  var Shares;//株数
  var TotalUnitprice = 0;
  var Totalmarketcap = 0;//総時価総額
  var any_polarity;

  if (any_span[0] != null) {
    for (let i = 0; i < data.length; i++) {

      MarketCap = parseInt(any_span[i][22].replace(/,/g, ''));//カンマ削除してintに変換


      Shares = data[i][1];
      Unitprice = data[i][2];
      TotalUnitprice = TotalUnitprice + (Unitprice * Shares);//総投資総額
      Totalmarketcap = Totalmarketcap + (MarketCap * Shares);//総時価総額





      any_polarity = any_span[i][29].slice(0, 1) == "-" ? "-" : "+";
      anystock.push({
        "Code": any_span[i][25],
        "Name": any_name[i][1],
        "Price": any_span[i][22],
        "Reshio": any_span[i][30],
        "Percent": any_span[i][34],
        "Polarity": any_polarity,
        "MarketCap": (MarketCap * Shares).toLocaleString(),
        "Banefits": (MarketCap - Unitprice).toLocaleString(),
        "Evaluation": ((MarketCap * Shares) - (Unitprice * Shares)).toLocaleString(),
      });
    }

  }


 
  var totalGain = (Totalmarketcap - TotalUnitprice).toLocaleString();
  totalUnitprice = TotalUnitprice.toLocaleString();
  totalmarketcap = Totalmarketcap.toLocaleString();
  any_polarity = (Totalmarketcap - TotalUnitprice) > 0 ? "+" : "-";

  var stockdata = {
    "stdstock": stdstock,
    "anystock": anystock,
    "totalmarketcap": totalmarketcap,
    "totalUnitprice": totalUnitprice,
    "totalGain": totalGain,
    "totalpolarity": any_polarity
  };

  /*
  app.get('/stock', function(req, res) {
    const stock = {
      "item1": "apple",
      "item2": "orange"
    };
    const nk = {
      "item1": "nike",
      "item2": "adidas"
    };


    const data = {
      "stock": stock,
      "nk": nk
    };
    res.json(data);
  });
  */
  //この例では、stockとnkという2つのオブジェクトが定義されています。これらをdataというオブジェクトにまとめて、1つのオブジェクトとしてレスポンスしています。ブラウザで/stockエンドポイントにアクセスすると、以下のようなレスポンスが返されます。
  /*
  {
    "stock": {
      "item1": "apple",
      "item2": "orange"
    },
    "nk": {
      "item1": "nike",
      "item2": "adidas"
    }
  }
  */



  console.log(stockdata);
  //console.log(stock.length);
  // JSONを送信する
  //res.json(todoList);
  res.json(stockdata);
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





