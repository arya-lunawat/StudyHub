import 'package:flutter/material.dart';
import '../../../common/apis/comment_api.dart';
import '../../../common/apis/doubt_reply_api.dart';

class CommentSection extends StatefulWidget {
  final int courseId;

  const CommentSection({Key? key, required this.courseId}) : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _doubtController = TextEditingController();
  final Map<int, TextEditingController> _replyControllers = {};
  List<dynamic> comments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    final data = await CommentApi.getComments(widget.courseId);
    if (mounted) {
      setState(() {
        comments = data;
        isLoading = false;
      });
    }
  }

  bool _isTeacher(dynamic value) {
    return value == 1 || value == true;
  }

  void _postDoubt() async {
    if (_doubtController.text.isEmpty) {
      print('❌ Doubt is empty!');
      return;
    }

    print('🚀 Sending doubt...');
    bool success = await CommentApi.postComment(widget.courseId, _doubtController.text);

    if (success) {
      print('✅ Doubt posted successfully!');
      _doubtController.clear();
      await _loadComments();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Doubt posted! ✅'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      print('❌ Failed to post doubt');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to post doubt ❌'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _postReply(int doubtId) async {
    print('🔘 _postReply called for doubt ID: $doubtId');

    TextEditingController? replyController = _replyControllers[doubtId];

    if (replyController == null) {
      print('❌ Reply controller is NULL!');
      return;
    }

    if (replyController.text.isEmpty) {
      print('❌ Reply is empty!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please type a reply'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    print('🚀 Sending reply...');
    print('💬 Reply text: "${replyController.text}"');

    bool success = await DoubtReplyApi.postReply(
      doubtId: doubtId,
      replyText: replyController.text,
      userToken: 'f3acf792d4b2dbf255d9bf572076e285',
      userName: 'Anonymous',  // ✅ CHANGED FROM EMPTY STRING
      isTeacher: false,
    );

    if (success) {
      print('✅ Reply posted successfully!');
      replyController.clear();
      await _loadComments();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reply posted! ✅'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      print('❌ Failed to post reply');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to post reply ❌'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _doubtController.dispose();
    for (var controller in _replyControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Doubts & Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        // Doubt Input
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _doubtController,
            style: TextStyle(color: Colors.white),
            maxLines: 3,
            minLines: 1,
            decoration: InputDecoration(
              hintText: 'Ask your doubt...',
              hintStyle: TextStyle(color: Color(0xFFB0B0B0)),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.lightBlue),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.lightBlue),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.lightBlue, width: 2),
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.send, color: Colors.lightBlue),
                onPressed: _postDoubt,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        // Doubts List
        isLoading
            ? Center(
          child: CircularProgressIndicator(color: Colors.lightBlue),
        )
            : comments.isEmpty
            ? Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'No doubts yet. Be the first to ask!',
            style: TextStyle(color: Color(0xFFB0B0B0)),
          ),
        )
            : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            var doubt = comments[index];
            int doubtId = doubt['id'];

            if (!_replyControllers.containsKey(doubtId)) {
              _replyControllers[doubtId] = TextEditingController();
            }

            return Card(
              color: Colors.grey[900],
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doubt text
                    Text(
                      doubt['doubt_text'] ?? '',
                      style: TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Created at
                    Text(
                      doubt['created_at'] ?? '',
                      style: TextStyle(
                        color: Color(0xFF808080),
                        fontSize: 11,
                      ),
                    ),
                    SizedBox(height: 12),
                    Divider(color: Colors.grey[700]),
                    // Replies section
                    if (doubt['replies'] != null && doubt['replies'].isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Replies:',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            ...List.generate(doubt['replies'].length, (i) {
                              var reply = doubt['replies'][i];
                              bool isTeacher = _isTeacher(reply['is_teacher']);

                              return Padding(
                                padding: EdgeInsets.only(bottom: 8, left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ONLY show Teacher badge - NO username
                                    if (isTeacher)
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Teacher Approved',
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: 4),
                                    Text(
                                      reply['reply_text'],
                                      style: TextStyle(
                                        color: Color(0xFFB0B0B0),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            SizedBox(height: 8),
                            Divider(color: Colors.grey[700]),
                          ],
                        ),
                      ),
                    // Reply input
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _replyControllers[doubtId],
                              style: TextStyle(color: Colors.white, fontSize: 12),
                              maxLines: 2,
                              minLines: 1,
                              decoration: InputDecoration(
                                hintText: 'Add a reply...',
                                hintStyle: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.lightBlue, width: 0.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.lightBlue, width: 0.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              print('🔘 Reply button tapped for doubt ID: $doubtId');
                              _postReply(doubtId);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(Icons.send, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
