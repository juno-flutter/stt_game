// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stt_game/word_list_controller.dart';

class EditWord extends StatefulWidget {
  const EditWord({Key? key}) : super(key: key);

  @override
  State<EditWord> createState() => _EditWordState();
}

class _EditWordState extends State<EditWord> {
  TextEditingController controller1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        // scrolledUnderElevation: 20.0,
        // shadowColor: Colors.grey,
        title: const Text(
          '낱말 수정',
          textAlign: TextAlign.center,
        ),
      ),
      body: GetX<WordListController>(builder: (controller) {
        final orgText = controller.editWord.value;
        controller1.text = orgText;
        return Form(
          child: Theme(
            data: ThemeData(
              primaryColor: Colors.teal,
              inputDecorationTheme: const InputDecorationTheme(
                labelStyle: TextStyle(color: Colors.teal, fontSize: 25.0),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  TextField(
                    autofocus: true,
                    textAlign: TextAlign.center,
                    controller: controller1,
                    decoration: const InputDecoration(
                      labelText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    style: const TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back(result: controller1.text);
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(5),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      )),
                    ),
                    child: Container(
                      // alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      // padding: const EdgeInsets.all(5),
                      child: const Text(
                        'OK',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
