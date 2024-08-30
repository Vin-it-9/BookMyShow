<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Results</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <script src = "script.js" > </script>
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
                     .search{
                                width: 500px;
                                }
    </style>
</head>
<body class="bg-gray-100 ">

         <nav class="bg-white  p-3 sticky top-0 z-10 pl-32 pr-32">
                  <div class="container mx-auto flex justify-between items-center">

                      <a href="index.jsp" class=" text-2xl ">
                        <img src="images/bookmyshow.png" alt="Logo" class="inline-block h-10 w-auto">
                      </a>

                      <div class="relative flex items-center search">
                          <input type="text" id="searchBar" class="border border-gray-400 p-1  w-full rounded" placeholder="Search movies..." onkeyup="searchMovies()">
                         <ul id="suggestions" class="hidden cursor-pointer bg-white mt-2 pl-2 p-2 absolute top-full left-0 right-0 rounded-lg shadow-lg  transition-all"></ul>
                      <button onclick="showAllMovies()" class="bg-gray-900 text-white px-3 py-1 ml-2 rounded">Search</button>
                      </div>
                      <div>
                          <a href="profile.jsp" class=" hover:text-gray-600 mx-2">Profile</a>
                            <a href="profile.jsp" class=" hover:text-gray-600 mx-2">About</a>
                              <a href="profile.jsp" class=" hover:text-gray-600 mx-2">Contact</a>

                          <%
                              if (session != null && session.getAttribute("role") != null) {
                                  String role = (String) session.getAttribute("role");
                                  if ("admin".equals(role)) {
                          %>
                          <a href="manage_bookings.jsp" class=" hover:text-gray-600 mx-2">Manage Bookings</a>
                          <a href="analytics.jsp" class=" hover:text-gray-600 mx-2">Analytics</a>
                          <%
                                  }
                              }
                          %>
                          <!-- Logout Form or Login Link -->
                          <%
                              if (session != null && session.getAttribute("username") != null) {
                          %>
                          <form action="logout" method="post" style="display:inline;">
                              <button type="submit" class="bg-red-500 text-white hover:bg-red-700 px-3 py-1 rounded">Logout</button>
                          </form>
                          <%
                              } else {
                          %>
                          <a href="log-in" class="bg-blue-500 text-white hover:bg-blue-700 px-3 py-1 rounded">Login</a>
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
