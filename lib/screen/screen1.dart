import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../db/db.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  List<Map<String , dynamic>> _allData =[];
  bool _isloading = true;

  void _refreshData() async{
    final data = await Db.getAllData();
    setState(() {
      _allData = data;
      _isloading = false;
    });

  }
  @override
  void initState(){
    super.initState();
    _refreshData();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Future<void> _addData() async{
    await Db.createData(_titleController.text, _descController.text);
    _refreshData();
  }
  Future<void> _updateData(int id) async{
    await Db.updateData(id, _titleController.text, _descController.text);
    _refreshData();
  }

  void _deleteData(int id) async{
    await Db.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,

      content: Text("Data Deleted"),
    ));
    _refreshData();
  }

  void showBottomSheet(int? id) async{
    if(id!=null)
    {
      final existingData = _allData.firstWhere((element) => element['id']==id);
      _titleController.text = existingData['title'];
      _descController.text = existingData['desc'];

    }
    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 30,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom+50,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Title"
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: _descController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Description"
                ),
              ),
              SizedBox(height: 20,),
              Center(
                child: ElevatedButton(
                  onPressed: () async{
                    if(id==null){
                      await _addData();
                    }
                    if(id !=null){
                      await _updateData(id);
                    }
                    _titleController.text ="";
                    _descController.text ="";

                    Navigator.of(context).pop();
                  print("Data Added");
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(id == null ? "Add Data":"Update",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),),
                  ),
                ),
              )
            ],
          ),
        ),

    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text("CRUD Operations"),
      ),
      body: _isloading ?
          Center(
            child:CircularProgressIndicator()):
          ListView.builder(
            itemCount: _allData.length,
            itemBuilder: (context,index) => Card(
              margin: EdgeInsets.all(15),
              child:ListTile(
                title: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(_allData[index]['title'],
                  style: TextStyle(
                      fontSize: 20,
                  ),),
                ),
                subtitle: Text(_allData[index]['desc']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: (){
                      showBottomSheet(_allData[index]['id']);
                    }, icon: Icon(Icons.edit,color: Colors.black,)
                    ),
              IconButton(onPressed: (){
                _deleteData(_allData[index]['id']);
                }, icon: Icon(Icons.delete,color: Colors.black,)),
                  ],
                ),
              ) ,
            ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
        child: Icon(Icons.add),
      ),

    );
  }
}
