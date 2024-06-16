const response = require("./index");

const { Product } = require("../db/models");

class ProductController {
  static getProducts(req, res) {
    Product.findAll()
      .then((products) => {
        return res.send(response("SUCCESS", products));
      })
      .catch((err) => {
        return res.send(response("FAILED", null, err));
      });
  }

  static getProductsByCategory(req, res) {
    Product.findAll({
      where: {
        categoryId: req.params.id,
      },
    })
      .then((products) => {
        return res.send(response("SUCCESS", products));
      })
      .catch((err) => {
        return res.send(response("FAILED", null, err));
      });
  }

  static async addProduct(req, res) {
    try {
      let product = await Product.create(req.body);

      if (product) {
        return res.status(201).send(response("SUCCESS", product));
      }
    } catch (error) {
      return res.status(409).send(response("FAILED", error));
    }
  }

  static findById(req, res) {
    Product.findByPk(req.params.id)
      .then((product) => {
        if (product === null) {
          return res.send(response("FAILED", "Product not found"));
        }
        return res.send(response("SUCCESS", product));
      })
      .catch((err) => {
        return res.send(response("FAILED", err));
      });
  }

  static updateProduct(req, res) {
    Product.update(req.body, {
      where: {
        id: req.params.id,
      },
    })
      .then((product) => {
        if (product[0] === 0) {
          return res.send(response("FAILED", "Product not found"));
        }
        return res.send(response("SUCCESS", product));
      })
      .catch((err) => {
        return res.send(response("FAILED", err));
      });
  }

  static deleteProduct(req, res) {
    Product.destroy({
      where: {
        id: req.params.id,
      },
    })
      .then((product) => {
        if (product === 0) {
          return res.send(response("FAILED", "Product not found"));
        }
        if (product === 1) return res.send(response("SUCCESS", product));
      })
      .catch((err) => {
        return res.send(response("FAILED", err));
      });
  }
}

module.exports = ProductController;
