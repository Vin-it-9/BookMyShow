<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Movie Details</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
     <script src = "script.js" > </script>
</head>
 <style>
  .search{
            width: 500px;
            }
        </style>
<body class="bg-gray-100">

    <div class="container mx-auto">
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            ResultSet rsCast = null;
            int movie_id = Integer.parseInt(request.getParameter("movie_id"));
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/book", "root", "root");

                // Retrieve movie details
                String sql = "SELECT * FROM movies WHERE movie_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, movie_id);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    String title = rs.getString("title");
                    String genre = rs.getString("genre");
                    int duration = rs.getInt("duration");
                    float rating = rs.getFloat("rating");
                    String language = rs.getString("language");
                    String releaseDate = rs.getDate("release_date").toString();
                    String image_url = rs.getString("image_url");
                    String posterUrl = rs.getString("poster_url");
                    String trailerUrl = rs.getString("trailer_url");
                    String description = rs.getString("description");
        %>

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

                <%
                    String movieId = request.getParameter("movie_id");
                %>

        <!-- Movie Detail Card -->
        <div class="bg-gray-800 shadow-lg overflow-hidden pl-40 pr-40 p-6 pb-14"
             style="background-image: linear-gradient(90deg, rgb(26, 26, 26) 24.97%, rgb(26, 26, 26) 38.3%, rgba(26, 26, 26, 0.04) 77.47%, rgb(26, 26, 26) 100%), url('<%= image_url %>');  background-position: center;   background-size: cover; background-repeat: no-repeat;">
            <div class="flex flex-col md:flex-row">
                <!-- Movie Poster -->
                <div class="w-60 relative">
                    <img src="<%= posterUrl %>" alt="<%= title %>" class="w-full h-full object-cover">
                    <span class="absolute left-0 right-0 bg-black text-center text-white px-2 py-1">In cinemas</span>
                </div>
                <!-- Movie Details -->
                <div class="p-6 flex flex-col justify-between md:w-2/3">
                    <div>
                        <h1 class="text-4xl font-bold mb-4 text-gray-100"><%= title %></h1>
                        <div class="flex items-center text-gray-400 mb-4">
                            <span class="text-white font-bold text-lg"><%= rating %>/10</span>
                            <span class="ml-2 text-sm">(243.4K Votes)</span>
                        </div>
                        <div class="flex items-center space-x-3 mb-4">
                            <span class="bg-white text-black px-2 py-1 rounded">2D</span>
                            <span class="bg-white text-black px-2 py-1 rounded">3D</span>
                             <span class="bg-white text-black px-2 py-1 rounded">IMAX</span>
                            <span class="bg-white text-black px-2 py-1 rounded"><%= language %></span>
                        </div>
                        <p class="text-white text-m font-semibold mb-4"><%= duration %> mins | <%= genre %> | UA | <%= releaseDate %></p>
                        <a href="trailers.jsp?movie_id=<%= movie_id %>" class="inline-block px-5 py-2 bg-blue-800 text-white rounded-md hover:bg-blue-900 transition-all">Watch Trailer</a>
                    </div>
                    <div>
                           <a href="Booking.jsp?movie_id=<%= movieId %>" class="inline-block px-7 py-2 bg-red-600 text-white rounded-md hover:bg-red-500 transition-all">Book Tickets</a>
                       </div>
                </div>
            </div>
        </div>

        <div class = " text-black mt-10 border-gray-400  border-b mr-32 ml-32 p-4">
          <h2 class="text-2xl md:text-3xl text-black font-bold mb-4">About The Movie </h2>
          <p class=" mb-4"><%= description  %></p>

        </div>

        <!-- Cast Section -->
        <div class= "mr-32 ml-32 p-4 mt-3  border-gray-400  border-b ">
        <h2 class="text-2xl md:text-3xl text-black font-bold   ">Cast</h2>
        <div class="grid grid-cols-2 sm:grid-cols-6 md:grid-cols-7 ">
            <%
                String sqlCast = "SELECT * FROM movie_cast WHERE movie_id = ?";
                pstmt = conn.prepareStatement(sqlCast);
                pstmt.setInt(1, movie_id);
                rsCast = pstmt.executeQuery();

                while (rsCast.next()) {
                    String name = rsCast.getString("name");
                    String role = rsCast.getString("role");
                    String profileImageUrl = rsCast.getString("profile_image_url");
            %>
            <!-- Cast Card -->
            <div class=" rounded-lg text-center hover:shadow-lg transition-all pt-4 ">
                <img src="<%= profileImageUrl %>" alt="<%= name %>" class="w-28 h-28 mx-auto rounded-full mb-4 object-cover ">
                <h3 class="text-m text-black"><%= name %></h3>
                <p class="text-sm text-gray-500"><%= role %></p>
            </div>
            <%
                }
            %>
        </div>

        <%
                } else {
                    out.println("<p class='text-red-500'>Movie not found.</p>");
                }
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
                out.println("<p class='text-red-500'>Error retrieving movie details.</p>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (rsCast != null) try { rsCast.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
    </div>
</body>
</html>
