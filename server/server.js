require("dotenv").config();

const express = require("express");
const app = express();
const port = process.env.PORT || 3001;
const cookieParser = require("cookie-parser");
const bodyParser = require("body-parser");

app.use(express.json());
app.use(express.static(__dirname + "/uploads"));
app.use(cookieParser());
app.use(express.urlencoded({ extended: true }));
app.use(
  bodyParser.urlencoded({
    extended: true,
  })
);

const routes = require("./routes");
app.use(routes);

app.listen(port, () => {
  console.log(`Server is running on port http://localhost:${port}`);
});
