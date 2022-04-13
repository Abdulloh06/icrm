import 'dart:io';
import 'package:icrm/widgets/projects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../repository/user_token.dart';
import '../util/colors.dart';

class SqliteApp extends StatefulWidget {
  const SqliteApp({Key? key}) : super(key: key);

  @override
  _SqliteAppState createState() => _SqliteAppState();
}

class _SqliteAppState extends State<SqliteApp> {
  int? selectedId;
  final textController = TextEditingController();
  bool isRemove = false;
  bool showTextField = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          /**      Projects       * */

          Container(
            height: 90,
            // color: Colors.green,
            child: FutureBuilder<List<Grocery>>(
                future: DatabaseHelper.instance.getGroceries(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Grocery>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text('Loading...'));
                  }
                  return snapshot.data!.isEmpty
                      ? Center(child: LocaleText('empty'))
                      : ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.map((grocery) {
                      return Container(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onLongPress: () {
                            setState(() {
                              isRemove = !isRemove;
                            });
                          },
                          child: Container(
                            height: 45,
                            child: Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  Projects(
                                      title: grocery.name,
                                      background: Color.fromARGB(
                                          255, 231, 247, 235),
                                      textColor: Color.fromARGB(
                                          255, 97, 200, 119),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      splashColor: Color.fromARGB(
                                          1, 144, 239, 165)),
                                  Positioned(
                                    top: 0,
                                    child: Visibility(
                                      visible: isRemove,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            padding: EdgeInsets.only(
                                                bottom: 20),
                                            child: GestureDetector(
                                              onTap: () async {
                                                selectedId != null
                                                    ? textController
                                                    .text ==
                                                    ''
                                                    ? null
                                                    : await DatabaseHelper
                                                    .instance
                                                    .update(Grocery(
                                                    id:
                                                    selectedId,
                                                    name: textController
                                                        .text))
                                                    : textController
                                                    .text ==
                                                    ''
                                                    ? null
                                                    : await DatabaseHelper
                                                    .instance
                                                    .add(Grocery(
                                                    name: textController
                                                        .text));
                                                setState(() {
                                                  textController.clear();
                                                  selectedId = null;
                                                  showTextField =
                                                  !showTextField;
                                                });
                                                setState(() {
                                                  textController.text =
                                                      grocery.name;
                                                  selectedId = grocery.id;
                                                });
                                              },
                                              child: SvgPicture.asset(
                                                  'assets/icons_svg/editable.svg',
                                                  height: 18,
                                                  width: 20),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            width: 20,
                                            child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    DatabaseHelper
                                                        .instance
                                                        .remove(
                                                        grocery.id!);
                                                    isRemove = !isRemove;
                                                  });
                                                },
                                                child: RotationTransition(
                                                  alignment:
                                                  Alignment.topRight,
                                                  turns:
                                                  AlwaysStoppedAnimation(
                                                      45 / 360),
                                                  child: SvgPicture.asset(
                                                      'assets/icons_svg/add_icon.svg',
                                                      height: 18),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
          ),
          /**      Add button       **/
          Positioned(
            height: showTextField == false ? 25 : 35,
            top: 8,
            right: 10,
            child: GestureDetector(
              child: SvgPicture.asset(
                'assets/icons_svg/add_icon.svg',
                height: showTextField == false ? 25 : 35,
              ),
              onTap: () async {
                selectedId != null
                    ? textController.text == ''
                    ? null
                    : await DatabaseHelper.instance.update(
                  Grocery(id: selectedId, name: textController.text),
                )
                    : textController.text == ''
                    ? null
                    : await DatabaseHelper.instance.add(
                  Grocery(name: textController.text),
                );
                setState(() {
                  textController.clear();
                  selectedId = null;
                  showTextField = !showTextField;
                });
              },
            ),
          ),
          /**      Add textfield       **/
          showTextField == true
              ? Positioned(
              child: Container(
                margin: EdgeInsets.only(right: 50),
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 40,
                width: 300,
                child: TextField(
                    cursorHeight: 20,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Write'),
                    controller: textController),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color:
                    UserToken.isDark ? AppColors.mainDark : Colors.white,
                    border: Border.all(width: 1, color: AppColors.mainColor),
                    boxShadow: UserToken.isDark
                        ? [
                      BoxShadow(
                          color: Colors.grey.shade800,
                          blurRadius: 6,
                          spreadRadius: 3,
                          offset: Offset(0, 3))
                    ]
                        : [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 6,
                          spreadRadius: 3,
                          offset: Offset(0, 3))
                    ]),
              ))
              : Container(),
        ],
      ),
    );
  }
}

class Grocery {
  final int? id;
  final String name;

  Grocery({this.id, required this.name});

  factory Grocery.fromMap(Map<String, dynamic> json) => Grocery(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'groceries.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE groceries(
          id INTEGER PRIMARY KEY,
          name TEXT
      )
      ''');
  }

  Future<List<Grocery>> getGroceries() async {
    Database db = await instance.database;
    var groceries = await db.query('groceries', orderBy: 'name');
    List<Grocery> groceryList = groceries.isNotEmpty
        ? groceries.map((c) => Grocery.fromMap(c)).toList()
        : [];
    return groceryList;
  }

  Future<int> add(Grocery grocery) async {
    Database db = await instance.database;
    return await db.insert('groceries', grocery.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('groceries', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Grocery grocery) async {
    Database db = await instance.database;
    return await db.update('groceries', grocery.toMap(),
        where: 'id = ?', whereArgs: [grocery.id]);
  }
}