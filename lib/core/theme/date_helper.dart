/// Extension on [DateTime] to provide human-readable relative dates in French.
extension DateHelper on DateTime {
  String toRelativeString() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative) {
      return "À l'instant";
    }

    if (difference.inMinutes < 1) {
      return "À l'instant";
    } else if (difference.inMinutes < 60) {
      return "Il y a ${difference.inMinutes} min";
    } else if (difference.inHours < 24) {
      return "Il y a ${difference.inHours} h";
    } else if (difference.inDays == 1) {
      return "Hier";
    } else if (difference.inDays < 7) {
      return "Il y a ${difference.inDays} jours";
    } else {
      // Basic formatting for older dates: DD/MM/YYYY
      final dayStr = day.toString().padLeft(2, '0');
      final monthStr = month.toString().padLeft(2, '0');
      return "$dayStr/$monthStr/$year";
    }
  }
}
