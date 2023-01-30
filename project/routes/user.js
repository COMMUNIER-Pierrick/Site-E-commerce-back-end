const express = require("express");
const router = express.Router();
const user = require("../controllers/user");

router.get("/:id", user.getById);

module.exports = router;