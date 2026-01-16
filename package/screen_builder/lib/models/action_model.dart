/// Model for an action
class ActionModel {
  final String type;
  final Map<String, dynamic> params;

  ActionModel({required this.type, this.params = const {}});
}
