// String Host = "http://localhost:3000";
String Host = "https://blue-relieved-blackbuck.cyclic.app";

// Authentication
String validateuserAPI = "$Host/user/validateuser";
String validateAdminAPI = "$Host/user/validateadmin";


// Users
String Allusers = "$Host/user/allUsers";
String userbyidAPI = "$Host/user/userbyid";
String adminbyidAPI = "$Host/user/adminbyid";
String userbymobAPI = "$Host/user/userbymob";
String updateUserAPI = "$Host/user/updateUser";
String addUserAPI = "$Host/user/addUser";
String updateUserPassAPI = "$Host/user/updateUserPass";

//Projects
String projectByIdAPI = "$Host/projects/getProjectById";
String addProjectAPI = "$Host/projects/addProject";
String getAllProjects = "$Host/projects/getallprojects";

//Transaction
String userTransById = "$Host/transaction/getbyid";