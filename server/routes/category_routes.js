const routes = require("express").Router();
const CategoryController = require("../controllers/CategoryController");

routes.get("/", CategoryController.getCategories);

routes.get("/:id", CategoryController.findById);

routes.post("/create", CategoryController.addCategory);

routes.put("/:id", CategoryController.updateCategory);

routes.delete("/:id", CategoryController.deleteCategory);

module.exports = routes;
