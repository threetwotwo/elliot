class Sort {
  String title;
  final bool isDescending;

  Sort({this.title, this.isDescending});

  String get formattedTitle {
    switch (this.title.toLowerCase()) {
      case 'date added':
        return 'dateAdded';
    }
    return '';
  }
}
