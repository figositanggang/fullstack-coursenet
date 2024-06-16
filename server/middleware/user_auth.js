const response = require("../controllers");
const { User } = require("../db/models");

const checkUser = async (req, res, next) => {
  try {
    let user = await User.findOne({
      where: {
        username: req.body.username,
      },
    });

    if (user) {
      return res.send(response("FAILED", `Username has taken`));
    }

    next();
  } catch (error) {
    console.log(error);
    return res.send(response("FAILED", error));
  }
};

module.exports = checkUser;
