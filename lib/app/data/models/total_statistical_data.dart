import 'dart:convert';

class TotalStatisticalData {
  int? collectedGarbagePile;
  int? collectedGarbagePcs;
  int? notCollectedGarbagePile;
  int? notCollectedGarbagePcs;
  List<HistoricalData>? historicalData;

  TotalStatisticalData({
    this.collectedGarbagePile,
    this.collectedGarbagePcs,
    this.notCollectedGarbagePile,
    this.notCollectedGarbagePcs,
    this.historicalData,
  });

  factory TotalStatisticalData.fromRawJson(String str) =>
      TotalStatisticalData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TotalStatisticalData.fromJson(Map<String, dynamic> json) =>
      TotalStatisticalData(
        collectedGarbagePile: json["collected_garbage_pile"],
        collectedGarbagePcs: json["collected_garbage_pcs"],
        notCollectedGarbagePile: json["not_collected_garbage_pile"],
        notCollectedGarbagePcs: json["not_collected_garbage_pcs"],
        historicalData: json["all_historical_data"] == null
            ? []
            : List<HistoricalData>.from(json["all_historical_data"]!
                .map((x) => HistoricalData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "collected_garbage_pile": collectedGarbagePile,
        "collected_garbage_pcs": collectedGarbagePcs,
        "not_collected_garbage_pile": notCollectedGarbagePile,
        "not_collected_garbage_pcs": notCollectedGarbagePcs,
        "historical_data": historicalData == null
            ? []
            : List<dynamic>.from(historicalData!.map((x) => x.toJson())),
      };
}

class HistoricalData {
  int? weekIndex;
  String? monthName;
  int? weekInMonth;
  int? totalTransported;

  HistoricalData({
    this.weekIndex,
    this.monthName,
    this.weekInMonth,
    this.totalTransported,
  });

  factory HistoricalData.fromRawJson(String str) =>
      HistoricalData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HistoricalData.fromJson(Map<String, dynamic> json) => HistoricalData(
        weekIndex: json["week_index"],
        monthName: json["month_name"],
        weekInMonth: json["week_in_month"],
        totalTransported: json["total_transported"],
      );

  Map<String, dynamic> toJson() => {
        "week_index": weekIndex,
        "month_name": monthName,
        "week_in_month": weekInMonth,
        "total_transported": totalTransported,
      };
}
