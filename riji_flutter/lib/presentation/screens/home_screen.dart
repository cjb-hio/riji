import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riji_flutter/core/api/api_client.dart';
import 'package:riji_flutter/core/api/api_exception.dart';
import 'package:riji_flutter/data/models/diary.dart';
import 'package:riji_flutter/data/repositories/auth_repository.dart';
import 'package:riji_flutter/data/repositories/diary_repository.dart';
import 'package:riji_flutter/presentation/screens/auth_screen.dart';
import 'package:riji_flutter/presentation/screens/diary_editor_screen.dart';
import 'package:riji_flutter/presentation/widgets/diary_card.dart';
import 'package:riji_flutter/presentation/widgets/loading_widget.dart';
import 'package:riji_flutter/presentation/widgets/mood_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DiaryRepository _diaryRepository = DiaryRepository(Get.find<ApiClient>());

  List<Diary> _diaries = [];
  bool _isLoading = true;
  bool _hasMore = true;
  int _page = 0;
  final int _pageSize = 20;

  String? _selectedMood;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadDiaries();
  }

  Future<void> _loadDiaries({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _page = 0;
        _diaries = [];
        _hasMore = true;
        _isLoading = true;
      });
    }

    if (!_hasMore && !refresh) return;

    try {
      final response = await _diaryRepository.getDiaries(
        page: _page,
        size: _pageSize,
        startDate: _startDate?.toIso8601String().split('T')[0],
        endDate: _endDate?.toIso8601String().split('T')[0],
        mood: _selectedMood,
      );

      setState(() {
        if (refresh) {
          _diaries = response.content;
        } else {
          _diaries.addAll(response.content);
        }
        _hasMore = response.page < response.totalPages - 1;
        _page++;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      Get.snackbar('错误', e.message, snackPosition: SnackPosition.BOTTOM);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refresh() async {
    await _loadDiaries(refresh: true);
  }

  void _openEditor({Diary? diary}) {
    Get.to(() => DiaryEditorScreen(diary: diary))?.then((_) => _refresh());
  }

  Future<void> _logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('取消')),
          TextButton(onPressed: () => Get.back(result: true), child: const Text('确定')),
        ],
      ),
    );

    if (confirmed == true) {
      final apiClient = Get.find<ApiClient>();
      final authRepository = AuthRepository(apiClient);
      await authRepository.logout();
      Get.offAll(() => const AuthScreen());
    }
  }

  void _showFilterSheet() {
    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('筛选', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('心情'),
                const SizedBox(height: 8),
                MoodSelector(
                  selectedMood: _selectedMood ?? '',
                  onMoodSelected: (mood) {
                    setSheetState(() {
                      _selectedMood = _selectedMood == mood ? null : mood;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _startDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setSheetState(() => _startDate = date);
                          }
                        },
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text(_startDate?.toIso8601String().split('T')[0] ?? '开始日期'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _endDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setSheetState(() => _endDate = date);
                          }
                        },
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text(_endDate?.toIso8601String().split('T')[0] ?? '结束日期'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setSheetState(() {
                            _selectedMood = null;
                            _startDate = null;
                            _endDate = null;
                          });
                        },
                        child: const Text('重置'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          _loadDiaries(refresh: true);
                        },
                        child: const Text('应用'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的日记'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading && _diaries.isEmpty
          ? const LoadingWidget(message: '加载中...')
          : RefreshIndicator(
              onRefresh: _refresh,
              child: _diaries.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.book_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text('暂无日记', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                          const SizedBox(height: 8),
                          Text('点击右下角按钮创建', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                        ],
                      ),
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                          _loadDiaries();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 80),
                        itemCount: _diaries.length + (_hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _diaries.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final diary = _diaries[index];
                          return DiaryCard(
                            diary: diary,
                            onTap: () => _openEditor(diary: diary),
                          );
                        },
                      ),
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
