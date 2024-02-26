import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Physical Therapy App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExerciseScreen(),
    );
  }
}

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  // A list of exercises to display
  final List<ExerciseModel> exercises = [
    ExerciseModel(
      name: 'Neck Stretch',
      description: 'A simple exercise to relieve neck pain and stiffness',
      duration: '5 minutes',
      source: 'assets/videos/neck_stretch.mp4',
    ),
    ExerciseModel(
      name: 'Shoulder Rotation',
      description: 'A gentle exercise to improve shoulder mobility and flexibility',
      duration: '10 minutes',
      source: 'https://example.com/videos/shoulder_rotation.mp4',
    ),
    ExerciseModel(
      name: 'Back Extension',
      description: 'A strengthening exercise to support the lower back and prevent injury',
      duration: '15 minutes',
      source: 'assets/videos/back_extension.mp4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physical Therapy App'),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          // Get the current exercise
          final exercise = exercises[index];
          // Return a list tile with the exercise details
          return ListTile(
            leading: const Icon(Icons.fitness_center),
            title: Text(exercise.name),
            subtitle: Text('${exercise.description} - ${exercise.duration}'),
            trailing: const Icon(Icons.play_arrow),
            onTap: () {
              // Navigate to the video player screen with the exercise source
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    source: exercise.source,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  // The source of the video to play
  final String source;

  const VideoPlayerScreen({Key? key, required this.source}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  // The controller for the video player
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the video source
    _controller = VideoPlayerController.network(widget.source);
    // Add a listener to update the state when the controller is initialized
    _controller.addListener(() {
      setState(() {});
    });
    // Initialize the controller and start playing the video
    _controller.initialize().then((_) => _controller.play());
  }

  @override
  void dispose() {
    // Dispose the controller when the screen is closed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Center(
        // Display a loading indicator until the controller is initialized
        child: _controller.value.isInitialized
? AspectRatio(
                // Use the aspect ratio of the video
                aspectRatio: _controller.value.aspectRatio,
                // Use the video player widget to display the video
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        // Use the play or pause icon depending on the controller state
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
        onPressed: () {
          // Toggle the video playback state
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
      ),
    );
  }
}

class ExerciseModel {
  // The name of the exercise
  final String name;
  // The description of the exercise
  final String description;
  // The duration of the exercise
  final String duration;
  // The source of the video for the exercise
  final String source;

  ExerciseModel({
    required this.name,
    required this.description,
    required this.duration,
    required this.source,
  });
}
