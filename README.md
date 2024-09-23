# BookMyShow: Book Tickets Effortlessly

## Overview

BookMyShow is developing an admin panel that empowers administrators to perform comprehensive CRUD operations for managing the ticket booking system. Admins can add, edit, and delete movies, as well as manage shows and seats. The panel provides an overview of all users, shows, and movies. Users can easily select movies, view detailed descriptions and posters, and book shows seamlessly. Additionally, users can search for movies by name and access their previous booking history, enhancing the overall ticket purchasing experience. After registration, users receive a confirmation email, and upon booking confirmation, they receive an email with the details of their selected movies, ensuring clear communication throughout the process.

## Prerequisites

Before getting started, ensure you have the following installed on your machine:

- **Java 17**: Required to run the application.
- **Maven 3.8.1 or higher**: Used for building and managing dependencies.
- **MySQL 8.0 or higher**: The database for storing and querying supplier data.
- **IntelliJ IDEA**: Recommended IDEs for running and debugging the project.

## Getting Started

### 1. Clone the Repository

Start by cloning the project repository to your local machine:

```bash
git clone https://github.com/Vin-it-9/BookMyShow.git
```



### 2. Open the Project in IntelliJ IDEA

To work with the project in IntelliJ IDEA, follow these steps:

1. Download and install [IntelliJ IDEA](https://www.jetbrains.com/idea/).
2. Clone the project repository and open it in IntelliJ IDEA.
3. Download [Apache Tomcat 9.0](https://tomcat.apache.org/) and unzip the file to a preferred location.
4. Install the **Smart Tomcat** plugin from the IntelliJ IDEA plugin marketplace.
5. Configure Tomcat:
   - Go to **File > Project Structure > Project Settings > Facets** and add a new Web facet.
   - Go to **Run > Edit Configurations** and add a new Tomcat Server configuration, pointing to your Tomcat installation.
6. Use the IDE's built-in tools to run and debug the project on the configured Tomcat server.

After running the project, the required database tables will be automatically created.


### 3. Set Up the Database

Create the `book` database in MySQL:

```bash
CREATE DATABASE book;
```

### Create Tables

#### Users Table

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
#### Movies Table
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

#### Movie_cast Table
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
#### Trailers Table
```bash
CREATE TABLE trailers (
    trailer_id INT NOT NULL AUTO_INCREMENT,
    movie_id INT NOT NULL,
    trailer_url VARCHAR(500) NOT NULL,
    PRIMARY KEY (trailer_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE
);

```
#### Trailers Table
```bash
CREATE TABLE theaters (
    theater_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (theater_id)
);
```
#### movie_shows Table
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
#### seats Table
```bash
CREATE TABLE seats (
    seat_id INT NOT NULL AUTO_INCREMENT,
    `row` CHAR(1) NOT NULL,
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


####  bookings Table
```bash
CREATE TABLE bookings (
    booking_id INT NOT NULL AUTO_INCREMENT,
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





    
