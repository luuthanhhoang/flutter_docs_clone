import express from "express";
import auth from "../middlewares/auth.js";
import {
  documentCreateController,
  documentGetMeController,
  documentEditTitleController,
  documentGetByIdController,
} from "../controllers/documentController.js";

const documentRouter = express.Router();

documentRouter.post("/doc/create", auth, documentCreateController);
documentRouter.post("/document/title", auth, documentEditTitleController);
documentRouter.get("/document/me", auth, documentGetMeController);
documentRouter.get("/document/:id", auth, documentGetByIdController);

export default documentRouter;
