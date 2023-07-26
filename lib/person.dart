import 'package:hive/hive.dart';

part 'person.g.dart';

//score
@HiveType(typeId: 1)
class Person {
  Person({
    required this.score,
   
  });


  @HiveField(0)
  int score;
}
