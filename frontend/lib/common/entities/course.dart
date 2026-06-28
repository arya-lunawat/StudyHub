import 'package:cloud_firestore/cloud_firestore.dart';

class CourseRequestEntity {
  int? id;

  CourseRequestEntity({
    this.id,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}

class SearchRequestEntity {
  String? search;

  SearchRequestEntity({
    this.search,
  });

  Map<String, dynamic> toJson() => {
    "search": search,
  };
}

class CourseListResponseEntity {
  int? code;
  String? msg;
  List<CourseItem>? data;

  CourseListResponseEntity({
    this.code,
    this.msg,
    this.data,
  });

  factory CourseListResponseEntity.fromJson(Map<String, dynamic> json) =>
      CourseListResponseEntity(
        code: json["code"],
        msg: json["msg"],
        data: json["data"] == null ? [] : List<CourseItem>.from(json["data"].map((x) => CourseItem.fromJson(x))),
      );
}

class CourseDetailResponseEntity {
  int? code;
  String? msg;
  CourseItem? data;

  CourseDetailResponseEntity({
    this.code,
    this.msg,
    this.data,
  });

  factory CourseDetailResponseEntity.fromJson(Map<String, dynamic> json) =>
      CourseDetailResponseEntity(
        code: json["code"],
        msg: json["msg"],
        data: CourseItem.fromJson(json["data"]),
      );
}

class AuthorRequestEntity {
  String? token;

  AuthorRequestEntity({
    this.token,
  });

  Map<String, dynamic> toJson() => {
    "token": token,
  };
}

class AuthorResponseEntity {
  int? code;
  String? msg;
  AuthorItem? data;

  AuthorResponseEntity({
    this.code,
    this.msg,
    this.data,
  });

  factory AuthorResponseEntity.fromJson(Map<String, dynamic> json) =>
      AuthorResponseEntity(
        code: json["code"],
        msg: json["msg"],
        data: AuthorItem.fromJson(json["data"]),
      );
}

class AuthorItem {
  String? token;
  String? name;
  String? description;
  String? avatar;
  String? job;
  String? video_url;
  int? download;
  int? online;

  AuthorItem({
    this.token,
    this.name,
    this.description,
    this.avatar,
    this.job,
    this.video_url,
    this.download,
    this.online,
  });

  factory AuthorItem.fromJson(Map<String, dynamic> json) =>
      AuthorItem(
        token: json["token"],
        name: json["name"],
        description: json["description"],
        avatar: json["avatar"],
        job: json["job"],
        video_url: json["video_url"],
        download: json["download"],
        online: json["online"],
      );

  Map<String, dynamic> toJson() => {
    "token": token,
    "name": name,
    "description": description,
    "avatar": avatar,
    "job": job,
    "video_url": video_url,
    "download": download,
    "online": online,
  };
}

class CourseType {
  int? id;
  String? title;
  int? parent_id;
  String? description;
  int? order;

  CourseType({
    this.id,
    this.title,
    this.parent_id,
    this.description,
    this.order,
  });

  factory CourseType.fromJson(Map<String, dynamic> json) =>
      CourseType(
        id: json["id"],
        title: json["title"],
        parent_id: json["parent_id"],
        description: json["description"],
        order: json["order"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "parent_id": parent_id,
    "description": description,
    "order": order,
  };
}

class CourseItem {
  String? user_token;
  String? name;
  String? description;
  String? thumbnail;
  String? video;
  String? video_url;
  String? down_res;  // Add this line
  String? price;
  String? amount_total;
  int? lesson_num;
  int? video_len;
  int? id;
  int? type_id;
  CourseType? courseType;

  CourseItem({
    this.user_token,
    this.name,
    this.description,
    this.thumbnail,
    this.video,
    this.video_url,
    this.down_res,  // Add this line
    this.price,
    this.amount_total,
    this.lesson_num,
    this.video_len,
    this.id,
    this.type_id,
    this.courseType,
  });

  factory CourseItem.fromJson(Map<String, dynamic> json) =>
      CourseItem(
        user_token: json["user_token"],
        name: json["name"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        video: json["video"],
        video_url: json["video_url"],
        down_res: json["down_res"],  // Add this line
        price: json["price"].toString(),
        amount_total: json["amount_total"],
        lesson_num: json["lesson_num"],
        video_len: json["video_length"],
        id: json["id"],
        type_id: json["type_id"] != null
            ? int.tryParse(json["type_id"].toString())
            : null,
        courseType: json["course_type"] != null
            ? CourseType.fromJson(json["course_type"])
            : null,
      );

  Map<String, dynamic> toJson() => {
    "user_token": user_token,
    "name": name,
    "description": description,
    "thumbnail": thumbnail,
    "video": video,
    "video_url": video_url,
    "down_res": down_res,  // Add this line
    "price": price,
    "amount_total": amount_total,
    "lesson_num": lesson_num,
    "video_len": video_len,
    "id": id,
    "type_id": type_id,
    "courseType": courseType?.toJson(),
  };
}
