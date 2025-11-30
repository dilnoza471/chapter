import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import dotenv from 'dotenv';
import booksRoute from './routes/booksRoute.js';
import authRoutes from './routes/auth.routes.js'; // Assumes routes/auth.routes.ts is present
import userRoutes from './routes/user.routes.js';
import borrowRoute from './routes/borrowRoute.js';
import favoritesRoute from './routes/favoritesRoute.js';
import borrowingRoutes from "./routes/borrowingRoutes.js";
import reservationRoutes from "./routes/reservationRoutes.js";
import notificationRoutes from './routes/notificationRoutes.js';






dotenv.config();
const app = express();

app.use(express.json());
app.use(cors({
  origin: '*',  // Allow all origins for testing
  credentials: true
}));
app.use(helmet());
app.use(morgan('dev'));
app.use('/auth', authRoutes)
app.use('/users', userRoutes);
app.use('/books', booksRoute);
app.use('/borrow', borrowRoute);
app.use('/api/favorites', favoritesRoute);
app.use("/api/borrowings", borrowingRoutes);
app.use("/api/reservations", reservationRoutes);
app.use('/notifications', notificationRoutes);

const port = process.env.PORT || 5001;
app.listen(port, () => console.log(`Server running on port ${port}`));
