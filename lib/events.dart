class Events {
  final String name;
  final DateTime time;
  final int index;
  final String delay;
  final String body;
  final String imageUrl;

  Events(this.name, this.time, this.index, this.delay, this.body, this.imageUrl);

}

class User {
  String email;
  String profilePic;
  String name;

  User(this.email, this.profilePic, this.name);
}