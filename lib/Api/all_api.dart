class AllApi {
  static const baseUrl  = 'http://20.42.87.219/api';

  //register user
  static const registerUser = "$baseUrl/register/user/";

  //otp
  static const sendOtp = "$baseUrl/send/auth_code/";
  static const verifyOtp = "$baseUrl/verify/auth_code/";

  //tabs data
  static const forYou   = "$baseUrl/for_you/";
  static const topPicks = "$baseUrl/top_picks/";

  //for reaction
  static const reactionOnPost = "$baseUrl/post/reaction/";

  //bookmark a post
  static const bookmarkOnPost = "$baseUrl/post/bookmark_status/";

  //get bookmarks
  static const getBookmarks = "$baseUrl/get/bookmarks/";

  //get liked posts
  static const getLikedPosts = "$baseUrl/get/liked_post/";
}
