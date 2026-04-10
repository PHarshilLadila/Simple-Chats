abstract class ShowNotificationState {}

class ShowNotificationInitial extends ShowNotificationState {}

class ShowNotificationLoading extends ShowNotificationState {}

class ShowNotificationLoaded extends ShowNotificationState {
  final List<Map<String, dynamic>> notifications;
  ShowNotificationLoaded(this.notifications);
}

class ShowNotificationError extends ShowNotificationState {
  final String message;
  ShowNotificationError(this.message);
}
