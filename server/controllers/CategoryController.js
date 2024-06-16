const response = require("./index");

const { Category } = require("../db/models");

class CategoryController {
  static getCategories(req, res) {
    Category.findAll()
      .then((categories) => {
        return res.send(response("SUCCESS", categories));
      })
      .catch((err) => {
        return res.send(response("FAILED", null, err));
      });
  }

  static addCategory(req, res) {
    Category.create(req.body)
      .then((category) => {
        return res.send(response("SUCCESS", category));
      })
      .catch((err) => {
        return res.send(response("FAILED", null, err));
      });
  }

  static async findById(req, res) {
    Category.findByPk(req.params.id)
      .then((category) => {
        if (category === null) {
          return res.send(response("FAILED", "Category not found"));
        }
        return res.send(response("SUCCESS", category));
      })
      .catch((err) => {
        return res.send(response("FAILED", null, err));
      });
  }

  static updateCategory(req, res) {
    Category.update(req.body, {
      where: {
        id: req.params.id,
      },
    })
      .then((category) => {
        if (category[0] === 0) {
          return res.send(response("FAILED", "Category not found"));
        }
        return res.send(response("SUCCESS", category));
      })
      .catch((err) => {
        return res.send(response("FAILED", null, err));
      });
  }

  static deleteCategory(req, res) {
    Category.destroy({
      where: {
        id: req.params.id,
      },
    })
      .then((category) => {
        if (category === 0) {
          return res.send(response("FAILED", "Category not found"));
        }
        return res.send(response("SUCCESS", category));
      })
      .catch((err) => {
        return res.send(response("FAILED", err));
      });
  }
}

module.exports = CategoryController;
