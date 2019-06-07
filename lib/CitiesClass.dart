

class CitiesList {
  final List<Cities> city;

  CitiesList({
    this.city,
  });

  factory CitiesList.fromJson(List<dynamic> parsedJson) {

    List<Cities> cityList = new List<Cities>();
    cityList = parsedJson.map((i)=>Cities.fromJson(i)).toList();

    return new CitiesList(
        city: cityList
    );
  }
}

class Cities{
  final String city;
  final String localName;

  Cities({
    this.city,
    this.localName,
  }) ;

  factory Cities.fromJson(Map<String, dynamic> json){
    return new Cities(
      city: json['CITY'].toString(),
      localName: json['LOCALNAME'],
    );
  }
}

