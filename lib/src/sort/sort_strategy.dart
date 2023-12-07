abstract class SortStrategy {
  SortStrategy({
    required this.comment,
    required this.regExp,
  });

  final String comment;
  final RegExp regExp;
  final List<String> _list = [];

  List<String> getList() => _list..sort();

  void clearList() => _list.clear();

  bool tryAdd(String string) {
    if (regExp.hasMatch(string.trim())) {
      _list.add(string);
      return true;
    }
    return false;
  }
}
