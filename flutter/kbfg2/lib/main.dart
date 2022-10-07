import 'package:flutter/material.dart';
import 'package:kbfg2/database.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'KB 증권'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int index = -1;
  Color mainColor = const Color(0xFFFEBE10);
  List<Stock> stocks = [
    Stock(
      id: -1,
      name: "네이버",
      price: 400000,
      amount: "300백억",
      marketCap: "30조"
    ),
    Stock(
        id: -1,
        name: "KB증권",
        price: 900000,
        amount: "500백억",
        marketCap: "10조"
    ),
  ];

  DatabaseHelper dbHelper = DatabaseHelper.instance;

  // 입력 값 컨트롤러
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController amountCtrl = TextEditingController();
  TextEditingController marketCapCtrl = TextEditingController();

  Future<void> getStocks() async {
    List<Stock> s = await dbHelper.queryAllStock();
    setState((){
      stocks = s;
    });
  }

  @override
  void initState() {
    // 위젯이 처음 생성될 때 호출되는 함수
    // 초기화 함수들을 실행함
    super.initState();

    getStocks();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                width: 250,
                height: 150,
                child: Image.asset(
                  "assets/KB_logo.png",
                  fit: BoxFit.contain,
                )),
            Container(
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(color: mainColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      child:
                          const Text("종목명", style: TextStyle(color: Colors.white)),
                    )),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(color: mainColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      child:
                          const Text("현재가", style: TextStyle(color: Colors.white)),
                    )),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(color: mainColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      child:
                          const Text("거래대금", style: TextStyle(color: Colors.white)),
                    )),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(color: mainColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      child:
                          const Text("시가총액", style: TextStyle(color: Colors.white)),
                    )),
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: mainColor),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          alignment: Alignment.center,
                          child:
                          const Text(" ", style: TextStyle(color: Colors.white)),
                        )),
                  ],
                )
            ),
            Expanded(
                child: ListView.builder(
                  itemBuilder: (ctx, idx){
                    Stock stock = stocks[idx];

                    return Container(
                       decoration: BoxDecoration(
                           border: Border(
                               bottom: BorderSide(
                                 color: mainColor,
                               )
                           )
                       ),
                       child: Row(
                         children: [
                           Expanded(
                               child: Container(
                                   padding: const EdgeInsets.symmetric(vertical: 12),
                                   alignment: Alignment.center,
                                   child: Text(stock.name)
                               )
                           ),
                           Expanded(
                               child: Container(
                                   padding: const EdgeInsets.symmetric(vertical: 12),
                                   alignment: Alignment.center,
                                   child: Text("${stock.price}원"),
                               )
                           ),
                           Expanded(
                               child: Container(
                                   padding: const EdgeInsets.symmetric(vertical: 12),
                                   alignment: Alignment.center,
                                   child: Text(stock.amount)
                               )
                           ),
                           Expanded(
                               child: Container(
                                   padding: const EdgeInsets.symmetric(vertical: 12),
                                   alignment: Alignment.center,
                                   child: Text(stock.marketCap))
                           ),
                           Expanded(
                               child: Container(
                                   padding: const EdgeInsets.symmetric(vertical: 12),
                                   alignment: Alignment.center,
                                   child: InkWell(
                                     child: const Icon(Icons.remove_circle),
                                     onTap: () async {

                                       // Map<String, dynamic> data = stock.toJson();
                                       // // db insert
                                       // print(data);
                                       //
                                       // // db query
                                       // Stock _stock = Stock.fromDatabase(data);
                                       //
                                       // print(_stock.toJson());

                                       Stock? _stock = await Navigator.of(context).push(
                                         MaterialPageRoute(
                                             builder: (ctx) => StockAddPage(
                                                 stock: stock
                                             )
                                         )
                                       );

                                       // 페이지 리프레시 진행
                                       getStocks();

                                       //
                                       // if(_stock != null){
                                       //   setState(() {
                                       //     stocks[idx] = _stock;
                                       //   });
                                       // }
                                     },
                                     // 길게 눌렀을 때 해당 항목 삭제
                                     onLongPress: (){
                                       showDialog(
                                         context: context,
                                         builder: (ctx) => AlertDialog(
                                           title: const Text("해당 종목을 삭제하시겠습니까?"),
                                           content: const Text("삭제하시려면 예를 눌러주세요"),
                                           actions: [
                                             TextButton(
                                               child: const Text("예"),
                                               onPressed: () async {

                                                 await dbHelper.deleteStock(stock);

                                                 getStocks();

                                                 // setState(() {
                                                 //   stocks.removeAt(idx);
                                                 // });

                                                 Navigator.of(context).pop();
                                               },
                                             ),

                                             TextButton(
                                               child: const Text("아니오"),
                                               onPressed: (){
                                                 Navigator.of(context).pop();
                                               },
                                             ),
                                           ],
                                         )
                                       );
                                     },
                                   )
                               ),
                           )
                         ],
                       )
                   );
                  },
                  itemCount: stocks.length,
                ),
            ),

            // Container(
            //   child: Row(
            //     children: [
            //       Expanded(
            //           child: TextField(
            //             controller: nameCtrl,
            //           )
            //       ),
            //       Container(width: 6),
            //       Expanded(
            //           child: TextField(
            //             controller: priceCtrl,
            //           )
            //       ),
            //       Container(width: 6),
            //       Expanded(
            //           child: TextField(
            //             controller: amountCtrl,
            //           )
            //       ),
            //       Container(width: 6),
            //       Expanded(
            //           child: TextField(
            //             controller: marketCapCtrl,
            //           )
            //       ),
            //
            //       InkWell(
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(
            //             horizontal: 20,
            //             vertical: 16
            //           ),
            //           margin: const EdgeInsets.symmetric(
            //             horizontal: 12
            //           ),
            //           decoration: BoxDecoration(
            //             color: mainColor
            //           ),
            //           child: Text("입력"),
            //         ),
            //         onTap: (){ // 클릭했을 때 어떤 이벤트 발생할건지
            //           String name = nameCtrl.text;
            //           int? price = int.tryParse(priceCtrl.text);
            //           String amount = amountCtrl.text;
            //           String marketCap = marketCapCtrl.text;
            //
            //           Stock stock = Stock(
            //             name: name,
            //             price: price?? 0, // null 일 경우, default 0
            //             amount: amount,
            //             marketCap: marketCap
            //           );
            //
            //           setState(() {
            //             if(index >= 0){
            //               // 수정 중
            //               stocks[index] = stock;
            //             }else{
            //               // 새로 추가
            //               stocks.add(stock);
            //             }
            //
            //             // 초기화
            //             index = -1;
            //
            //             nameCtrl.text = "";
            //             priceCtrl.text = "";
            //             amountCtrl.text = "";
            //             marketCapCtrl.text = "";
            //           });
            //         },
            //       )
            //     ],
            //   ),
            // ),
            Container(height: 100),

            // Expanded(
            //     flex: 100,
            //     child: GridView.count(
            //       crossAxisCount: 3,
            //       childAspectRatio: 1,
            //       crossAxisSpacing: 2,
            //       mainAxisSpacing: 2,
            //       children: List.generate(
            //           30, (idx) {
            //             return Container(
            //               alignment: Alignment.center,
            //               //child: Text("$idx"),
            //               child: Image.network(
            //                 "https://a.cdn-hotels.com/gdcs/production47/d1059/04077388-e2a5-4952-88d6-4cd6ffe07710.jpg",
            //                 fit: BoxFit.cover,
            //                 width: double.infinity,
            //                 height: double.infinity,
            //               ),
            //         );
            //       }),
            // ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Stock stock = Stock(
              id: -1,
              name: "",
              price:  0, // null 일 경우, default 0
              amount: "",
              marketCap: "",
          );

          Stock? _stock = await Navigator.of(context).push( // nullable
            MaterialPageRoute(
              builder: (ctx) => StockAddPage(stock: stock)
            )
          );

          getStocks();

          // if(_stock != null){
          //   setState(() {
          //     stocks.add(_stock);
          //   });
          // }
        },
        tooltip: 'Increment',
        backgroundColor: mainColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class StockAddPage extends StatefulWidget {
  Stock stock;
  StockAddPage({Key? key, required this.stock}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _StockAddPageState();
  }
}

