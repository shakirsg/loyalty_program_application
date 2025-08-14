class TermsAndConditions {
  final String title;
  final List<Section> sections;
  final ContactInfo contactInfo;

  TermsAndConditions({
    required this.title,
    required this.sections,
    required this.contactInfo,
  });

  factory TermsAndConditions.fromJson(Map<String, dynamic> json) {
    return TermsAndConditions(
      title: json['title'],
      sections: (json['sections'] as List)
          .map((section) => Section.fromJson(section))
          .toList(),
      contactInfo: ContactInfo.fromJson(json['contact_info']),
    );
  }
}

class Section {
  final String title;
  final String content;

  Section({
    required this.title,
    required this.content,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      title: json['title'],
      content: json['content'],
    );
  }
}

class ContactInfo {
  final String description;
  final String address;
  final String email;
  final String phone;

  ContactInfo({
    required this.description,
    required this.address,
    required this.email,
    required this.phone,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      description: json['description'],
      address: json['address'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}