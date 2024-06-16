const response = require("../controllers");
const { Category } = require("../db/models");

const checkCategory = async (req, res, next) => {
  const { categoryId } = req.body;

  let category = await Category.findByPk(categoryId);

  if (category) {
    return next();
  }

  console.log(categoryId);

  return res.send(response("FAILED", "Category not found"));
};

module.exports = checkCategory;