class _StockAddPageState extends State<StockAddPage> {

  Stock get stock => widget.stock;

  DatabaseHelper dbHelper = DatabaseHelper.instance;

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController amountCtrl = TextEditingController();
  TextEditingController marketCapCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    nameCtrl.text = stock.name;
    priceCtrl.text = stock.price.toString();
    amountCtrl.text = stock.amount;
    marketCapCtrl.text = stock.marketCap;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("주식 종목 추가"),
        actions: [
          TextButton(
            child: const Text("저장", style: TextStyle(color: Colors.white),),
            onPressed: () async {
              String name = nameCtrl.text;
              int? price = int.tryParse(priceCtrl.text);
              String amount = amountCtrl.text;
              String marketCap = marketCapCtrl.text;

              stock.name = name;
              stock.price = price ?? 0;
              stock.amount = amount;
              stock.marketCap = marketCap;

              // 데이터베이스 삽입 혹은 갱신
              if(stock.id < 0){
                // 추가
                await dbHelper.insertStock(stock);
              }
              else{
                // 수정
                await dbHelper.updateStock(stock);
              }

              Navigator.of(context).pop(stock);
            },
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("종목명"),
            TextField(
              controller: nameCtrl,
            ),
            Container(height: 16),
            const Text("현재가"),
            TextField(
              controller: priceCtrl,
            ),
            Container(height: 16),
            const Text("거래대금"),
            TextField(
              controller: amountCtrl,
            ),
            Container(height: 16),
            const Text("시가 총액"),
            TextField(
              controller: marketCapCtrl,
            ),
          ],
        )
      ),
    );
  }
}

class Stock {
  int id; // pk
  String name; // 종목명
  int price; // 가격
  String amount; // 거래대금
  String marketCap; // 시총

  Stock({
    required this.id,
    required this.name,
    required this.price,
    required this.amount,
    required this.marketCap
  });

  factory Stock.fromDatabase(Map<String, dynamic> data){
    return Stock(
        id: data["id"],
        name: data["name"].toString(),
        price: data["price"],
        amount: data["amount"].toString(),
        marketCap: data["cap"].toString()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "price": this.price,
      "amount": this.amount,
      "cap": this.marketCap
    };
  }
}