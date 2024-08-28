<%@ page import="javax.servlet.http.HttpSession, java.sql.Connection, java.sql.DriverManager, java.sql.Statement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>bookmyshow</title>
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
          <script>
                function searchMovies() {
                    var searchTerm = document.getElementById('searchBar').value;
                    var suggestions = document.getElementById('suggestions');

                    if (searchTerm.length < 2) {
                        suggestions.style.display = 'none';
                        return;
                    }

                    var xhr = new XMLHttpRequest();
                    xhr.open('GET', 'search?term=' + encodeURIComponent(searchTerm), true);
                    xhr.onload = function() {
                        if (xhr.status === 200) {
                            var results = JSON.parse(xhr.responseText);
                            suggestions.innerHTML = '';
                            if (results.length > 0) {
                                results.forEach(function(movie) {
                                    var li = document.createElement('li');
                                    li.textContent = movie.title;
                                      li.classList.add('py-2', 'px-4', 'border-b', 'border-gray-300', 'hover:bg-gray-200', 'cursor-pointer');
                                    li.onclick = function() {
                                        window.location.href = 'movieDetails.jsp?movie_id=' + movie.movie_id;
                                    };
                                    suggestions.appendChild(li);
                                });
                                suggestions.style.display = 'block';
                            } else {
                                suggestions.style.display = 'none';
                            }
                        }
                    };
                    xhr.send();
                }

                function showAllMovies() {
                    var searchTerm = document.getElementById('searchBar').value;
                    if (searchTerm.length >= 2) {
                        window.location.href = 'searchResults.jsp?term=' + encodeURIComponent(searchTerm);
                    }
                }
            </script>
</head>
<body class="bg-gray-100">
     <nav class="bg-blue-600 p-4 sticky top-0 z-10">
            <div class="container mx-auto flex justify-between items-center">
                <a href="index.jsp" class="text-white text-2xl font-bold">bookmyshow</a>
                <div class="relative flex items-center">
                    <input type="text" id="searchBar" class="border p-1 w-full rounded" placeholder="Search movies..." onkeyup="searchMovies()">
                   <ul id="suggestions" class="hidden cursor-pointer bg-white mt-2 pl-2 p-2 absolute top-full left-0 right-0 rounded-lg shadow-lg  transition-all"></ul>
                <button onclick="showAllMovies()" class="bg-gray-900 text-white px-3 py-1 ml-2 rounded">Search</button>
                </div>
                <div>
                    <a href="profile.jsp" class="text-white hover:text-gray-200 mx-2">profile</a>
                    <a href="about.jsp" class="text-white hover:text-gray-200 mx-2">About</a>
                    <a href="services.jsp" class="text-white hover:text-gray-200 mx-2">Services</a>
                    <%
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

    <!-- Main Content -->
    <div class="container mx-auto px-4 py-6 pl-32 pr-32">
        <div class="flex-grow">
            <h3 class="text-lg font-semibold text-gray-800 text-2xl font-bold">
                <%
                    if (session != null && session.getAttribute("username") != null) {
                        String username = (String) session.getAttribute("username");
                %>
                Welcome, <%= username %>
                <%
                    } else {
                %>
                Welcome, Guest
                <%
                    }
                %>
            </h3>

            <!-- Admin Dashboard Section -->
            <%
                if (session != null && session.getAttribute("role") != null) {
                    String role = (String) session.getAttribute("role");
                    if ("admin".equals(role)) {
            %>
            <div class="mt-6 bg-white shadow-md rounded p-6">
                <h2 class="text-2xl font-bold text-gray-800">Admin Dashboard</h2>
                <div class="mt-4">
                    <div class="mt-4">
                        <a href="All-Users" class="bg-blue-500 text-white hover:bg-blue-700 px-4 py-2 rounded ml-2">Users</a>
                        <a href="Add-Movie" class="bg-blue-500 text-white hover:bg-blue-700 px-4 py-2 rounded">Add Movies</a>
                        <a href="Add-Cast" class="bg-blue-500 text-white hover:bg-blue-700 px-4 py-2 rounded ml-2">Add Cast</a>
                        <a href="Delete-movie" class="bg-blue-500 text-white hover:bg-blue-700 px-4 py-2 rounded ml-2">Delete Movie</a>
                        <a href="enterMovieId.jsp" class="bg-blue-500 text-white hover:bg-blue-700 px-4 py-2 rounded ml-2">Edit Movie</a>

                    </div>
                </div>
            </div>
            <%
                    }
                }
            %>

            <!-- Movies Section -->
            <div class=" mt-6">
                <h1 class="text-3xl font-bold mb-5">Now Showing</h1>
                <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
                    <%
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection(
                                "jdbc:mysql://localhost:3306/book", "root", "root");

                            String sql = "SELECT * FROM movies";
                            stmt = conn.createStatement();
                            rs = stmt.executeQuery(sql);

                            while (rs.next()) {
                                int movie_id = rs.getInt("movie_id");
                                String title = rs.getString("title");
                                String genre = rs.getString("genre");
                                int duration = rs.getInt("duration");
                                float rating = rs.getFloat("rating");
                                String language = rs.getString("language");
                                String posterUrl = rs.getString("poster_url");
                                String trailerUrl = rs.getString("trailer_url");
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
                        } catch (ClassNotFoundException | SQLException e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                        }
                    %>
                </div>
            </div>
        </div>
    </div>



</body>
</html>
