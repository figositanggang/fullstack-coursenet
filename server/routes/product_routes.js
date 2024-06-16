const routes = require("express").Router();
const ProductController = require("../controllers/ProductController");
const checkCategory = require("../middleware/product_middleware");

routes.get("/:id", ProductController.findById);

routes.get("/category/:id", ProductController.getProductsByCategory);

routes.post("/create", checkCategory, ProductController.addProduct);

routes.put("/:id", ProductController.updateProduct);

routes.delete("/delete/:id", ProductController.deleteProduct);

module.exports = routes;
