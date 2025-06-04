const express = require("express");
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");
const bannerRouter = require("./routes/banner");
const categoryRouter = require("./routes/category");
const subcategoryRouter = require("./routes/sub_category");
const productRouter = require("./routes/product");
const productReviewRouter = require("./routes/product_review");
const vendorRouter = require("./routes/vendor");
const orderRouter = require("./routes/order");
const cors = require("cors");
const PORT = 3000;

//middleware - to rigister routers or to mount routes

const app = express();
const DB =
  "mongodb+srv://hochien3008:hochien00@cluster0.ynzdtdz.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";
app.use(express.json());
app.use(cors()); ///enable cors for all routes and origin
app.use(authRouter);
app.use(bannerRouter);
app.use(categoryRouter);
app.use(subcategoryRouter);
app.use(productRouter);
app.use(productReviewRouter);
app.use(vendorRouter);
app.use(orderRouter);
// Gắn route
// Kết nối MongoDB
mongoose.connect(DB).then(() => {
  console.log("Mongodb Connected");
});

// Khởi động server
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
