import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import http from "http";
import { Server } from "socket.io";

import userRouter from "./routers/auth.js";
import documentRouter from "./routers/document.js";

const PORT = process.env.PORT || 8001;

const app = express();
const server = http.createServer(app);
const io = new Server(server);

const DB =
  "mongodb+srv://hoangthanhluu1998:LUUthanhhoang1998@cluster0.42zzlxb.mongodb.net/?retryWrites=true&w=majority";

app.use(cors());
app.use(express.json());
app.use(userRouter);
app.use(documentRouter);

io.on("connection", (socket) => {
  socket.on("join", (documentId) => {
    socket.join(documentId);
  });

  socket.on("typing", (data) => {
    socket.broadcast.to(data.room).emit("changes", data);
  });

  socket.on("saves", (data) => {
    saveData(data);
  });
});

const saveData = async (data) => {
  let document = await Document.findById(data.room);
  document.content = data.delta;
  document = await document.save();
};

mongoose
  .connect(DB)
  .then(() => {
    console.log("Mongoose connection successful");
  })
  .catch((err) => {
    console.log(err);
  });

server.listen(PORT, "0.0.0.0", () => {
  console.log("Server is running on port ", PORT);
});
