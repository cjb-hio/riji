import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riji_flutter/core/api/api_client.dart';
import 'package:riji_flutter/core/api/api_exception.dart';
import 'package:riji_flutter/data/models/diary.dart';
import 'package:riji_flutter/data/repositories/diary_repository.dart';
import 'package:riji_flutter/presentation/widgets/mood_selector.dart';

class DiaryEditorScreen extends StatefulWidget {
  final Diary? diary;

  const DiaryEditorScreen({super.key, this.diary});

  @override
  State<DiaryEditorScreen> createState() => _DiaryEditorScreenState();
}

class _DiaryEditorScreenState extends State<DiaryEditorScreen> {
  final DiaryRepository _diaryRepository = DiaryRepository(Get.find<ApiClient>());

  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String _selectedMood = 'calm';
  bool _isLoading = false;
  bool _isSaving = false;

  bool get _isEditing => widget.diary != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.diary?.title ?? '');
    _contentController = TextEditingController(text: widget.diary?.content ?? '');
    _selectedMood = widget.diary?.mood ?? 'calm';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) {
      Get.snackbar('提示', '请输入标题', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (_contentController.text.trim().isEmpty) {
      Get.snackbar('提示', '请输入内容', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final diary = DiaryRequest(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        mood: _selectedMood,
      );

      if (_isEditing) {
        await _diaryRepository.updateDiary(widget.diary!.serverId, diary);
      } else {
        await _diaryRepository.createDiary(diary);
      }

      Get.back(result: true);
      Get.snackbar('成功', _isEditing ? '日记已更新' : '日记已保存', snackPosition: SnackPosition.BOTTOM);
    } on ApiException catch (e) {
      Get.snackbar('错误', e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('错误', '保存失败，请稍后重试', snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _delete() async {
    if (!_isEditing) return;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这篇日记吗？'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('取消')),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      await _diaryRepository.deleteDiary(widget.diary!.serverId);
      Get.back(result: true);
      Get.snackbar('成功', '日记已删除', snackPosition: SnackPosition.BOTTOM);
    } on ApiException catch (e) {
      Get.snackbar('错误', e.message, snackPosition: SnackPosition.BOTTOM);
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑日记' : '新建日记'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _delete,
            ),
          IconButton(
            icon: _isSaving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check),
            onPressed: _isSaving ? null : _save,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: '标题',
                      hintText: '今天发生了什么...',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  const Text('心情', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  MoodSelector(
                    selectedMood: _selectedMood,
                    onMoodSelected: (mood) => setState(() => _selectedMood = mood),
                  ),
                  const SizedBox(height: 24),
                  const Text('内容', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      hintText: '写下你的想法...',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 15,
                    minLines: 10,
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ],
              ),
            ),
    );
  }
}
