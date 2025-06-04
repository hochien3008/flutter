const mongoose = require("mongoose");

const orderSchema = mongoose.Schema({
  fullName: {
    type: String,
    require: true,
  },

  email: {
    type: String,
    require: true,
  },

  state: {
    type: String,
    require: true,
  },

  city: {
    type: String,
    require: true,
  },

  locality: {
    type: String,
    require: true,
  },

  productName: {
    type: String,
    require: true,
  },

  productPrice: {
    type: Number,
    require: true,
  },

  quantity: {
    type: Number,
    require: true,
  },

  category: {
    type: String,
    require: true,
  },

  image: {
    type: String,
    require: true,
  },

  buyerId: {
    type: String,
    require: true,
  },

  vendorId: {
    type: String,
    require: true,
  },

  processing: {
    type: Boolean,
    default: true,
  },

  delivered: {
    type: Boolean,
    default: false,
  },

  createdAt: {
    type: Number,
    require: true,
  },
});
const Order = mongoose.model("Order", orderSchema);
module.exports = Order;
