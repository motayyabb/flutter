import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() => runApp(XylophoneApp());

class XylophoneApp extends StatefulWidget {
  @override
  _XylophoneAppState createState() => _XylophoneAppState();
}

class _XylophoneAppState extends State<XylophoneApp> {
  final player = AudioPlayer();
  List<Color> keyColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.purple,
  ];
  List<int> soundNumbers = [1, 2, 3, 4, 5, 6, 7];
  bool showSettings = false; // State variable to control visibility

  void playSound(int noteNumber) {
    player.play(AssetSource('note$noteNumber.wav'));
  }

  void changeKeyColor(int index, Color color) {
    setState(() {
      keyColors[index] = color;
    });
  }

  void changeSoundNumber(int index, int soundNumber) {
    setState(() {
      soundNumbers[index] = soundNumber;
    });
  }

  Expanded buildKey({required int index}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          playSound(soundNumbers[index]);
          setState(() {
            keyColors[index] = keyColors[index].withOpacity(0.7);
          });
          Future.delayed(const Duration(milliseconds: 200), () {
            setState(() {
              keyColors[index] = keyColors[index].withOpacity(1.0);
            });
          });
        },
        child: Material(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              color: keyColors[index],
            ),
            child: Center(
              child: Text(
                'Key ${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Customized Xylophone'),
          centerTitle: true,
          backgroundColor: Colors.indigoAccent,
          elevation: 12,
          actions: [
            IconButton(
              icon: Icon(showSettings ? Icons.close : Icons.edit),
              onPressed: () {
                setState(() {
                  showSettings = !showSettings; // Toggle settings visibility
                });
              },
            ),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  // Top side for xylophone keys
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(7, (index) => buildKey(index: index)),
                    ),
                  ),
                  // Bottom side for settings, shown based on the toggle button
                  if (showSettings) ...[
                    Expanded(
                      flex: 1,
                      child: SettingsScreen(
                        keyColors: keyColors,
                        soundNumbers: soundNumbers,
                        onColorChanged: changeKeyColor,
                        onSoundChanged: changeSoundNumber,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final List<Color> keyColors;
  final List<int> soundNumbers;
  final Function(int, Color) onColorChanged;
  final Function(int, int) onSoundChanged;

  SettingsScreen({
    required this.keyColors,
    required this.soundNumbers,
    required this.onColorChanged,
    required this.onSoundChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey[800]!, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SizedBox(
        height: double.infinity, // Ensure the container takes full height
        child: ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    color: Colors.blueGrey[700],
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        'Key ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('Color:', style: TextStyle(color: Colors.white)),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () async {
                                  Color? pickedColor = await showDialog(
                                    context: context,
                                    builder: (context) => ColorPickerDialog(
                                      initialColor: keyColors[index],
                                    ),
                                  );
                                  if (pickedColor != null) {
                                    onColorChanged(index, pickedColor);
                                  }
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: keyColors[index],
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.white, width: 1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Sound Number:', style: TextStyle(color: Colors.white)),
                              const SizedBox(width: 10),
                              DropdownButton<int>(
                                dropdownColor: Colors.grey[800],
                                value: soundNumbers[index],
                                items: List.generate(7, (soundNumber) {
                                  return DropdownMenuItem(
                                    value: soundNumber + 1,
                                    child: Text(
                                      'Sound ${soundNumber + 1}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  );
                                }),
                                onChanged: (newSound) {
                                  if (newSound != null) {
                                    onSoundChanged(index, newSound);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                  color: Colors.white,
                  width: 10,
                  thickness: 1,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ColorPickerDialog extends StatelessWidget {
  final Color initialColor;

  ColorPickerDialog({required this.initialColor});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a Color', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.blueGrey[900],
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: initialColor,
          onColorChanged: (color) {
            Navigator.pop(context, color);
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}