// src/config/database.js

import { Sequelize } from 'sequelize';
// Note: In ESM, dotenv must be configured before use.
import dotenv from 'dotenv';
dotenv.config(); 

// Get credentials from environment variables 
const DB_NAME = process.env.DB_NAME || 'postgres';
const DB_USER = process.env.DB_USER || 'postgres';
const DB_PASSWORD = process.env.DB_PASSWORD || 'postgres';
const DB_HOST = process.env.DB_HOST || 'localhost';
const DB_DIALECT = process.env.DB_DIALECT || 'postgres'; 

// Initialize Sequelize
export const sequelize = new Sequelize(DB_NAME, DB_USER, DB_PASSWORD, {
  host: DB_HOST,
  dialect: DB_DIALECT, // e.g., 'postgres', 'mysql'
  logging: false, // Set to true to see SQL queries in console
});

/**
 * Connects to the database and syncs models.
 */
export async function connectDB() {
  try {
    await sequelize.authenticate();
    console.log('Database connection has been established successfully.');
    await sequelize.sync({ alter: true }); 
    console.log("All models were synchronized successfully."); // 🥳 NEW SUCCESS MESSAGE

  } catch (error) {
    console.error('Unable to connect to the database:', error);
    process.exit(1); 
  }
}

// Named exports for sequelize instance and the connection function
// export { sequelize, connectDB }; // Shorthand for the exports above