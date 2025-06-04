const express = require("express");
const User = require("../models/user");
const bcrypt = require("bcryptjs");
const authRouter = express.Router();
const jwt = require("jsonwebtoken");

authRouter.post("/api/signup", async (req, res) => {
  try {
    const { fullName, email, password } = req.body;

    const existingEmail = await User.findOne({ email });
    if (existingEmail) {
      return res
        .status(400)
        .json({ msg: "user with same email already exist" });
    }

    // Generate salt and hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    let user = new User({ fullName, email, password: hashedPassword });
    user = await user.save();

    // Avoid name conflict with password
    const { password: hashedPwd, ...userWithoutPassword } = user._doc;

    res.json({ user: userWithoutPassword });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//signin api endpoint

authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;
    const findUser = await User.findOne({ email });
    if (!findUser) {
      return res.status(400).json({ msg: "User not found with this email" });
    } else {
      const isMatch = await bcrypt.compare(password, findUser.password);
      if (!isMatch) {
        return res.status(400).json({ msg: " Incorrect Password" });
      } else {
        const token = jwt.sign({ id: findUser._id }, "passwordKey");

        //remove sensitive nformation
        const { password, ...userWithoutPassword } = findUser._doc;

        //send the respones

        res.json({ token, user: userWithoutPassword });
      }
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//Put route for updating user's state, city and locality
authRouter.put("/api/users/:id", async (req, res) => {
  try {
    //Extract the 'id' parameter from the request URL
    const { id } = req.params;
    //Extract the "state", "city" and locality fields from the request body
    const { state, city, locality } = req.body;
    //find the user by their ID and update the state, city and locality fields
    //the {new:true} option ensures the update document is returned
    const updatedUser = await User.findByIdAndUpdate(
      id,
      {
        state,
        city,
        locality,
      },
      { new: true }
    );

    //if no user is found, return 4040 page not found status with an error message
    if (!updatedUser) {
      return res.status(404).json({ error: "User not found" });
    }
    return res.status(200).json(updatedUser);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = authRouter;
