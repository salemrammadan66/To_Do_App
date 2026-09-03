class ApiConstants {
  ApiConstants._();

  static const String baseUrl = "https://todo-backend1-btam.onrender.com";

  // Auth
  static const String loginEndpoint = "$baseUrl/api/auth/login";
  static const String registerEndpoint = "$baseUrl/api/auth/register";

  // Tasks
  static const String tasksEndpoint = "$baseUrl/api/todos";
}
