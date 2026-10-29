import 'package:evently_c20_online/core/constante/app_category.dart';
import 'package:evently_c20_online/core/models/event_model.dart';
import 'package:evently_c20_online/core/services/db_service.dart';
import 'package:evently_c20_online/core/toast_service/toast.dart';
import 'package:evently_c20_online/l10n/app_localizations.dart';
import 'package:evently_c20_online/modules/add_event/screens/add_event_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends StatelessWidget {
  static const String routeName = "eventDetailsScreen";
  const EventDetailsScreen({super.key});

  Future<void> confirmDelete(BuildContext context, EventModel event) async {
    var local = AppLocalizations.of(context)!;
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(local.deleteEventTitle),
        content: Text(local.deleteEventMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(local.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(local.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await DbService.deleteEvent(event.id);
      if (!context.mounted) return;
      Toast.show(title: local.eventDeleted, context: context);
      Navigator.pop(context); // يرجع للـ Home
    } catch (e) {
      if (!context.mounted) return;
      Toast.show(title: e.toString(), context: context, type: ToastType.error);
    }
  }

  BoxDecoration boxDecoration(ThemeData theme) => BoxDecoration(
    color: theme.cardColor,
    border: Border.all(color: theme.dividerColor),
    borderRadius: BorderRadius.circular(16),
  );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var local = AppLocalizations.of(context)!;
    var initialEvent = ModalRoute.of(context)!.settings.arguments as EventModel;

    return StreamBuilder<EventModel?>(
      stream: DbService.getEventStream(initialEvent.id),
      builder: (context, snapshot) {
        EventModel event = snapshot.data ?? initialEvent;
        var category = AppCategory.categories.firstWhere(
              (c) => c.id == event.categoryId,
          orElse: () => AppCategory.categories.first,
        );
        bool isOwner = event.userId == FirebaseAuth.instance.currentUser?.uid;
        DateTime? date = DateTime.tryParse(event.date);
        String langCode = Localizations.localeOf(context).languageCode;

        return Scaffold(
          appBar: AppBar(
            title: Text(local.eventDetails),
            centerTitle: true,
            actions: [
              if (isOwner) ...[
                IconButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AddEventScreen.routeName,
                    arguments: event,
                  ),
                  icon: Icon(Icons.edit_outlined, color: theme.primaryColor),
                ),
                IconButton(
                  onPressed: () => confirmDelete(context, event),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    category.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(event.title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: boxDecoration(theme),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.calendar_month_outlined,
                            color: theme.primaryColor),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            date == null
                                ? event.date
                                : DateFormat("d MMMM yyyy", langCode).format(date),
                            style: theme.textTheme.titleMedium!
                                .copyWith(color: theme.primaryColor),
                          ),
                          const SizedBox(height: 4),
                          Text(event.time, style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(local.description, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: boxDecoration(theme),
                  child: Text(event.desc, style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}