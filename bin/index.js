// expressモジュールを読み込む
const express = require('express');
const request = require('request');
//const cheerio = require('cheerio');
//const fetch = request("node-fetch");
const jsdom = require('jsdom');
//import jsdom from "jsdom";
//const request = require('request-promise');
//const requestpromise = require('request-promise');



var resArray = [];//new Array();
var stock = [];

var newElement;
var code;
var company;
var name;
/*
var name = [];
var price = [];
var reshio = [];
var percent = [];
var polarity=[];
*/

var price;
var reshio;
var percent;
var polarity;

//var element;
//var url;

// expressアプリを生成する
const app = express();

// webフォルダの中身を公開する
app.use(express.static('./web/'));

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




//import fetch from "node-fetch";
//import jsdom from "jsdom";
//const { JSDOM } = jsdom;
/*
(async () => {
    const res = await fetch("http://example.com");
    const body = await res.text(); // HTMLをテキストで取得
    const dom = new JSDOM(body); // パース
    const h1Text = dom.window.document.querySelector("h1").textContent; // JavaScriptと同じ書き方ができます。
    console.log(h1Text); // Example Domain
})();
*/







//Node.js body内からspanを選別するには
//const jsdom = require('jsdom');
//const { JSDOM } = jsdom;

// HTMLを取得する
/*
function spanGet(){
JSDOM.fromURL('https://finance.yahoo.co.jp/quote/%5EDJI').then(dom => {
  // body要素を取得する
  const body = dom.window.document.querySelector('body');

  // body内のすべてのspan要素を取得する
  const spanElements = body.querySelectorAll('span');

  // span要素の内容を配列に格納する
  const spanTexts = Array.from(spanElements).map(spanElement => spanElement.textContent);

  // span要素のテキストをコンソールに出力する
  //console.log(spanTexts);

  // または、returnする
  return spanTexts;
});
}
*/
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








// http://localhost:3000/api/v1/list にアクセスしてきたときに
// TODOリストを返す
app.get('/api/v1/list', (req, res) => {
    const data = JSON.parse(req.query.data);
    stock = [];


    // クライアントに送るJSONデータ
    const todoList = [
        { title: 'JavaScriptを勉強する', done: true },
        { title: 'Node.jsを勉強する', done: false },
        { title: 'Web APIを作る', done: false }
    ];


    //stock.push({ Code: '^DJI', Name: '^DJI', Price: '10', Reshio: '20', Percent: '30', Polarity: '+' });


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

    //console.log(Promise.resolve(respnce));//シンボル確認時、使用


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



    dji_polarity = dji_span[23] == null ? "-" : dji_span[23].slice(0, 1);
    stock.push({ Code: '^DJI', Name: '^DJI', Price: dji_span[18], Reshio: dji_span[23], Percent: dji_span[28], Polarity: dji_polarity });

    nk_polarity = nk_span[23] == null ? "-" : nk_span[23].slice(0, 1);
    stock.push({ Code: 'NIKKEI', Name: 'NIKKEI', Price: nk_span[19], Reshio: nk_span[23], Percent: nk_span[29], Polarity: nk_polarity });
   

    

    //console.log(any_name[0][1]);
    //console.log(any_span[0]);
    //console.log(any_span[0][22]);
    //console.log(any_span[0][30]);
    //console.log(any_span[0][34]);

    //console.log(any_name[1][1]);
    //console.log(any_span[1]);
    //console.log(any_span[1][22]);
    //console.log(any_span[1][30]);
    //console.log(any_span[1][34],any_span[1][35]);
    if (any_span[0] != null) {
        for (let i = 0; i < data.length; i++) {
            any_polarity = any_span[i][29] == null ? "-" : any_span[i][29].slice(0, 1);
            stock.push({ Code: any_span[i][25], Name: any_name[i][1], Price: any_span[i][22], Reshio: any_span[i][30], Percent: any_span[i][34], Polarity: any_polarity });
        }

    }



    console.log(stock);
    //console.log(stock.length);
    // JSONを送信する
    //res.json(todoList);
    res.json(stock);




});





// ポート3000でサーバを立てる
app.listen(3000, () => console.log('Listening on port 3000'));