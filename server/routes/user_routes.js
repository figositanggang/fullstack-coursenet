const routes = require("express").Router();
const UserController = require("../controllers/UserController");
const checkUser = require("../middleware/user_auth");

routes.get("", UserController.getUsers);

routes.get("/:id", UserController.findById);

routes.post("/register", checkUser, UserController.registerUser);

routes.post("/login", UserController.login);

routes.post("/logout", UserController.logout);

routes.put("/:id", UserController.updateUser);

routes.delete("/:id", UserController.deleteUser);

module.exports = routes;
