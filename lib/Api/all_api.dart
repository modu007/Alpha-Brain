class AllApi {
  // static const baseUrl  = 'https://www.zalphabrains.in/api';
  //
  // static const baseUrl1  = 'https://www.zalphabrains.in';

  static const baseUrl  = 'http://20.42.87.219/api';
  static const baseUrl1  = 'http://20.42.87.219';

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

  //user availability
  static const userAvailability = "$baseUrl/check/username_availability?username=";

  //upload image
  static const uploadImage = "$baseUrl/upload/display_pic/";

  //get uploaded image
  static const getProfilePic = "$baseUrl1/fetch_dp/";

  //update profile
  static const updateProfile = "$baseUrl/update_profile/";

  //generate a token
  static const generateToken = "$baseUrl1/generate/new_token/";

  // admin api
  static const adminApi = "$baseUrl/admin_action/";

  //terms and condition
  static const termsAndCondition = "$baseUrl1/fetch_company_terms/terms_conditions.docx";

  static const getTags = "$baseUrl/get_tags/";

  //active user
  static const activeUser = "$baseUrl/active_status/";

  //get news by id
  static const getNewsById = "$baseUrl/post_id/";

  //user notified repo
  static const userNotified = "$baseUrl/user_notified/";

  //select language
  static const selectLanguage = "$baseUrl/change_language/";

  //save interests
  static const saveInterests = "$baseUrl/save_user_interest/";

  //get interests
  static const getInterests = "$baseUrl/get_interest/";

  // list of interests
  static const listOfInterests = "$baseUrl/list_interest/";

  //get my tags feed
  static const getMyTagsFeed = "$baseUrl/tags_feed/";

  //short url generator
  static const shortUrlGenerate = "$baseUrl/short_url/";
}
