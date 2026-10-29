import 'package:evently_c20_online/core/constante/app_category.dart';
import 'package:evently_c20_online/core/models/event_model.dart';
import 'package:evently_c20_online/core/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:evently_c20_online/core/toast_service/toast.dart';
import 'package:evently_c20_online/l10n/app_localizations.dart';
class EventProvider extends ChangeNotifier {
  int index = 0;

  AppCategory selectedCategory = AppCategory.categories.first;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  DateTime? selectedDateTime;

  TimeOfDay? selectedTime;

  void changeIndex(int value) {
    index = value;
    selectedCategory = AppCategory.categories[index];
    notifyListeners();
  }

  void changeDate(DateTime date) {
    selectedDateTime = date;
    notifyListeners();
  }

  void changeTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  bool isLoading = false;
  EventModel? editingEvent;
  String? oldTime;
  bool get isEdit => editingEvent != null;

  // لو اتبعت event يبقى إحنا في وضع التعديل، فنملا كل الحقول بالداتا القديمة
  EventProvider({EventModel? event}) {
    if (event == null) return;
    editingEvent = event;
    titleController.text = event.title;
    descController.text = event.desc;
    selectedDateTime = DateTime.tryParse(event.date);
    oldTime = event.time;
    int categoryIndex =
    AppCategory.categories.indexWhere((c) => c.id == event.categoryId);
    if (categoryIndex != -1) {
      index = categoryIndex;
      selectedCategory = AppCategory.categories[categoryIndex];
    }
  }

  Future<void> updateEvent(BuildContext context) async {
    var local = AppLocalizations.of(context)!;
    if (titleController.text.trim().isEmpty) {
      Toast.show(title: "Enter title", context: context, type: ToastType.error);
      return;
    }
    isLoading = true;
    notifyListeners();

    var updated = EventModel(
      id: editingEvent!.id,
      userId: editingEvent!.userId,
      usersFav: editingEvent!.usersFav,
      categoryId: selectedCategory.id,
      date: selectedDateTime.toString(),
      desc: descController.text,
      time: selectedTime?.format(context) ?? oldTime ?? "",
      title: titleController.text,
    );

    bool success = false;
    try {
      await DbService.updateEvent(updated);
      success = true;
    } catch (e) {
      Toast.show(title: e.toString(), context: context, type: ToastType.error);
    }
    isLoading = false;
    notifyListeners();

    if (success && context.mounted) {
      Toast.show(title: local.eventUpdated, context: context);
      Navigator.pop(context);
    }
  }
  void addEvent(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    await DbService.addEvent(
      EventModel(
        id: "",
        categoryId: selectedCategory.id,
        date: selectedDateTime.toString(),
        desc: descController.text,
        time: selectedTime!.format(context),
        title: titleController.text,
      ),
    );
    isLoading = false;
    notifyListeners();
    Navigator.pop(context);
  }
}
