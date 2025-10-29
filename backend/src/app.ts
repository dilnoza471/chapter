import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import dotenv from 'dotenv';
import booksRoute from './routes/booksRoute.js';

dotenv.config();
const app = express();

app.use(express.json());
app.use(cors());
app.use(helmet());
app.use(morgan('dev'));

app.use('/books', booksRoute);

const port = process.env.PORT || 5000;
app.listen(port, () => console.log(`Server running on port ${port}`));
