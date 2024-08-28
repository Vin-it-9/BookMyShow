<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Results</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <style>
         .movie-card {
                        width: 100%;
                        aspect-ratio: 2 / 3;
                    }
                    .movie-card:hover .poster-img {
                        transform: scale(1.05);
                    }
                    .poster-img {
                        transition: transform 0.3s ease, filter 0.3s ease;
                    }
                    .text-overlay {
                        background: linear-gradient(to top, rgba(0, 0, 0, 0.8), rgba(0, 0, 0, 0));
                        color: white;
                    }
    </style>
</head>
<body class="bg-gray-100 ">

      <!-- Navbar -->
        <nav class="bg-blue-600 p-4 sticky top-0 z-10">
            <div class="container mx-auto flex justify-between items-center">
                <a href="index.jsp" class="text-white text-2xl font-bold">bookmyshow</a>
                <div>
                    <a href="profile.jsp" class="text-white hover:text-gray-200 mx-2">profile</a>
                    <a href="about.jsp" class="text-white hover:text-gray-200 mx-2">About</a>
                    <a href="services.jsp" class="text-white hover:text-gray-200 mx-2">Services</a>
                    <%
                        // Check if the user is logged in and has the 'admin' role
                        if (session != null && session.getAttribute("role") != null) {
                            String role = (String) session.getAttribute("role");
                            if ("admin".equals(role)) {
                    %>
                    <!-- Admin-specific links -->
                    <a href="admin_dashboard.jsp" class="text-white hover:text-gray-200 mx-2">Admin Dashboard</a>
                    <a href="add_movies.jsp" class="text-white hover:text-gray-200 mx-2">Add Movies</a>
                    <a href="addCast.jsp" class="text-white hover:text-gray-200 mx-2">Add Cast</a>
                    <a href="manage_bookings.jsp" class="text-white hover:text-gray-200 mx-2">Manage Bookings</a>
                    <a href="analytics.jsp" class="text-white hover:text-gray-200 mx-2">Analytics</a>
                    <%
                            }
                        }
                    %>
                    <!-- Logout Form or Login Link -->
                    <%
                        if (session != null && session.getAttribute("username") != null) {
                    %>
                    <form action="logout" method="post" style="display:inline;">
                        <button type="submit" class="bg-red-500 text-white hover:bg-red-700 px-4 py-2 rounded">Logout</button>
                    </form>
                    <%
                        } else {
                    %>
                    <a href="log-in" class="bg-blue-500 text-white hover:bg-blue-700 px-4 py-2 rounded">Login</a>
                    <%
                        }
                    %>
                </div>
            </div>
        </nav>
    <div class= "mr-32 ml-32 mt-10">
      <h1 class="text-3xl font-bold mb-5">Search Results</h1>
         <div class="grid grid-cols-2 md:grid-cols-6 lg:grid-cols-6 gap-4">
        <%
            String searchTerm = request.getParameter("term");
            String DB_URL = "jdbc:mysql://localhost:3306/book";
            String DB_USER = "root";
            String DB_PASSWORD = "root";

            try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                String query = "SELECT movie_id, title, genre, duration, rating, language, poster_url FROM movies WHERE title LIKE ?";
                try (PreparedStatement stmt = connection.prepareStatement(query)) {
                    stmt.setString(1, "%" + searchTerm + "%");
                    try (ResultSet rs = stmt.executeQuery()) {
                        while (rs.next()) {
                            int movie_id = rs.getInt("movie_id");
                            String title = rs.getString("title");
                            String genre = rs.getString("genre");
                            int duration = rs.getInt("duration");
                            float rating = rs.getFloat("rating");
                            String language = rs.getString("language");
                            String posterUrl = rs.getString("poster_url");
        %>

                    <a href="movieDetails.jsp?movie_id=<%= movie_id %>" class="movie-card bg-white shadow-lg rounded-lg overflow-hidden transition-transform transform hover:shadow-xl relative">
                        <img src="<%= posterUrl %>" alt="<%= title %>" class="poster-img absolute top-0 left-0 w-full h-full object-cover">
                        <div class="p-5 text-overlay absolute bottom-0 left-0 w-full">
                            <h2 class="text-xl font-bold mb-2 truncate"><%= title %></h2>
                            <p class="text-sm"><%= genre %> | <%= language %> | <%= duration %> mins</p>
                            <p class="text-yellow-400 text-sm mt-1"><%= rating %>/10</p>
                        </div>
                    </a>
        <%
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
        %>
            <p class="text-red-500">Error retrieving search results.</p>
        <%
            }
        %>
         </div>
    </div>
       </div>
</body>
</html>
