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

```bash
CREATE TABLE trailers (
    trailer_id INT NOT NULL AUTO_INCREMENT,
    movie_id INT NOT NULL,
    trailer_url VARCHAR(500) NOT NULL,
    PRIMARY KEY (trailer_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE
);

```

```bash
CREATE TABLE theaters (
    theater_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (theater_id)
);
```

```bash
CREATE TABLE movie_shows (
    show_id INT NOT NULL AUTO_INCREMENT,
    movie_id INT,
    theater_id INT,
    show_time TIME NOT NULL,
    show_date DATE NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (show_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (theater_id) REFERENCES theaters(theater_id) ON DELETE CASCADE
);
```

```bash
CREATE TABLE seats (
    seat_id INT NOT NULL AUTO_INCREMENT,
    row CHAR(1) NOT NULL,
    seat_number INT NOT NULL,
    seat_no VARCHAR(10) NOT NULL,
    show_id INT NOT NULL,
    is_available TINYINT(1) NOT NULL DEFAULT 1,
    theater_id INT NOT NULL,
    PRIMARY KEY (seat_id),
    FOREIGN KEY (show_id) REFERENCES movie_shows(show_id) ON DELETE CASCADE,
    FOREIGN KEY (theater_id) REFERENCES theaters(theater_id) ON DELETE CASCADE
);
```



```bash
CREATE TABLE bookings (
    booking_id INT NOT NULL AUTO_INCREMENT,
    show_id INT NOT NULL,
    username VARCHAR(255) NOT NULL,
    movie_title VARCHAR(255) NOT NULL,
    theater_name VARCHAR(255) NOT NULL,
    show_date DATE NOT NULL,
    show_time TIME NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    selected_seats TEXT NOT NULL,
    verification_key VARCHAR(255) NOT NULL,
    PRIMARY KEY (booking_id),
    FOREIGN KEY (show_id) REFERENCES movie_shows(show_id) ON DELETE CASCADE
);
```
