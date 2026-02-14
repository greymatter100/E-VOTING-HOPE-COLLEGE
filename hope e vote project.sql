CREATE DATABASE IF NOT EXISTS hope_voting;
USE hope_voting;

-- Table structure for roles (optional if fixed, but good for scaling)
-- We will use ENUM in users table for simplicity as per TypeScript definition

-- Table structure for positions
CREATE TABLE IF NOT EXISTS positions (
    id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(100) NOT NULL
);

-- Table structure for users
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(50) PRIMARY KEY, -- Student ID or Email for admin
    password VARCHAR(255) NOT NULL, -- Should be hashed in production
    role ENUM('STUDENT', 'ADMIN') NOT NULL DEFAULT 'STUDENT',
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table structure for tracking which positions a user has voted for
CREATE TABLE IF NOT EXISTS user_votes (
    user_id VARCHAR(50) NOT NULL,
    position_id VARCHAR(50) NOT NULL,
    voted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, position_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (position_id) REFERENCES positions(id) ON DELETE CASCADE
);

-- Table structure for candidates
CREATE TABLE IF NOT EXISTS candidates (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    position_id VARCHAR(50) NOT NULL,
    votes INT DEFAULT 0,
    image_url TEXT,
    FOREIGN KEY (position_id) REFERENCES positions(id) ON DELETE CASCADE
);

-- Table structure for articles
CREATE TABLE IF NOT EXISTS articles (
    id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    image_url TEXT,
    date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table structure for comments on articles
CREATE TABLE IF NOT EXISTS comments (
    id VARCHAR(50) PRIMARY KEY,
    article_id VARCHAR(50) NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    text TEXT NOT NULL,
    date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
);

-- Table structure for system settings
CREATE TABLE IF NOT EXISTS system_settings (
    setting_key VARCHAR(50) PRIMARY KEY,
    setting_value TEXT
);

-- Insert default positions
INSERT INTO positions (id, title) VALUES
('1', 'President'),
('2', 'Vice President'),
('3', 'Secretary'),
('4', 'Food Minister'),
('5', 'Health Minister'),
('6', 'Justice Minister'),
('7', 'Sports Minister'),
('8', 'Religious Minister'),
('9', 'Entertainment Minister')
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- Insert default candidates
INSERT INTO candidates (id, name, position_id, votes) VALUES
('c1', 'John Doe', '1', 0),
('c2', 'Jane Smith', '1', 0),
('c7', 'Rev. Joseph Phiri', '8', 0)
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- Insert default system settings
INSERT INTO system_settings (setting_key, setting_value) VALUES
('is_system_locked', '0'),
('admin_pin', '0000')
ON DUPLICATE KEY UPDATE setting_value=VALUES(setting_value);
