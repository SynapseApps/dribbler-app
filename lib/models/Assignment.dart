class Assignment {
  List<Results> results;

  Assignment({this.results});

  Assignment.fromJson(Map<String, dynamic> json) {
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
  SubjectAssignment subjectAssignment;
  String description;
  String link;
  String uploadedOn;

  Results(
      {this.id,
      this.url,
      this.subjectAssignment,
      this.description,
      this.link,
      this.uploadedOn});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    subjectAssignment = json['subject_assignment'] != null
        ? new SubjectAssignment.fromJson(json['subject_assignment'])
        : null;
    description = json['description'];
    link = json['link'];
    uploadedOn = json['uploaded_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    if (this.subjectAssignment != null) {
      data['subject_assignment'] = this.subjectAssignment.toJson();
    }
    data['description'] = this.description;
    data['link'] = this.link;
    data['uploaded_on'] = this.uploadedOn;
    return data;
  }
}

class SubjectAssignment {
  int id;
  int number;
  PerSubject perSubject;

  SubjectAssignment({this.id, this.number, this.perSubject});

  SubjectAssignment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    perSubject = json['per_subject'] != null
        ? new PerSubject.fromJson(json['per_subject'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    if (this.perSubject != null) {
      data['per_subject'] = this.perSubject.toJson();
    }
    return data;
  }
}

class PerSubject {
  int id;
  String name;

  PerSubject({this.id, this.name});

  PerSubject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
