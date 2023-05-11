import express from "express";
import { userSignup, userSignIn } from "../controllers/userController.js";
import auth from "../middlewares/auth.js";

const userRouter = express.Router();

userRouter.post("/api/signup", userSignup);

userRouter.get("/", auth, userSignIn);

export default userRouter;
