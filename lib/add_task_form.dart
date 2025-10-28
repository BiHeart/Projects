import 'package:flutter/material.dart';

import 'database_helper.dart';

class AddTaskForm extends StatelessWidget{

  TextEditingController controllertitle = TextEditingController();
  TextEditingController controllerdescription = TextEditingController();
  
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  AddTaskForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add a Task'),),
      body: Form(
        key: formkey,
        child:Padding(padding: const EdgeInsets.all(8.0),
        child: Column(
        children: [
          
          TextFormField(
          validator: (value){
            if(value == ''){
              return 'Please enter a title';
            }
            return null;
          },
          controller: controllertitle,
          decoration: const InputDecoration(hintText: 'Enter the task title'),),
          
          TextFormField(
          controller: controllerdescription,  
          decoration: const InputDecoration(hintText: 'Enter the task description'),),
          
          ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: ()async{
            
            if(formkey.currentState!.validate()){
              bool success = false;

              //Collect the inputs
              Map<String, String> task = {
                'title': controllertitle.text,
                'desc': controllerdescription.text,
                'user_id':'1',
                'status': 'Incomplete',
              };

              //Add task to database
              int rowId = await _addTaskToDB(task);

              success = rowId > 0;
              //Show status
              if(success){
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task added'),));
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add the task'),));
              }
              
            }

           },
          child: Text('Add task'))
        ],
      )
      )
      ),
    );
  }

  Future<int> _addTaskToDB(Map<String,String> taskMap)async{
     
      int row = await DatabaseHelper().addtask(taskMap);
      print('The id of the inserted item: $row');

      return row;
  }

}