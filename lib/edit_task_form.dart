import 'package:flutter/material.dart';
import 'package:todoapp/task.dart';

class EditTaskForm extends StatelessWidget{

  TextEditingController controllertitle = TextEditingController();
  TextEditingController controllerdescription = TextEditingController();
  
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Task task;

  EditTaskForm(this.task, {super.key}){
  controllertitle.text = task.title;
  controllerdescription.text = task.description;
  }

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
          onPressed: (){
            
            if(formkey.currentState!.validate()){
              bool success = true;

              //Add a snackbar
              //Show status
              if(success){
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task updated'),));
              }
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update the task'),));
            }

           },
          child: Text('Save changes'))
        ],
      )
      )
      ),
    );
  }

}