import 'package:flutter/material.dart';
import 'package:todoapp/add_task_form.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/task.dart';
import 'package:todoapp/task_detailed_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

   @override
  State<TodoListPage> createState() => _TodoListPageState();

}

class _TodoListPageState extends State<TodoListPage>{

  late List<Task> tasks;
  late Future<List<Task>> tasksFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tasksFuture = DatabaseHelper().getTasks();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        //backgroundColor: Colors.blue,
        title: Text('Todo List')
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){ 
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddTaskForm()))
          .then((value) {
            setState(() {
              tasksFuture = DatabaseHelper().getTasks();
            });
          });
        },),


      body: FutureBuilder(
        future: tasksFuture, builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasError){
            return Center(child: Text('An error has occured ${snapshot.error}'));
          }


          if(snapshot.hasData){
            tasks = snapshot.data;
            return ListView.separated(
        itemCount: tasks.length,
        itemBuilder: (context, index){
          Task thisTask = tasks[index];
        return ListTile(
          onTap: (){
            MaterialPageRoute route = MaterialPageRoute(builder: (BuildContext context){
              return TaskDetailedPage(thisTask, updateListItemByIndex);
            });
            Navigator.of(context).push(route);
          },
          title: Text(thisTask.title,
          style: TextStyle(decoration:(thisTask.status == 'Complete')?TextDecoration.lineThrough : TextDecoration.none ),),
          subtitle: Text(thisTask.description),
          trailing: Checkbox(value: thisTask.status == 'Complete', onChanged: (bool? value){ 

            Map<String,String> mapDataToUpdate;

            if(value == true){
              mapDataToUpdate = {'Status':'Complete'};
              thisTask.status = 'Complete';
            }else{
              mapDataToUpdate = {'Status':'Incomplete'};
              thisTask.status = 'Incomplete';
            }

            DatabaseHelper().updateTask(thisTask.taskId!, mapDataToUpdate);

           updateListItemByIndex(thisTask);

          }),
        );
      }, 
      separatorBuilder: (BuildContext context, int index) {  
        return Divider();
      },);
          }

          return Center(child: CircularProgressIndicator()); 
          //a criscularprogressindicator helyettesítődik azzal az iffel amelyik igaz lesz a fentiek közül

        }),
      
      
      
      
      
    );
  }

  updateListItemByIndex(Task task){
    int index = tasks.indexWhere((element) => element.taskId == task.taskId);

     tasks[index] = task;

    setState(() {});
  }
  
 
}