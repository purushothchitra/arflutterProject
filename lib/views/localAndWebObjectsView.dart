// import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
// import 'package:ar_flutter_plugin/datatypes/node_types.dart';
// import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
// import 'package:ar_flutter_plugin/models/ar_node.dart';
// import 'package:flutter/material.dart';
// import 'package:vector_math/vector_math_64.dart';
//
// class LocalAndWebObjectsView extends StatefulWidget {
//   const LocalAndWebObjectsView({Key? key}) : super(key: key);
//
//   @override
//   State<LocalAndWebObjectsView> createState() => _LocalAndWebObjectsViewState();
// }
//
// class _LocalAndWebObjectsViewState extends State<LocalAndWebObjectsView> {
//   late ARSessionManager arSessionManager;
//   late ARObjectManager arObjectManager;
//
//   //String localObjectReference;
//   ARNode? localObjectNode;
//
//   //String webObjectReference;
//   ARNode? webObjectNode;
//
//   @override
//   void dispose() {
//     arSessionManager.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Local / Web Objects"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height * .8,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(22),
//                 child: ARView(
//                   onARViewCreated: onARViewCreated,
//                 ),
//               ),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                       onPressed: onLocalObjectButtonPressed,
//                       child: const Text("Add / Remove Local Object")),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: ElevatedButton(
//                       onPressed: onWebObjectAtButtonPressed,
//                       child: const Text("Add / Remove Web Object")),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void onARViewCreated(
//       ARSessionManager arSessionManager,
//       ARObjectManager arObjectManager,
//       ARAnchorManager arAnchorManager,
//       ARLocationManager arLocationManager) {
//     this.arSessionManager = arSessionManager;
//     this.arObjectManager = arObjectManager;
//
//     this.arSessionManager.onInitialize(
//       showFeaturePoints: false,
//       showPlanes: true,
//       customPlaneTexturePath: "assets/triangle.png",
//       showWorldOrigin: true,
//       handleTaps: true,
//     );
//     this.arObjectManager.onInitialize();
//   }
//
//   Future<void> onLocalObjectButtonPressed() async {
//     if (localObjectNode != null) {
//       arObjectManager.removeNode(localObjectNode!);
//       localObjectNode = null;
//     } else {
//       var newNode = ARNode(
//           type: NodeType.localGLTF2,
//           uri: "C:/Users/Purushothaman/AndroidStudioProjects/arflutterplugin/assets/images/captain.gltf",
//           scale: Vector3(0.2, 0.2, 0.2),
//           position: Vector3(0.0, 0.0, 0.0),
//           rotation: Vector4(1.0, 0.0, 0.0, 0.0));
//       bool? didAddLocalNode = await arObjectManager.addNode(newNode);
//       localObjectNode = (didAddLocalNode!) ? newNode : null;
//     }
//   }
//
//   Future<void> onWebObjectAtButtonPressed() async {
//     if (webObjectNode != null) {
//       arObjectManager.removeNode(webObjectNode!);
//       webObjectNode = null;
//     } else {
//       var newNode = ARNode(
//           type: NodeType.webGLB,
//           uri:
//           "https://sketchfab.com/3d-models/rifle-ak-47-weapon-model-cs2-6b2244ba66274c71abdd194d0b04f731",
//           scale: Vector3(0.2, 0.2, 0.2));
//       bool? didAddWebNode = await arObjectManager.addNode(newNode);
//       webObjectNode = (didAddWebNode!) ? newNode : null;
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart' as vector64;
import 'package:speech_to_text/speech_to_text.dart';
//import 'tts.dart';

class Custom3dObjectScreen extends StatefulWidget {
  const Custom3dObjectScreen({super.key});

  @override
  State<Custom3dObjectScreen> createState() => _Custom3dObjectScreenState();
}

class _Custom3dObjectScreenState extends State<Custom3dObjectScreen> {

  var textSpeech = "CLICK ON MIC TO RECORD";
  SpeechToText speechToText = SpeechToText();
  var isListening = false;

