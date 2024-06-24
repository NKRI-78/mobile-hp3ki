import 'package:equatable/equatable.dart';

class PaymentGuideModel {
    final String? message;
    final int? code;
    final List<PaymentGuideData>? body;

    PaymentGuideModel({
        this.message,
        this.code,
        this.body,
    });

    factory PaymentGuideModel.fromJson(Map<String, dynamic> json) => PaymentGuideModel(
        message: json["message"],
        code: json["code"],
        body: json["body"] == null ? [] : List<PaymentGuideData>.from(json["body"]!.map((x) => PaymentGuideData.fromJson(x))),
    );
}

class PaymentGuideData extends Equatable{
    final String? logo;
    final String? category;
    final String? channel;
    final String? name;
    final List<StepModel>? steps;

    const PaymentGuideData({
        this.logo,
        this.category,
        this.channel,
        this.name,
        this.steps,
    });

    factory PaymentGuideData.fromJson(Map<String, dynamic> json) => PaymentGuideData(
        logo: json["logo"],
        category: json["category"],
        channel: json["channel"],
        name: json["name"],
        steps: json["steps"] == null ? [] : List<StepModel>.from(json["steps"]!.map((x) => StepModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "logo": logo,
        "category": category,
        "channel": channel,
        "name": name,
        "steps": steps == null ? [] : List<dynamic>.from(steps!.map((x) => x.toJson())),
    };

    @override
    List<Object?> get props => [
      logo,
      category,
      channel,
      name,
      steps,
    ];
}

class StepModel extends Equatable{
    final int? step;
    final String? description;

    const StepModel({
        this.step,
        this.description,
    });

    factory StepModel.fromJson(Map<String, dynamic> json) => StepModel(
        step: json["step"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "step": step,
        "description": description,
    };

    @override
    List<Object?> get props => [
      step,
      description
    ];

}
