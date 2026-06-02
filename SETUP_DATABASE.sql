-- ============================================
-- QUICK SETUP - Courier Management System
-- Run this entire SQL in phpMyAdmin
-- ============================================

CREATE DATABASE IF NOT EXISTS courier_management;
USE courier_management;

-- Admin Table
CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Agents Table
CREATE TABLE IF NOT EXISTS agents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(50) NOT NULL,
    branch_code VARCHAR(20),
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL
);

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(50),
    address TEXT,
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL
);

-- Customers Table
CREATE TABLE IF NOT EXISTS customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(50),
    address TEXT,
    orders INT DEFAULT 0,
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    joined DATE DEFAULT (CURRENT_DATE)
);

-- Shipments Table
CREATE TABLE IF NOT EXISTS shipments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tracking_number VARCHAR(50) UNIQUE NOT NULL,
    sender_name VARCHAR(100) NOT NULL,
    sender_phone VARCHAR(20) NOT NULL,
    sender_city VARCHAR(50) NOT NULL,
    sender_address TEXT,
    sender_email VARCHAR(100),
    receiver_name VARCHAR(100) NOT NULL,
    receiver_phone VARCHAR(20) NOT NULL,
    receiver_city VARCHAR(50) NOT NULL,
    receiver_address TEXT,
    receiver_email VARCHAR(100),
    type ENUM('Standard', 'Express', 'Overnight') DEFAULT 'Standard',
    weight DECIMAL(10,2),
    status ENUM('Pending', 'In Transit', 'Delivered', 'Returned', 'Out for Delivery') DEFAULT 'Pending',
    booked_date DATE DEFAULT (CURRENT_DATE),
    delivery_date DATE NULL,
    delivered_date TIMESTAMP NULL,
    agent_id INT NULL,
    amount DECIMAL(10,2) DEFAULT 0,
    paid_amount DECIMAL(10,2) DEFAULT 0,
    payment_status ENUM('Unpaid', 'Partial', 'Paid') DEFAULT 'Unpaid',
    notes TEXT,
    created_by VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Shipment Tracking Table
CREATE TABLE IF NOT EXISTS shipment_tracking (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tracking_number VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    description TEXT,
    updated_by VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bills Table
CREATE TABLE IF NOT EXISTS bills (
    id VARCHAR(50) PRIMARY KEY,
    customer VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    city VARCHAR(50),
    type ENUM('Shipping', 'Service', 'Storage', 'Consultation') DEFAULT 'Shipping',
    amount DECIMAL(10,2) NOT NULL,
    paid DECIMAL(10,2) DEFAULT 0,
    status ENUM('Paid', 'Unpaid', 'Overdue', 'Partial') DEFAULT 'Unpaid',
    issue_date DATE DEFAULT (CURRENT_DATE),
    due_date DATE,
    description TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- SMS Logs Table
CREATE TABLE IF NOT EXISTS sms_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tracking_number VARCHAR(50),
    recipient_phone VARCHAR(20) NOT NULL,
    message TEXT NOT NULL,
    sms_type ENUM('Booking', 'Status Update', 'Delivery', 'Promotional') DEFAULT 'Status Update',
    status ENUM('Sent', 'Failed', 'Pending') DEFAULT 'Pending',
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Branches Table
CREATE TABLE IF NOT EXISTS branches (
    id INT AUTO_INCREMENT PRIMARY KEY,
    branch_code VARCHAR(20) UNIQUE NOT NULL,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100),
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Settings Table
CREATE TABLE IF NOT EXISTS settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(50) UNIQUE NOT NULL,
    setting_value TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============ DEFAULT DATA ============

-- Default Admin (password: admin123)
INSERT INTO admins (username, password, name, email, phone) 
VALUES ('admin', MD5('admin123'), 'System Administrator', 'admin@calma.com', '0300-0000000');

-- Default Agent (password: agent123)
INSERT INTO agents (username, password, name, email, phone, city, branch_code, status) 
VALUES ('agent1', MD5('agent123'), 'Ali Khan', 'ali@calma.com', '0300-1111111', 'Karachi', 'KHI-001', 'Active');

-- Default User (password: user123)
INSERT INTO users (username, password, name, email, phone, city, address, status) 
VALUES ('user1', MD5('user123'), 'Ahmed Hassan', 'ahmed@email.com', '0300-2222222', 'Lahore', 'House 123, Lahore', 'Active');

-- Sample Customer
INSERT INTO customers (name, email, phone, city, orders, status) 
VALUES ('Fatima Malik', 'fatima@email.com', '0300-3333333', 'Islamabad', 5, 'Active');

-- Sample Branches
INSERT INTO branches (branch_code, branch_name, city, address, phone, email, status) VALUES
('KHI-001', 'Karachi Main Branch', 'Karachi', 'Saddar, Karachi', '021-1111111', 'karachi@calma.com', 'Active'),
('LHR-001', 'Lahore Branch', 'Lahore', 'Gulberg, Lahore', '042-1111111', 'lahore@calma.com', 'Active'),
('ISB-001', 'Islamabad Branch', 'Islamabad', 'Blue Area, Islamabad', '051-1111111', 'islamabad@calma.com', 'Active');

-- Default Settings
INSERT INTO settings (setting_key, setting_value) VALUES
('company_name', 'Calma Courier Services'),
('company_phone', '0300-0000000'),
('company_email', 'info@calma.com'),
('company_address', 'Main Office, Karachi'),
('sms_enabled', '0'),
('sms_api_key', ''),
('currency', 'Rs.');

-- Indexes
CREATE INDEX idx_shipments_tracking ON shipments(tracking_number);
CREATE INDEX idx_shipments_status ON shipments(status);
CREATE INDEX idx_agents_city ON agents(city);
CREATE INDEX idx_bills_status ON bills(status);
CREATE INDEX idx_users_username ON users(username);

-- ============ SETUP COMPLETE ============
