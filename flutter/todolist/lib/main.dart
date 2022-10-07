import 'package:flutter/material.dart';
import 'package:todolist/view/history.dart';
import 'package:todolist/view/home.dart';
import 'package:todolist/view/more.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

Color bgColor = Colors.white;
Color txtColor = Colors.black;

bool darkMode = false;

TextStyle smallStyle = TextStyle(
  color: txtColor,
  fontSize: 12
);

TextStyle mediumStyle = TextStyle(
    color: txtColor,
    fontSize: 14
);

TextStyle largeStyle = TextStyle(
    color: txtColor,
    fontSize: 18
);

void setDarkMode() {

  if(darkMode){
    bgColor = Colors.black;
    txtColor = Colors.white;
  }else{
    bgColor = Colors.white;
    bgColor = Colors.black;
  }

  smallStyle = TextStyle(
      color: txtColor,
      fontSize: 12
  );

  mediumStyle = TextStyle(
      color: txtColor,
      fontSize: 14
  );

  largeStyle = TextStyle(
      color: txtColor,
      fontSize: 18
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
          child: AppBar(
            title: Text(""),
            backgroundColor: bgColor,
            elevation: 0.0,
      )),
      backgroundColor: bgColor,
      body: Container(
        child: getPage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // 바텀 내비게이션 클릭 시 이동
        currentIndex: _currentIndex,
        onTap: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        backgroundColor: bgColor,
        selectedItemColor: Colors.blue,
        unselectedItemColor: txtColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "기록"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "더보기"),
        ],
      ), // auto-formatting nicer for build methods.
    );
  }

  // 페이지 위젯

  Widget getPage() {
    if(_currentIndex == 0){
      return Container(
        child: TodoHomePage(),
      );
    }else if(_currentIndex == 1){
      return Container(
        child: TodoHistoryPage(),
      );
    }
    else{
      return Container(
        child: MorePage(),
      );
    }
  }
}
