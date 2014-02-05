mongoose = require("mongoose")
Gender = new mongoose.Schema(
  label: String
  code: String
,
  collection: "gender"
  strict: "throw"
)
module.exports = mongoose.model("Gender", Gender)