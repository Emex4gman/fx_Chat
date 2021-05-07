// class User {
//   String userId;
//   // String name;
//   // String imageUrl;
//   User({this.userId});
// }

class Category {
  String name;
  List<Content> contents;
  Category.formJson(Map json) {
    List _list = <Content>[];
    json['contents'].forEach((item) {
      _list.add(Content.fromJson(item));
    });
    this.name = json["name"];
    this.contents = _list;
  }
}

class Content {
  String name;
  int price;
  Content.fromJson(Map json) {
    this.name = json['name'];
    this.price = json['price'];
  }
}
