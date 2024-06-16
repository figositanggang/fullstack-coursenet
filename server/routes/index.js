const ProductController = require("../controllers/ProductController");
const jwt = require("jsonwebtoken");

const route = require("express").Router();

const { unlink } = require("fs");

const categoriesRoute = require("./category_routes");
const productsRoute = require("./product_routes");
const userRoute = require("./user_routes");
const response = require("../controllers");
const ImageController = require("../controllers/ImageController");

const multer = require("multer");
const uploadProfilePicture = multer({ dest: "uploads/profile pictures" });
const uploadProductImage = multer({ dest: "uploads/product images" });

route.get("/", ProductController.getProducts);

// ! Get user token
route.post("/token", (req, res) => {
  let { token } = req.body;
  try {
    let jwtToken = jwt.verify(token, process.env.SECRET_KEY);

    return res.status(200).send(response("SUCCESS", jwtToken));
  } catch (error) {
    return res.status(401).send(response("FAILED", error));
  }
});

// ! Upload profile picture
route.post(
  "/upload-profile-picture",
  uploadProfilePicture.single("profile-picture"),
  ImageController.uploadImage
);

// ! Upload product image
route.post(
  "/upload-product-image",
  uploadProductImage.single("product-image"),
  ImageController.uploadImage
);

// ! Delete image
route.delete("/delete-image", (req, res) => {
  let { path } = req.body;

  unlink(path, (error) => {
    if (error) {
      return res.status(400).send(response("FAILED", error));
    }
    return res.status(200).send(response("SUCCESS", "Image deleted"));
  });
});

route.use("/products", productsRoute);
route.use("/categories", categoriesRoute);
route.use("/users", userRoute);

module.exports = route;
