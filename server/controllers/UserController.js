const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const response = require("./index");

const { User } = require("../db/models");

const maxAge = 3600000 * 24 * 3;

class UserController {
  static getUsers(req, res) {
    User.findAll()
      .then((users) => {
        return res.send(response("SUCCESS", users));
      })
      .catch((err) => {
        return res.send(response("FAILED", err));
      });
  }

  static async registerUser(req, res) {
    const { username, password, image } = req.body;

    if (
      username === undefined ||
      password === undefined ||
      image === undefined
    ) {
      return res.status(401).send(response("FAILED", "Empty Field"));
    }

    try {
      const data = {
        username,
        image,
        password: await bcrypt.hash(password, 10),
      };

      const user = await User.create(data);

      if (user) {
        return res.status(201).send(response("SUCCESS", user));
      }

      return res.status(409).send("Failed Sign Up");
    } catch (error) {
      console.log(`ERROR: ${error}`);
      return res.send(response("FAILED", error));
    }
  }

  static async login(req, res) {
    const { username, password } = req.body;

    if (username == undefined || password == undefined) {
      return res.status(401).send(response("FAILED", "EMPTY FIELD"));
    }

    try {
      const user = await User.findOne({
        where: {
          username: username,
        },
      });

      if (user) {
        const validPassword = await bcrypt.compare(password, user.password);

        if (validPassword) {
          let token = jwt.sign({ id: user.id }, process.env.SECRET_KEY, {
            expiresIn: maxAge,
          });

          res.cookie("jwt", token, { httpOnly: true, maxAge: maxAge });

          return res
            .status(201)
            .send(response("SUCCESS", { user, token, cookies: req.cookies }));
        }

        return res.status(401).send(response("FAILED", "Invalid Password"));
      }

      return res.status(401).send(response("FAILED", "User not found"));
    } catch (error) {
      console.log(`ERROR: ${error}`);
      return res.send(response("FAILED", error));
    }
  }

  static logout(req, res) {
    res.cookie("jwt", "", { maxAge: 1 });

    return res.send(response("SUCCESS", "User logged out"));
  }

  static findById(req, res) {
    User.findByPk(req.params.id)
      .then((user) => {
        if (user === null) {
          return res.send(response("FAILED", "User not found"));
        }
        return res.send(response("SUCCESS", user));
      })
      .catch((err) => {
        return res.send(response("FAILED", err));
      });
  }

  static updateUser(req, res) {
    User.update(req.body, {
      where: {
        id: req.params.id,
      },
    })
      .then((user) => {
        if (user[0] === 0) {
          return res.send(response("FAILED", "User not found"));
        }
        return res.send(response("SUCCESS", 1));
      })
      .catch((err) => {
        return res.send(response("FAILED", err));
      });
  }

  static deleteUser(req, res) {
    User.destroy({
      where: {
        id: req.params.id,
      },
    })
      .then((user) => {
        if (user === 0) {
          return res.send(response("FAILED", "User not found"));
        }
        return res.send(response("SUCCESS", 1));
      })
      .catch((err) => {
        return res.send(response("FAILED", err));
      });
  }
}

module.exports = UserController;
