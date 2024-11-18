import 'package:flutter/material.dart';
import '../../viewmodels/notification_view_model.dart';

class ReminderDoctorPage extends StatefulWidget {
  @override
  _ReminderDoctorPageState createState() => _ReminderDoctorPageState();
}

class _ReminderDoctorPageState extends State<ReminderDoctorPage> {
  final NotificationsViewModel _viewModel = NotificationsViewModel();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _viewModel.loadData();
    final upcomingNotifications = _viewModel.getUpcomingNotifications();
    for (final notification in upcomingNotifications) {
      await _viewModel.schedulePushNotification(notification);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _viewModel.notifications.isEmpty
          ? Center(
              child: Text(
                'No upcoming reminders.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _viewModel.notifications.length,
              itemBuilder: (context, index) {
                final notification = _viewModel.notifications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      notification.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(notification.message),
                    trailing: Text(
                      '${notification.dateTime.hour}:${notification.dateTime.minute} on ${notification.dateTime.month}/${notification.dateTime.day}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}