```bash
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    role VARCHAR(20) DEFAULT 'user'
);
```
```bash
CREATE TABLE movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    duration INT,
    rating DECIMAL(2,1),
    language VARCHAR(50),
    release_date DATE,
    description TEXT,
    poster_url VARCHAR(500),
    trailer_url VARCHAR(500),
    image_url VARCHAR(500)
);
```
```bash
CREATE TABLE movie_cast (
    cast_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(100) NOT NULL,
    profile_image_url VARCHAR(255),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);
```
