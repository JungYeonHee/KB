import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/data/database.dart';

import '../data/todo.dart';
import '../main.dart';

class TodoCard extends StatelessWidget {
  Todo todo;

  TodoCard({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        decoration: BoxDecoration(
            color: todo.color, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(todo.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text(todo.done ? "완료" : "미완료",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))
              ],
            ),
            Container(height: 16),
            Text(todo.memo, style: TextStyle(color: Colors.white)),
            Container(height: 8),
            Text(todo.category, style: TextStyle(color: Colors.white),),
          ],
        ));
  }
}

class TodoCreatePage extends StatefulWidget {
  Todo todo;

  TodoCreatePage({Key? key, required this.todo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TodoCreatePageState();
  }
}

class _TodoCreatePageState extends State<TodoCreatePage> {
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController memoCtrl = TextEditingController();

  Todo get todo => widget.todo;

  @override
  void initState() {
    titleCtrl.text = todo.title;
    memoCtrl.text = todo.memo;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: txtColor),
        centerTitle: true,
        title: Text("투두 입력", style: mediumStyle),
        actions: [
          TextButton(
            child: Text("저장"),
            onPressed: () async {
              todo.title = titleCtrl.text;
              todo.memo = memoCtrl.text;

              DatabaseHelper dbHelper = DatabaseHelper.instance;

              if(todo.id < 0){
                await dbHelper.insertTodo(todo);
              }else{
                await dbHelper.updateTodo(todo);
              }


              Navigator.of(context).pop(todo);

            },
          )
        ],
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
      body: Container(
        child: ListView.builder(
          itemBuilder: (ctx, idx) {
            if (idx == 0) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("제목", style: largeStyle),
                    TextField(
                      controller: titleCtrl,
                    )
                  ],
                ),
              );
            } else if (idx == 1) {
              return InkWell(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "색상",
                        style: largeStyle,
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        color: todo.color,
                      )
                    ],
                  ),
                ),
                onTap: () async {
                  Color? color = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => ColorSelectPage()));
                  if (color != null) {
                    setState(() {
                      todo.color = color;
                    });
                  }
                },
              );
            } else if (idx == 2) {
              return InkWell(child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "카테고리",
                        style: largeStyle,
                      ),
                      Text(
                        todo.category,
                        style: largeStyle,
                      )
                    ],
                  ),
                ),
                onTap: () async {
                  String? category = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (ctx) => CategorySelectPage()
                    )
                  );
                  if(category != null){
                    setState(() {
                      todo.category = category;
                    });
                  }
                }
              );
            } else if (idx == 3) {
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: TextField(
                  controller: memoCtrl,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  minLines: 10,
                  maxLines: 20,
                ),
              );
            }
            return Container();
          },
          itemCount: 8,
        ),
      ),
    );
  }
}

class ColorSelectPage extends StatelessWidget {
  List<Color> colors = [
    Colors.redAccent,
    Colors.orange,
    Colors.green,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 1, // 정사각형 1:1
            children: List.generate(colors.length, (idx) {
              return InkWell(
                child: Container(
                  color: colors[idx],
                ),
                onTap: () {
                  Navigator.of(context).pop(colors[idx]);
                },
              );
            })),
      ),
    );
  }
}

class CategorySelectPage extends StatelessWidget {

  List<String> categories = [
    "공부",
    "운동",
    "요리"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView(
          children: List.generate(
            categories.length,
              (idx){
                return Container(
                  child: ListTile(
                    title: Text(categories[idx]),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: (){
                      Navigator.of(context).pop(categories[idx]);
                    },
                ),
                );
              }
            ),
        ),
      ),
    );
  }
}
