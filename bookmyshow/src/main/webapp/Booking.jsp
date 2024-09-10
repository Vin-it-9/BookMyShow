<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    String movieId = request.getParameter("movie_id");
    String selectedDate = request.getParameter("show_date");
    session.setAttribute("movie_id", movieId);

    String movieTitle = "Movie Title";

    SimpleDateFormat dayFormat = new SimpleDateFormat("EEE");
    SimpleDateFormat dayOfMonthFormat = new SimpleDateFormat("dd");
    SimpleDateFormat monthFormat = new SimpleDateFormat("MMM");
    SimpleDateFormat fullDateFormat = new SimpleDateFormat("yyyy-MM-dd");

    Calendar calendar = Calendar.getInstance();
    List<String[]> upcomingDates = new ArrayList<>();

    for (int i = 0; i < 7; i++) {
        String day = dayFormat.format(calendar.getTime());
        String dayOfMonth = dayOfMonthFormat.format(calendar.getTime());
        String month = monthFormat.format(calendar.getTime());
        String fullDate = fullDateFormat.format(calendar.getTime());
        upcomingDates.add(new String[]{day, dayOfMonth, month, fullDate});
        calendar.add(Calendar.DATE, 1);
    }

    Connection conn = null;
    PreparedStatement movieStmt = null;
    ResultSet rsMovie = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/book", "root", "root");

        String movieQuery = "SELECT title FROM movies WHERE movie_id = ?";
        movieStmt = conn.prepareStatement(movieQuery);
        movieStmt.setInt(1, Integer.parseInt(movieId));
        rsMovie = movieStmt.executeQuery();

        if (rsMovie.next()) {
            movieTitle = rsMovie.getString("title");
        }

        session.setAttribute("movie_title", movieTitle);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Tickets for <%= movieTitle %></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
     <script src = "script.js" > </script>

      <style>
        .search{
                  width: 500px;
                  }
       </style>

    <script>
        $(document).ready(function() {
            $('.date-button').click(function(event) {
                event.preventDefault();
                var selectedDate = $(this).data('date');
                var movieId = $('#movie_id').val();

                $.ajax({
                    url: 'FetchShows.jsp',
                    method: 'GET',
                    data: { movie_id: movieId, show_date: selectedDate },
                    success: function(data) {
                        $('#shows-container').html(data);
                    },
                    error: function() {
                        alert('Failed to load shows.');
                    }
                });
            });
        });
    </script>
</head>

<body class="bg-gray-200 min-h-screen ">

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

    <div class="flex items-center justify-center mt-7" >

    <div class="container mx-auto  bg-white p-8 border-b pl-32 pr-32">
        <h1 class="text-4xl font-bold text-gray-800 mb-5  text-start"><%= movieTitle %></h1>
        <input type="hidden" id="movie_id" value="<%= movieId %>">
        <div class="flex space-x-3 overflow-x-auto pb-2 mb-2 scrollbar-hide">
            <% for (String[] dateInfo : upcomingDates) { %>
                <a href="#" class="date-button flex flex-col items-center justify-center bg-gray-200 text-gray-800 font-bold py-1 px-3 rounded-lg hover:shadow-md hover:bg-gray-400 transition duration-200"
                   data-date="<%= dateInfo[3] %>">
                    <span class="text-sm"><%= dateInfo[0] %></span>
                    <span class="text-2xl mt-1"><%= dateInfo[1] %></span>
                    <span class="text-sm"><%= dateInfo[2] %></span>
                </a>
            <% } %>
        </div>
    </div>
 </div>

      <div class= "flex items-center justify-center pl-32 pr-32 pb-20 ">
        <div id="shows-container" class="bg-white mt-5  rounded-sm w-full shadow-md text-black text-center">
            <p class="text-md m-6">Select a date to view available shows</p>
        </div>
     </div>

</body>


</html>
<%
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    } finally {
        if (rsMovie != null) rsMovie.close();
        if (movieStmt != null) movieStmt.close();
        if (conn != null) conn.close();
    }
%>