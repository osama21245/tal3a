class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://tal3a-5qmf.onrender.com';

  // API Endpoints
  static const String signupEndpoint = '/api/v1/auth/signup';
  static const String forgotPasswordEndpoint = '/api/v1/auth/forgot-password';
  static const String resetPasswordEndpoint = '/api/v1/auth/resetPassword';
  static const String verifyOtpEndpoint = '/api/v1/auth/verify-otp';
  static const String sendVerificationCodeEndpoint =
      '/api/v1/auth/sendVerificationCode';
  static const String verifyCodeEndpoint = '/api/v1/auth/verifyCode';
  static const String loginEndpoint = '/api/v1/auth/login';
  static const String sendForgotCodeEndpoint = '/api/v1/auth/sendForgotCode';

  // Home endpoints
  static const String getAllUsersExceptSelfEndpoint =
      '/api/v1/user/getAllUsersExceptSelf';

  // Events endpoints
  static const String getAllEventsEndpoint = '/api/v1/user/event/getAll';
  static const String getEventDetailsEndpoint = '/api/v1/user/event/getOne';
  static const String purchaseTicketEndpoint =
      '/api/v1/user/event/purchaseTicket';
  static const String myPurchasesEndpoint = '/api/v1/user/event/myPurchases';

  // Story endpoints
  static const String uploadStoriesEndpoint = '/api/v1/user/uploadStories';
  static const String usersWithStoriesEndpoint =
      '/api/v1/user/usersWithStories';
  static const String getUserStoriesEndpoint = '/api/v1/user/stories';

  // User info endpoints
  static const String getUserInfoEndpoint = '/api/v1/auth/getUserInfo';
  static const String refreshTokenEndpoint = '/api/v1/auth/refreshToken';
  static const String profileSetupEndpoint = '/api/v1/auth/completeProfile';

  // tal3a vibes endpoints
  static const String foryouVideos = '/api/v1/tal3aVibesRoute/videos/foryou';
  static const String likeVideo = '/api/v1/tal3aVibesRoute/like';
  static const String uploadVideo = 'api/v1/tal3aVibesRoute/uploadVideo';
  static const String myPosts = '/api/v1/tal3aVibesRoute/myPosts';
  static const String comments = '/api/v1/tal3aVibesRoute/comments';
  static const String comment = '/api/v1/tal3aVibesRoute/comment/';
  static const String deleteComment = '/api/v1/tal3aVibesRoute/deleteComment';

  // Bearer Token
  static const String bearerToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4ZDEzNTJkOTIwOTgzNTNiNzY1YzJiZiIsImlhdCI6MTc2MTMxNzg1NCwiZXhwIjoxNzYxMzM5NDU0fQ.mWXBUzgEj1awxCHMLppzHKXOnxFSQZ4DZSgB5ZP6ciU';

  // Request Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Authenticated Headers
  static Map<String, String> get authenticatedHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $bearerToken',
  };

  // Timeout Duration
  static const Duration timeoutDuration = Duration(seconds: 200);
}
