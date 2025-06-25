import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:edu_sync/models/lesson_comment_model.dart';
import 'package:edu_sync/services/lesson_comment_services.dart';
import 'package:edu_sync/services/teacher_cache.dart';

class LessonCommentsScreen extends StatefulWidget {
  const LessonCommentsScreen({super.key});

  @override
  State<LessonCommentsScreen> createState() => _LessonCommentsScreenState();
}

class _LessonCommentsScreenState extends State<LessonCommentsScreen> {
  List<LessonCommentModel> _comments = [];
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = true;

  late final int lessonId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      lessonId = GoRouterState.of(context).extra as int;
      _loadComments();
    });
  }

  Future<void> _loadComments() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final loadedComments = await LessonCommentService.getCommentsByLessonId(
      lessonId,
    );

    if (!mounted) return;
    setState(() {
      _comments = loadedComments;
      _isLoading = false;
    });
  }

  Future<void> _sendComment() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final newComment = LessonCommentModel(
      lessonId: lessonId,
      senderTeacherId: TeacherCache.currentTeacher?.id,
      senderStudentId: null,
      message: text,
      timestamp: DateTime.now(),
    );

    final success = await LessonCommentService.addComment(newComment);

    if (!mounted) return;

    if (success) {
      _messageController.clear();
      await _loadComments(); // обновим список
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при отправке комментария ❌')),
      );
    }
  }

  Widget _buildCommentBubble(LessonCommentModel comment) {
    final isMe = comment.senderTeacherId == TeacherCache.currentTeacher?.id;
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = isMe ? Colors.blue.shade100 : Colors.grey.shade200;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: align,
          children: [
            Text(comment.message),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(comment.timestamp),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final time = TimeOfDay.fromDateTime(timestamp);
    final formatted =
        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Комментарии к занятию')),
      body: Column(
        children: [
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      reverse: true,
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        final comment = _comments[_comments.length - index - 1];
                        return _buildCommentBubble(comment);
                      },
                    ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Введите сообщение...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
