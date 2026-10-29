import 'package:evently_c20_online/core/models/event_model.dart';
import 'package:evently_c20_online/l10n/app_localizations.dart';
import 'package:evently_c20_online/modules/add_event/manager/event_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constante/app_category.dart';
import '../../layout/widgets/tab_widget.dart';

class AddEventScreen extends StatelessWidget {
  static const String routeName = "AddEventScreen";
  const AddEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var local = AppLocalizations.of(context)!;
    EventModel? event = ModalRoute.of(context)!.settings.arguments as EventModel?;
    bool isEdit = event != null;

    return ChangeNotifierProvider(
      create: (context) => EventProvider(event: event),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? local.editEvent : "Add Event"),
          centerTitle: true,
        ),
        body: Consumer<EventProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              // الكيبورد يقفل لما اليوزر يسكرول
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      provider.selectedCategory.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DefaultTabController(
                    initialIndex: provider.index,
                    length: AppCategory.categories.length,
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicator: const BoxDecoration(color: Colors.transparent),
                      isScrollable: true,
                      onTap: (value) {
                        provider.changeIndex(value);
                      },
                      tabAlignment: TabAlignment.start,
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsetsDirectional.only(end: 8),
                      labelColor: Colors.white,
                      unselectedLabelColor: theme.primaryColorLight,
                      tabs: AppCategory.categories.map((e) {
                        int categoryIndex = AppCategory.categories.indexOf(e);
                        return TabWidget(
                          category: e,
                          isSelected: provider.index == categoryIndex,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text("Title", style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: provider.titleController,
                    decoration: const InputDecoration(hintText: "Event Title"),
                  ),
                  const SizedBox(height: 16),
                  Text("Desc", style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 140,
                    child: TextFormField(
                      controller: provider.descController,
                      expands: true,
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(hintText: "Event Desc"),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.date_range, color: theme.primaryColor),
                      const SizedBox(width: 8),
                      Text("Event Date", style: theme.textTheme.titleLarge),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: provider.selectedDateTime,
                            firstDate: provider.selectedDateTime != null &&
                                provider.selectedDateTime!.isBefore(DateTime.now())
                                ? provider.selectedDateTime!
                                : DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          ).then((value) {
                            if (value != null) {
                              provider.changeDate(value);
                            }
                          });
                        },
                        child: Text(
                          provider.selectedDateTime == null
                              ? "Choose Date"
                              : DateFormat.yMd().format(provider.selectedDateTime!),
                          style: theme.textTheme.titleMedium!.copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.timelapse_outlined, color: theme.primaryColor),
                      const SizedBox(width: 8),
                      Text("Event Time", style: theme.textTheme.titleLarge),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: provider.selectedTime ?? TimeOfDay.now(),
                          ).then((value) {
                            if (value != null) {
                              provider.changeTime(value);
                            }
                          });
                        },
                        child: Text(
                          provider.selectedTime?.format(context) ??
                              provider.oldTime ??
                              "Choose Time",
                          style: theme.textTheme.titleMedium!.copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () {
                        isEdit
                            ? provider.updateEvent(context)
                            : provider.addEvent(context);
                      },
                      child: provider.isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(),
                      )
                          : Text(isEdit ? local.updateEvent : "Add Event"),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}