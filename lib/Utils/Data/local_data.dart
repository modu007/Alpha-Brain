class LocalData{

  static List getTags=[];
  static List<String> getInterests=[];
  static List<String> getCustomTags=[];
  static List<String> getUserInterestsSelected=[];
  static String capitalizeFirstLetter(String word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1);
  }
}