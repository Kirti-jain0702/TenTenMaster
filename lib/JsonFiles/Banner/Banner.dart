class BannerData {
  List<Data> data;
  //Links links;

  BannerData({this.data/*, this.links*/});

  BannerData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) { data.add( Data.fromJson(v)); });
    }
   // links = json['links'] != null ?  Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
   /* if (this.links != null) {
      data['links'] = this.links.toJson();
    }*/
    return data;
  }
}

class Data {
  int id;
  Meta meta;
  int sortOrder;
  Mediaurls mediaurls;

  Data({this.id, this.meta, this.sortOrder, this.mediaurls});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meta = json['meta'] != null ?  Meta.fromJson(json['meta']) : null;
    sortOrder = json['sort_order'];
    mediaurls = json['mediaurls'] != null ?  Mediaurls.fromJson(json['mediaurls']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    data['sort_order'] = this.sortOrder;
    if (this.mediaurls != null) {
      data['mediaurls'] = this.mediaurls.toJson();
    }
    return data;
  }
}

class Meta {
  String callBack;
  String type;

  Meta({this.callBack,this.type});

  Meta.fromJson(Map<String, dynamic> json) {
    callBack = json['callBack'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['callBack'] = this.callBack;
    data['type'] = this.type;
    return data;
  }
}

class Mediaurls {
  List<Images> images;

  Mediaurls({this.images});

  Mediaurls.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      images =  [];
      json['images'].forEach((v) { images.add( Images.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String def;
  String thumb;

  Images({this.def, this.thumb});

  Images.fromJson(Map<String, dynamic> json) {
    def = json['default'];
    thumb = json['thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['default'] = this.def;
    data['thumb'] = this.thumb;
    return data;
  }
}

/*class Links {
  String first;
  String last;
  Null prev;
  Null next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}*/
