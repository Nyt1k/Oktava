class UserProfileImagePlayerFactory {
  static String getUserProfileImage(String imageName) {
    var list = getUserProfileImageList();
    return list
        .firstWhere((element) => element.imageName == imageName)
        .imagePath;
  }

  static List<UserProfileImage> getUserProfileImageList() {
    return [
      UserProfileImage(
        imagePath: 'assets/images/bell.png',
        imageName: 'bell',
      ),
      UserProfileImage(
        imagePath: 'assets/images/drums.png',
        imageName: 'drums',
      ),
      UserProfileImage(
        imagePath: 'assets/images/harp.png',
        imageName: 'harp',
      ),
      UserProfileImage(
        imagePath: 'assets/images/notSelected.png',
        imageName: 'notSelected',
      ),
      UserProfileImage(
        imagePath: 'assets/images/piano.png',
        imageName: 'piano',
      ),
      UserProfileImage(
        imagePath: 'assets/images/trumpet.png',
        imageName: 'trumpet',
      ),
      UserProfileImage(
        imagePath: 'assets/images/violin.png',
        imageName: 'violin',
      ),
    ];
  }
}

class UserProfileImage {
  final String imagePath;
  final String imageName;

  UserProfileImage({required this.imagePath, required this.imageName});
}
