import 'package:whoiswhogame/helper/Person.dart';

class GroupData {
  final List list;

  GroupData({this.list});

  factory GroupData.fromJSON(Map<String, dynamic> json) {
    List list = List();
    var p;
    for (p in json['persons']) {
      Person person = Person(
        name: p['name'],
        imagePath: p['imagePath'],
        classe: p['class'],
      );
      print(person);
      list.add(person);
    }
    return GroupData(list: list);
  }
}
