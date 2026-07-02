class TripOverView {
  double? successRate;
  int? totalTrips;
  double? totalEarn;
  int? totalCancel;
  int? totalReviews;
  IncomeStat? incomeStat;

  TripOverView(
      {this.successRate,
        this.totalTrips,
        this.totalEarn,
        this.totalCancel,
        this.totalReviews,
        this.incomeStat});

  TripOverView.fromJson(Map<String, dynamic> json) {
    successRate = json['success_rate'].toDouble();
    totalTrips = json['total_trips'] != null ? int.tryParse(json['total_trips'].toString()) : null;
    totalEarn = json['total_earn'].toDouble();
    totalCancel = json['total_cancel'] != null ? int.tryParse(json['total_cancel'].toString()) : null;
    totalReviews = json['total_reviews'] != null ? int.tryParse(json['total_reviews'].toString()) : null;
    incomeStat = json['income_stat'] != null
        ? IncomeStat.fromJson(json['income_stat'])
        : null;
  }
}

class IncomeStat {
  double? sun;
  double? mon;
  double? tues;
  double? wed;
  double? thu;
  double? fri;
  double? sat;
  double? sixAm;
  double? temAM;
  double? twoPm;
  double? sixPm;
  double? temPm;
  double? twoAm;


  IncomeStat(
      {this.sun, this.mon, this.tues, this.wed, this.thu, this.fri, this.sat,this.sixAm,this.sixPm,this.temAM,this.temPm,this.twoAm,this.twoPm});

  IncomeStat.fromJson(Map<String, dynamic> json) {
    sun = double.tryParse(json['Sun'].toString());
    mon = double.tryParse(json['Mon'].toString());
    tues = double.tryParse(json['Tues'].toString());
    wed = double.tryParse(json['Wed'].toString());
    thu = double.tryParse(json['Thu'].toString());
    fri = double.tryParse(json['Fri'].toString());
    sat = double.tryParse(json['Sat'].toString());
    sixAm = double.tryParse(json['6:00 am'].toString());
    temAM = double.tryParse(json['10:00 am'].toString());
    twoPm = double.tryParse(json['2:00 pm'].toString());
    sixPm = double.tryParse(json['6:00 pm'].toString());
    temPm = double.tryParse(json['10:00 pm'].toString());
    twoAm = double.tryParse(json['2:00 am'].toString());
  }
}
