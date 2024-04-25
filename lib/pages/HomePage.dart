import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rubrica2_israel_trujillo/widgets/WTextfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, Task> tasks = {
    "task1": Task(
        "Prueba",
        "Consequat occaecat eu fugiat occaecat. Sint eiusmod amet velit sint consequat",
        false)
  };
  Map<String, Task> filteredTasks = {};
  String currentFilter = "all";

  @override
  void initState() {
    super.initState();
    applyFilter("all");
  }

  var count = 1;

  TextEditingController ctlTitle = TextEditingController();
  TextEditingController ctlDescription = TextEditingController();

  //* MUESTRA LA NOTIFICACIÓN DE VALIDACIÓN
  void showNotification(String texto) {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text("Accept"));

    AlertDialog alert = AlertDialog(
      title: const Text("Notification"),
      content: Text(texto),
      actions: [okButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  dynamic validateField(
      String value, String label, bool required, bool numeric) {
    String result = "";

    if (required) {
      if (value.isEmpty) {
        result += "\nThe field $label cannot be empty";
      }
    }

    if (numeric) {
      try {
        double.parse(value);
      } catch (e) {
        result += "\nThe field $label must be numeric";
      }
    }

    if (result.isNotEmpty) {
      showNotification(result);
      return false;
    } else {
      return true;
    }
  }

  void addNewTask(String title, String description) {
    setState(() {
      tasks["tasks${count + 1}"] = Task(title, description, false);
      count = count + 1;
      currentFilter = "all";
      applyFilter("all");
    });
  }

  void removeTask(String key) {
    setState(() {
      tasks.remove(key);
      applyFilter(currentFilter);
    });
  }

  void toggleCompletedTask(String key) {
    setState(() {
      tasks[key]?.toogleCompleted();
      applyFilter(currentFilter);
    });
  }

  void applyFilter(String filter) {
    setState(() {
      switch (filter) {
        case "all":
          filteredTasks = tasks;
          break;
        case "pending":
          filteredTasks = {};
          tasks.forEach((key, task) {
            if (task.completed == false) {
              filteredTasks[key] = task;
            }
          });
          break;
        case "completed":
          filteredTasks = {};
          tasks.forEach((key, task) {
            if (task.completed == true) {
              filteredTasks[key] = task;
            }
          });
          break;
        default:
      }
    });
  }

  void clearFields() {
    ctlTitle.text = "";
    ctlDescription.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task list - Israel Trujillo"),
      ),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            filterButton("all", "All"),
            filterButton("pending", "Pending"),
            filterButton("completed", "Completed"),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Center(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: filteredTasks.entries
                    .map((task) => Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.only(bottom: 20, top: 10),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 250,
                                padding: const EdgeInsets.only(left: 50),
                                child: ListView(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (task.value.completed)
                                              ? 'Completed'
                                              : 'Uncompleted',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: (task.value.completed)
                                                  ? Colors.green
                                                  : Colors.red),
                                        ),
                                        Text(
                                          task.value.title,
                                          style: TextStyle(
                                              fontSize: 20,
                                              decoration: (task.value.completed
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none)),
                                        ),
                                        Text(
                                          task.value.description,
                                          style: TextStyle(
                                              fontSize: 15,
                                              decoration: (task.value.completed
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    (task.value.completed == false
                                        ? IconButton(
                                            onPressed: () {
                                              toggleCompletedTask(task.key);
                                            },
                                            icon: const Icon(Icons.check),
                                            color: Colors.green)
                                        : IconButton(
                                            onPressed: () {
                                              toggleCompletedTask(task.key);
                                            },
                                            icon: const Icon(Icons.remove_done),
                                            color: Colors.red)),
                                    IconButton(
                                        onPressed: () {
                                          removeTask(task.key);
                                        },
                                        icon: const Icon(Icons.delete),
                                        color: Colors.black)
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {clearFields(), showNewTaskModal(context)},
        tooltip: "Add new task",
        child: const Icon(Icons.add),
      ),
    );
  }

  TextButton filterButton(String filter, String label) {
    bool isActive = currentFilter == filter;
    return TextButton(
      onPressed: () {
        setState(() {
          currentFilter = filter;
          applyFilter(currentFilter);
        });
      },
      style: ButtonStyle(
        backgroundColor:
            isActive ? MaterialStateProperty.all(Colors.teal) : null,
        foregroundColor:
            isActive ? MaterialStateProperty.all(Colors.white) : null,
      ),
      child: Text(label),
    );
  }

  Future<dynamic> showNewTaskModal(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 500,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      "Add a new Task",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 30),
                    WTextField(
                        ctl: ctlTitle,
                        label: "Title",
                        keyboard: TextInputType.text),
                    WTextField(
                        ctl: ctlDescription,
                        label: "Description",
                        keyboard: TextInputType.text),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () {
                            final titleValid = validateField(
                                ctlTitle.text, "Title", true, false);
                            final descriptionValid = validateField(
                                ctlDescription.text,
                                "Description",
                                true,
                                false);

                            if (titleValid == true &&
                                descriptionValid == true) {
                              addNewTask(ctlTitle.text, ctlDescription.text);
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white),
                          child: const Text("Save")),
                    )
                  ],
                ),
              ));
        });
  }
}

class Task {
  String title = "";
  String description = "";
  bool completed = false;

  Task(this.title, this.description, this.completed);

  void toogleCompleted() {
    completed = !completed;
  }
}
