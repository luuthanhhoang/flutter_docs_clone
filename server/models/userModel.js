import mongoose from "mongoose";

const userSchema = mongoose.Schema({
  name: {
    type: String,
    required: true,
  },

  email: {
    type: String,
    required: true,
  },

  profilePic: {
    type: String,
    required: true,
  },
});

const User = mongoose.model("User", userSchema);

export default User;
