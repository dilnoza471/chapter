// src/models/user.model.js

import { DataTypes } from 'sequelize';
// Note the .js extension for the local import
import { sequelize } from '../config/database.js'; 

const User = sequelize.define('User', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    email: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
    },
    password_hash: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    name: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    role: {
        type: DataTypes.ENUM('student', 'librarian'), 
        allowNull: false,
        defaultValue: 'student',
    },
    student_id: {
        type: DataTypes.STRING,
        allowNull: true, 
        unique: true,
    },
    borrowed_books_count: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 0,
    }
}, {
    // Optional configuration
    tableName: 'users', 
    timestamps: true, // Includes createdAt and updatedAt columns
});

// Export the User model for use in controllers
export default User;