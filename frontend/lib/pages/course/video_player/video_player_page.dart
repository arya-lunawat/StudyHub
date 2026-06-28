import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../widgets/comment_section.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({Key? key}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  String? _videoUrl;
  String? _errorMessage;
  bool _hasError = false;
  bool _isLoading = true;
  bool _isFullScreen = false;
  bool _showControls = true;
  int? _courseId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_videoUrl == null) {
      try {
        final args = ModalRoute.of(context)!.settings.arguments as Map?;

        if (args == null) {
          _setError('No video URL provided');
          return;
        }

        String? rawUrl = args['video_url'] as String?;
        _courseId = args['course_id'] as int?;

        if (rawUrl == null || rawUrl.isEmpty) {
          _setError('Invalid video URL');
          return;
        }

        if (_isGoogleDriveFolder(rawUrl)) {
          _setError('Cannot play Google Drive folders. Please provide a direct video file link.');
          return;
        }

        _videoUrl = _convertToPlayableUrl(rawUrl);
        print('Playing video from: $_videoUrl');
        _initializePlayer();
      } catch (e) {
        print('Error: $e');
        _setError('Error loading video: $e');
      }
    }
  }

  bool _isGoogleDriveFolder(String url) {
    return url.contains('drive.google.com/drive/folders/') ||
        url.contains('/folders/');
  }

  String _convertToPlayableUrl(String url) {
    url = url.trim();

    if (url.contains(':8000/') || url.contains('/uploads/')) {
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        return 'http://$url';
      }
      return url;
    }

    if (url.contains('drive.google.com/uc?') && url.contains('export=')) {
      return url;
    }

    if (url.contains('drive.google.com/file/d/')) {
      try {
        final fileId = url.split('/d/')[1].split('/')[0];
        return 'https://drive.google.com/uc?export=view&id=$fileId';
      } catch (e) {
        print('Error converting Google Drive URL: $e');
      }
    }

    if (url.contains('drive.google.com/open?id=')) {
      try {
        final fileId = url.split('id=')[1].split('&')[0];
        return 'https://drive.google.com/uc?export=view&id=$fileId';
      } catch (e) {
        print('Error converting Google Drive open URL: $e');
      }
    }

    return url;
  }

  void _initializePlayer() {
    try {
      _controller = VideoPlayerController.network(_videoUrl!);

      _initializeVideoPlayerFuture = _controller.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _controller.play();
        }
      }).catchError((error) {
        print('Error initializing: $error');
        if (mounted) {
          _setError('Failed to load video. Please check:\n'
              '• The URL points to a video file (not a folder)\n'
              '• The file has sharing enabled\n'
              '• The video format is supported (MP4, MOV, etc.)\n'
              '• Your internet connection is working');
        }
      });
    } catch (e) {
      print('Exception: $e');
      _setError('Player error: $e');
    }
  }

  void _setError(String message) {
    if (mounted) {
      setState(() {
        _hasError = true;
        _isLoading = false;
        _errorMessage = message;
      });
    }
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      _showControls = true;
    });

    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      final hours = twoDigits(duration.inHours);
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (_videoUrl != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullScreen) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: _buildFullScreenPlayer(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Watch Course',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildFullScreenPlayer() {
    if (_hasError || _isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const CircularProgressIndicator(color: Colors.lightBlue)
            else
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _toggleFullScreen,
              icon: const Icon(Icons.fullscreen_exit),
              label: const Text('Exit Fullscreen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          if (!_controller.value.isPlaying && _showControls)
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.play();
                  });
                },
                child: Container(
                  color: Colors.black54,
                  child: const Icon(
                    Icons.play_circle_fill,
                    size: 100,
                    color: Colors.lightBlue,
                  ),
                ),
              ),
            ),
          if (_showControls)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildFullScreenControls(),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Error Loading Video',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage ?? 'Unknown error occurred',
                style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.lightBlue),
            SizedBox(height: 16),
            Text(
              'Loading video...',
              style: TextStyle(color: Color(0xFFB0B0B0)),
            ),
          ],
        ),
      );
    }

    return FutureBuilder<void>(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.black,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      if (!_controller.value.isPlaying)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _controller.play();
                            });
                          },
                          child: Container(
                            color: Colors.black54,
                            child: const Icon(
                              Icons.play_circle_fill,
                              size: 80,
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                _buildSimpleControls(),
                if (_courseId != null)
                  CommentSection(courseId: _courseId!),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Video Format Not Supported',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Please ensure the video is in a supported format (MP4, MOV)',
                    style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.lightBlue),
          );
        }
      },
    );
  }

  Widget _buildSimpleControls() {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, VideoPlayerValue value, child) {
              return Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.lightBlue,
                      inactiveTrackColor: Colors.grey[700],
                      thumbColor: Colors.lightBlue,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
                      trackHeight: 3.0,
                    ),
                    child: Slider(
                      value: value.position.inSeconds.toDouble().clamp(
                        0.0,
                        value.duration.inSeconds.toDouble(),
                      ),
                      min: 0.0,
                      max: value.duration.inSeconds.toDouble() > 0
                          ? value.duration.inSeconds.toDouble()
                          : 1.0,
                      onChanged: (newValue) {
                        _controller.seekTo(Duration(seconds: newValue.toInt()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(value.position),
                          style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
                        ),
                        Text(
                          _formatDuration(value.duration),
                          style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10, color: Colors.lightBlue, size: 28),
                onPressed: () {
                  final newPosition = _controller.value.position - const Duration(seconds: 10);
                  _controller.seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
                },
              ),
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.lightBlue,
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward_10, color: Colors.lightBlue, size: 28),
                onPressed: () {
                  final newPosition = _controller.value.position + const Duration(seconds: 10);
                  final maxDuration = _controller.value.duration;
                  _controller.seekTo(newPosition < maxDuration ? newPosition : maxDuration);
                },
              ),
              IconButton(
                icon: const Icon(Icons.fullscreen, color: Colors.lightBlue, size: 28),
                onPressed: _toggleFullScreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFullScreenControls() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, VideoPlayerValue value, child) {
              return Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.lightBlue,
                      inactiveTrackColor: Colors.grey[700],
                      thumbColor: Colors.lightBlue,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
                      trackHeight: 4.0,
                    ),
                    child: Slider(
                      value: value.position.inSeconds.toDouble().clamp(
                        0.0,
                        value.duration.inSeconds.toDouble(),
                      ),
                      min: 0.0,
                      max: value.duration.inSeconds.toDouble() > 0
                          ? value.duration.inSeconds.toDouble()
                          : 1.0,
                      onChanged: (newValue) {
                        _controller.seekTo(Duration(seconds: newValue.toInt()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(value.position),
                          style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
                        ),
                        Text(
                          _formatDuration(value.duration),
                          style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10, color: Colors.lightBlue, size: 32),
                onPressed: () {
                  final newPosition = _controller.value.position - const Duration(seconds: 10);
                  _controller.seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
                },
              ),
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.lightBlue,
                  size: 48,
                ),
                onPressed: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward_10, color: Colors.lightBlue, size: 32),
                onPressed: () {
                  final newPosition = _controller.value.position + const Duration(seconds: 10);
                  final maxDuration = _controller.value.duration;
                  _controller.seekTo(newPosition < maxDuration ? newPosition : maxDuration);
                },
              ),
              IconButton(
                icon: const Icon(Icons.fullscreen_exit, color: Colors.lightBlue, size: 32),
                onPressed: _toggleFullScreen,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
