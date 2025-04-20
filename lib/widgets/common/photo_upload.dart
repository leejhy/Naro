import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:naro/widgets/common/photo_viewer.dart';

class PhotoUpload extends StatefulWidget {
  const PhotoUpload({super.key});

  @override
  State<PhotoUpload> createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {

  final picker = ImagePicker();
  // XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> multiImage = []; // 갤러리에서 여러 장의 사진을 선택해서 저장할 변수
  List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text('사진', style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
          ),
          Row(
            children: [
              // IconButton(
              //   onPressed: () async {
              //   image = await picker.pickImage(source: ImageSource.camera);
              //   //카메라로 촬영하지 않고 뒤로가기 버튼을 누를 경우, null값이 저장되므로 if문을 통해 null이 아닐 경우에만 images변수로 저장하도록 합니다
              //   if (image != null) {
              //     setState(() {
              //       images.add(image);
              //     });
              //   }
              // },
              //   icon: Icon(Icons.camera_alt, color: Colors.black)
              // ),
              IconButton(
                onPressed: () async {multiImage = await picker.pickMultiImage();
                  setState(() {
                    //multiImage를 통해 갤러리에서 가지고 온 사진들은 리스트 변수에 저장되므로 addAll()을 사용해서 images와 multiImage 리스트를 합쳐줍니다. 
                    images.addAll(multiImage);
                  });
                },
                icon: Icon(Icons.add_photo_alternate, color: Colors.black)
              ),
              
              // PhotoAddButton(),
              // SizedBox(width: 10),
              // PhotoAddButton(),
              // SizedBox(width: 10),
              // PhotoAddButton(),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1 / 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PhotoViewer(imagePath: images[index]!.path),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage(File(images[index]!.path)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(20, 0, 0, 0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.close, color: Colors.white, size: 15),
                      onPressed: () {
                        setState(() {
                          images.removeAt(index);
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class PhotoAddButton extends StatefulWidget {
  const PhotoAddButton({super.key});

  @override
  State<PhotoAddButton> createState() => _PhotoAddButtonState();
}

class _PhotoAddButtonState extends State<PhotoAddButton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('photo button'),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 167, 167, 167),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade500)
        ),
        child: const Icon(Icons.camera_alt, color: Colors.black),
      )
    );
  }
}

