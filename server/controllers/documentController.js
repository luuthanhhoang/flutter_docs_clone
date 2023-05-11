import Document from "../models/documentModel.js";

export const documentCreateController = async (req, res) => {
  try {
    const { createdAt } = req.body;

    let document = new Document({
      uid: req.user,
      title: "Untitled Document",
      createdAt,
    });

    document = await document.save();

    res.status(200).json(document);
  } catch (error) {
    res.status(500).json(error.message);
  }
};

export const documentGetMeController = async (req, res) => {
  try {
    let documents = await Document.find({ uid: req.user });

    res.status(200).json(documents);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const documentEditTitleController = async (req, res) => {
  try {
    let { id, title } = req.body;
    let document = await Document.findByIdAndUpdate(id, { title });
    console.log(id, title, document);
    res.status(200).json(document);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const documentGetByIdController = async (req, res) => {
  try {
    let { id } = req.params;

    let document = await Document.findById(id);

    res.json(document);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
