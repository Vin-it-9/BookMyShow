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
<body class="bg-gray-600 min-h-screen">

    <div class="container mx-auto p-8">
        <h1 class="text-4xl font-bold text-blue-600 mb-6">Book Tickets for <%= movieTitle %></h1>

        <h3 class="text-2xl font-semibold text-gray-800 mb-4">Select a Date:</h3>

        <input type="hidden" id="movie_id" value="<%= movieId %>">

        <div class="flex space-x-4 mb-6">
            <% for (String[] dateInfo : upcomingDates) { %>
                <a href="#" class="date-button bg-blue-600 text-white font-bold py-2 px-6 rounded-lg hover:bg-blue-700 transition duration-300 text-center"
                   data-date="<%= dateInfo[3] %>">
                    <span class="block text-lg"><%= dateInfo[0] %></span>
                    <span class="block text-2xl"><%= dateInfo[1] %></span>
                    <span class="block text-lg"><%= dateInfo[2] %></span>
                </a>
            <% } %>
        </div>

        <div id="shows-container">
            <!-- Shows will be dynamically loaded here -->
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