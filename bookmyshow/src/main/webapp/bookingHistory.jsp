<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking History</title>
    <!-- Include Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
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

    <div class="container mx-auto p-6 pl-32 pr-32">
        <h1 class="text-2xl font-bold mb-6">Your Booking History</h1>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <%
                String username = (String) session.getAttribute("username");

                if (username == null) {
                    response.sendRedirect("login.jsp");
                }

                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/book", "root", "root");
                    String sql = "SELECT * FROM bookings WHERE username = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, username);
                    rs = pstmt.executeQuery();
                    while (rs.next()) {
            %>

            <div class="bg-white shadow-lg rounded-lg p-8 max-w-lg mx-auto">
                <h2 class="text-1xl md:text-2xl font-bold text-gray-800 mb-6 break-words">
                    <%= rs.getString("movie_title") %>
                </h2>

                <div class="text-gray-700 space-y-4">
                    <p class="flex flex-col sm:flex-row">
                        <span class="font-medium text-gray-900 w-24">Theater:</span>
                        <span class="mt-1 sm:mt-0"><%= rs.getString("theater_name") %></span>
                    </p>
                    <p class="flex flex-col sm:flex-row">
                        <span class="font-medium text-gray-900 w-24">Date:</span>
                        <span class="mt-1 sm:mt-0"><%= rs.getDate("show_date") %></span>
                    </p>
                    <p class="flex flex-col sm:flex-row">
                        <span class="font-medium text-gray-900 w-24">Time:</span>
                        <span class="mt-1 sm:mt-0"><%= rs.getTime("show_time") %></span>
                    </p>
                    <div>
                        <span class="font-medium text-gray-900">Seats:</span>
                        <div class="flex flex-wrap mt-2 gap-2">
                            <%
                                String seats = rs.getString("selected_seats");
                                String[] seatArray = seats.split(",\\s*");
                                for(String seat : seatArray){
                            %>
                            <span class="bg-blue-100 text-blue-800 text-sm font-medium px-3 py-1 rounded-full">
                                <%= seat %>
                            </span>
                            <% } %>
                        </div>
                    </div>
                    <p class="text-lg font-semibold text-gray-800 border-t pt-4 mt-6">
                        <span class="font-bold">Total Amount:</span> <%= rs.getBigDecimal("total_amount") %> Rs
                    </p>
                </div>
            </div>




            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                    <p class="text-red-500">Error retrieving booking history.</p>
            <%
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </div>
    </div>

</body>
</html>
