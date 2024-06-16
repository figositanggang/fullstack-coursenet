const response = require(".");

class ImageController {
  static uploadImage(req, res) {
    return res.send(response("SUCCESS", req.file));
  }
}

module.exports = ImageController;
