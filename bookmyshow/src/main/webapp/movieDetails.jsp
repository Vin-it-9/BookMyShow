<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Movie Details</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="text-gray-100">

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

        <!-- Movie Detail Card -->
        <div class="bg-gray-800 shadow-lg overflow-hidden pl-40 pr-40 p-6 pb-14"
             style="background-image: linear-gradient(90deg, rgb(26, 26, 26) 24.97%, rgb(26, 26, 26) 38.3%, rgba(26, 26, 26, 0.04) 77.47%, rgb(26, 26, 26) 100%), url('<%= image_url %>'); background-size: cover; background-position: center;">
            <div class="flex flex-col md:flex-row">
                <!-- Movie Poster -->
                <div class="w-60 relative">
                    <img src="<%= posterUrl %>" alt="<%= title %>" class="w-full h-full object-cover">
                    <span class="absolute left-0 right-0 bg-black text-center text-white px-2 py-1">In cinemas</span>
                </div>
                <!-- Movie Details -->
                <div class="p-6 flex flex-col justify-between md:w-2/3">
                    <div>
                        <h1 class="text-4xl font-bold mb-4"><%= title %></h1>
                        <div class="flex items-center text-gray-400 mb-4">
                            <span class="text-white font-bold text-lg"><%= rating %>/10</span>
                            <span class="ml-2 text-sm">(243.4K Votes)</span>
                        </div>
                        <div class="flex items-center space-x-3 mb-4">
                            <span class="bg-white text-black px-2 py-1 rounded">2D</span>
                            <span class="bg-white text-black px-2 py-1 rounded"><%= language %></span>
                        </div>
                        <p class="text-white text-m font-semibold mb-4"><%= duration %> mins | <%= genre %> | UA | <%= releaseDate %></p>
                        <a href="<%= trailerUrl %>" class="inline-block px-5 py-2 bg-blue-800 text-white rounded-md hover:bg-blue-900 transition-all">Watch Trailer</a>
                    </div>
                    <div>
                        <button class="inline-block px-7 py-2 bg-red-600 text-white rounded-md hover:bg-red-500 transition-all">Book tickets</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Cast Section -->
        <h2 class="text-2xl md:text-3xl font-bold mb-6">Cast</h2>
        <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-6">
            <%
                // Retrieve cast details
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
            <div class="bg-gray-800 rounded-lg shadow-md p-4 text-center hover:shadow-lg transition-all">
                <img src="<%= profileImageUrl %>" alt="<%= name %>" class="w-24 h-24 mx-auto rounded-full mb-4 object-cover border-4 border-gray-700">
                <h3 class="text-lg font-semibold text-white"><%= name %></h3>
                <p class="text-sm text-gray-400"><%= role %></p>
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
