import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import dotenv from 'dotenv';
import booksRoute from './routes/booksRoute.js';
import authRoutes from './routes/auth.routes.js'; // Assumes routes/auth.routes.ts is present
import userRoutes from './routes/user.routes.js';

dotenv.config();
const app = express();

app.use(express.json());
app.use(cors());
app.use(helmet());
app.use(morgan('dev'));
app.use('/auth', authRoutes)
app.use('/users', userRoutes);
app.use('/books', booksRoute);

const port = process.env.PORT || 5001;
app.listen(port, () => console.log(`Server running on port ${port}`));
