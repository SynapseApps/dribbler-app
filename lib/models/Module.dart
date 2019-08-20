class Module {
  List<Results> results;

  Module({this.results});

  Module.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int id;
  String url;
  int perSubject;
  int number;

  Results({this.id, this.url, this.perSubject, this.number});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    perSubject = json['per_subject'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['per_subject'] = this.perSubject;
    data['number'] = this.number;
    return data;
  }
}
