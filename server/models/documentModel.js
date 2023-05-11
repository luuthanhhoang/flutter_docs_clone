import mongoose from "mongoose";

const documentSchema = mongoose.Schema({
  uid: {
    required: true,
    type: String,
  },
  createdAt: {
    required: true,
    type: Number,
  },
  title: {
    require: true,
    type: String,
    trim: true,
  },
  content: {
    type: Array,
    default: [],
  },
});

const Document = mongoose.model("Document", documentSchema);

export default Document;
