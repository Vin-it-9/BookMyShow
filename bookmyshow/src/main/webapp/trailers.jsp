<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Trailers</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <script src = "script.js" > </script>

    <style>
  .search{
            width: 500px;
            }
    </style>
</head>
<body class="bg-gray-100">

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
                                     <a href="bookingHistory.jsp" class=" hover:text-gray-600 mx-2">History</a>
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

    <!-- Main Content - Movie Trailers Section -->
    <div class="container mx-auto mt-10 mb-10 flex justify-center">
        <div class="w-full md:w-2/3">

            <h1 class="text-3xl font-bold mb-6 text-center text-gray-800">Movie Trailers</h1>

            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                int movie_id = Integer.parseInt(request.getParameter("movie_id"));

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/book", "root", "root");

                    // SQL query to fetch all trailers for the given movie_id
                    String sql = "SELECT * FROM trailers WHERE movie_id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, movie_id);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
            %>

            <!-- Trailers Grid (2 trailers per row in larger screens) -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <%
                    // Loop through all trailers for the movie
                    do {
                        String trailerUrl = rs.getString("trailer_url");
                %>
                <div class="p-4 bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow duration-300">

                    <iframe width="100%" height="315" src="<%= trailerUrl %>"
                            frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen
                            class="rounded-lg"></iframe>
                </div>
                <%
                    } while (rs.next());
                %>
            </div>

            <%
                    } else {
                        // If no trailers are found
                        out.println("<p class='text-red-500 text-center'>No trailers available for this movie.</p>");
                    }
                } catch (ClassNotFoundException | SQLException e) {
                    // Handle any SQL or class loading exceptions
                    e.printStackTrace();
                    out.println("<p class='text-red-500 text-center'>Error retrieving trailers. Please try again later.</p>");
                } finally {
                    // Ensure resources are closed properly
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>

        </div>
    </div>

</body>
</html>