  void checkMic() async{
    bool micAvailable = await speechToText.initialize();

    if(micAvailable){
      print("MicroPhone Available");
    }else{
      print("User Denied th use of speech micro");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkMic();

  }

  late ARSessionManager sessionManager;
  late ARObjectManager objectManager;
  late ARAnchorManager anchorManager;

  List<ARNode> allNodes = [];
  List<ARAnchor> allAnchor = [];
  List<ARAnchor> storeAnchor = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom 3d Objects"),
        centerTitle: true,
      ),
      body: SizedBox(
        child: Stack(
          children: [
            ARView(
              planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
              onARViewCreated: whenARViewCreated,
            ),
            Positioned(
              bottom: 15,
              right: 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      removeModel().then((_) {
                        addNewModel();
                      });
                    },
                    child: const Text("Load New Model"),
                  ),
                  ElevatedButton(
                    onPressed: () async{
                      if(!isListening){
                        bool micAvailable = await speechToText.initialize();

                        if(micAvailable){
                          setState(() {
                            isListening = true;
                          });

                          speechToText.listen(
                              listenFor: Duration(seconds: 20),
                              onResult: (result){
                                setState(() {
                                  textSpeech = result.recognizedWords;
                                  print(textSpeech);
                                  isListening = false;
                                });
                              }
                          );


                        }
                      }else{
                        setState(() {
                          isListening = false;

                          speechToText.stop();
                        });
                      }
                    },
                    child: const Text("Speak"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void whenARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager,
      ) {
    sessionManager = arSessionManager;
    objectManager = arObjectManager;
    anchorManager = arAnchorManager;

    sessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      //customPlaneTexturePath: 'assets/triangle.png',
      showWorldOrigin: true,
      handlePans: true,
      handleRotation: true,
    );
    objectManager.onInitialize();

    sessionManager.onPlaneOrPointTap = whenPlaneDetectedAndUserTapped;
  }

  void whenPlaneDetectedAndUserTapped(List<ARHitTestResult> tapResults) {
    if (allNodes.isNotEmpty) {
      return;
    }

    try {
      final userHitTestResult = tapResults.firstWhere(
              (userTap) => userTap.type == ARHitTestResultType.plane);

      if (userHitTestResult != null) {
        final newPlaneARAnchor =
        ARPlaneAnchor(transformation: userHitTestResult.worldTransform);

        anchorManager.addAnchor(newPlaneARAnchor).then((isAnchorAdded) {
          if (isAnchorAdded!) {
            allAnchor.add(newPlaneARAnchor);
            storeAnchor.add(newPlaneARAnchor);

            final nodeNew3dObject = ARNode(
              type: NodeType.webGLB,
              uri:
                  //"https://firebasestorage.googleapis.com/v0/b/my-3d-models-78fc3.appspot.com/o/Testing%20V1%20(1).glb?alt=media&token=498ebe77-bd57-4abf-9999-e025324a549a",
              //"https://firebasestorage.googleapis.com/v0/b/my-3d-models-78fc3.appspot.com/o/robot_walk_animation.glb?alt=media&token=079590dd-db0a-4b80-81aa-44452ca55cf0",
                  //"https://firebasestorage.googleapis.com/v0/b/my-3d-models-78fc3.appspot.com/o/%D0%A1%D1%82%D0%BE%D0%BB.glb?alt=media&token=5a6264f7-32bf-48f1-8c5b-ffbfe18fa5fe",
              "https://firebasestorage.googleapis.com/v0/b/mdoels-8c7a1.appspot.com/o/avatarme.glb?alt=media&token=2ca1b06d-d338-4253-95b8-9f2147f00628",
              //"https://firebasestorage.googleapis.com/v0/b/my-3d-models-78fc3.appspot.com/o/avatarme.glb?alt=media&token=90dc54af-3366-4a64-bff1-c87bc3b88d0d",
              //"https://firebasestorage.googleapis.com/v0/b/my-3d-models-78fc3.appspot.com/o/Testing%20V1.glb?alt=media&token=c53afe07-2c55-4545-80e8-a8f09f1e31fd",
              //"https://firebasestorage.googleapis.com/v0/b/my-3d-models-78fc3.appspot.com/o/avatarme.glb?alt=media&token=90dc54af-3366-4a64-bff1-c87bc3b88d0d",
              scale: vector64.Vector3(0.3, 0.3, 0.3),
              position: vector64.Vector3(0, 0, 0),
              rotation: vector64.Vector4(1.0, 0, 0, 0),
            );

            objectManager
                .addNode(nodeNew3dObject, planeAnchor: newPlaneARAnchor)
                .then((isNewNodeAddedToNewAnchor) {
              if (isNewNodeAddedToNewAnchor!) {
                setState(() {
                  allNodes.add(nodeNew3dObject);
                });
              } else {
                sessionManager.onError("Attaching Node to Anchor Failed.");
              }
            });
          } else {
            sessionManager.onError("Adding Anchor Failed.");
          }
        });
      }
    } catch (e) {
      print('Error: $e');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to load 3D model. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }


  Future<void> removeModel() async
  {
    allAnchor.forEach((eachAnchor)
    {
      anchorManager!.removeAnchor(eachAnchor);
    });

    allAnchor = [];
  }

  void addNewModel() {
    if (storeAnchor.isNotEmpty) {
      final existingAnchor = storeAnchor.last as ARPlaneAnchor?;
      if (existingAnchor != null) {
        final nodeNew3dObject = ARNode(
          type: NodeType.webGLB,
          uri:
          //"https://firebasestorage.googleapis.com/v0/b/mdoels-8c7a1.appspot.com/o/DamagedHelmet.glb?alt=media&token=1a01e0fa-612d-4d87-808d-7ac07ed549a1",
          "https://firebasestorage.googleapis.com/v0/b/my-3d-models-78fc3.appspot.com/o/Testing%20V1.glb?alt=media&token=c53afe07-2c55-4545-80e8-a8f09f1e31fd",
          scale: vector64.Vector3(0.3, 0.3, 0.3),
          position: vector64.Vector3(0, 0, 0),
          rotation: vector64.Vector4(1.0, 0, 0, 0),
        );

        objectManager.addNode(nodeNew3dObject, planeAnchor: existingAnchor).then((isNewNodeAddedToExistingAnchor) {
          if (isNewNodeAddedToExistingAnchor!) {
            setState(() {
              allNodes.add(nodeNew3dObject);
            });
          } else {
            sessionManager.onError("Attaching Node to Anchor Failed.");
          }
        });
      } else {
        sessionManager.onError("No stored anchors available to add new model.");
      }
    } else {
      sessionManager.onError("No stored anchors available to add new model.");
    }
  }



  @override
  void dispose() {
    sessionManager.dispose();
    super.dispose();
  }
}