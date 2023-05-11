import User from "../models/userModel.js";
import jwt from "jsonwebtoken";

export const userSignup = async (req, res) => {
  try {
    const { name, email, profilePic } = req.body;

    let user = await User.findOne({ email });

    if (!user) {
      user = new User({
        name,
        email,
        profilePic,
      });
    }

    user = await user.save();
    const token = jwt.sign({ id: user._id }, "22071998");
    res.status(200).json({ user, token });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const userSignIn = async (req, res) => {
  try {
    const user = await User.findById(req.user);
    if (user) {
      res.status(200).json({ user, token: req.token });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
