<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*, java.text.SimpleDateFormat" %>
<%@ page import="java.util.UUID" %>
<%
    // Retrieve parameters from the previous page
    String showId = request.getParameter("show_id");
    String movieId = request.getParameter("movie_id");
    String selectedSeats = request.getParameter("selected_seats");
    String username = (String) session.getAttribute("username");

    if (showId == null || movieId == null || selectedSeats == null || username == null) {
        out.println("Missing parameters. Please go back and try again.");
        return;
    }

    Connection conn = null;
    PreparedStatement movieStmt = null;
    PreparedStatement showStmt = null;
    PreparedStatement theaterStmt = null;
    ResultSet rsMovie = null;
    ResultSet rsShow = null;
    ResultSet rsTheater = null;

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");

    double ticketPrice = 0.0;
    java.sql.Date showDate = null;
    String showTime = "";
    double totalAmount = 0.0;
    String movieTitle = "";
    String theaterName = "";
    String verificationKey = UUID.randomUUID().toString();

    try {

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/book", "root", "root");

        String movieQuery = "SELECT title FROM movies WHERE movie_id = ?";
        movieStmt = conn.prepareStatement(movieQuery);
        movieStmt.setInt(1, Integer.parseInt(movieId));
        rsMovie = movieStmt.executeQuery();

        if (rsMovie.next()) {
            movieTitle = rsMovie.getString("title");
        } else {
            out.println("Movie not found.");
            return;
        }

        // Fetch show details
        String showQuery = "SELECT show_date, show_time, ticket_price, theater_id FROM movie_shows WHERE show_id = ?";
        showStmt = conn.prepareStatement(showQuery);
        showStmt.setInt(1, Integer.parseInt(showId));
        rsShow = showStmt.executeQuery();

        if (rsShow.next()) {
            showDate = rsShow.getDate("show_date");
            showTime = timeFormat.format(rsShow.getTime("show_time"));
            ticketPrice = rsShow.getDouble("ticket_price");
            totalAmount = selectedSeats.split(",").length * ticketPrice;

            // Fetch theater details
            int theaterId = rsShow.getInt("theater_id");
            String theaterQuery = "SELECT name FROM theaters WHERE theater_id = ?";
            theaterStmt = conn.prepareStatement(theaterQuery);
            theaterStmt.setInt(1, theaterId);
            rsTheater = theaterStmt.executeQuery();

            if (rsTheater.next()) {
                theaterName = rsTheater.getString("name");
            } else {
                out.println("Theater not found.");
                return;
            }
        } else {
            out.println("Show not found.");
            return;
        }

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Booking</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen">

    <div class="container mx-auto p-6 md:p-12">
        <h1 class="text-3xl md:text-4xl font-bold text-blue-700 mb-6">Confirm Your Booking</h1>

        <div class="bg-white shadow-lg rounded-lg p-6 mb-6">
            <h2 class="text-2xl font-semibold text-gray-800 mb-2">Booking Details</h2>

            <p class="text-lg font-medium text-gray-700">Username: <%= username %></p>
            <p class="text-lg font-medium text-gray-700">Movie Title: <%= movieTitle %></p>
            <p class="text-lg font-medium text-gray-700">Theater Name: <%= theaterName %></p>
            <p class="text-lg font-medium text-gray-700">Show Date: <%= dateFormat.format(showDate) %></p>
            <p class="text-lg font-medium text-gray-700">Show Time: <%= showTime %></p>
            <p class="text-lg font-medium text-gray-700">Total Amount: <%= String.format("%.2f", totalAmount) %> Rs</p>
            <p class="text-lg font-medium text-gray-700">Selected Seats: <%= selectedSeats.replace(",", ", ") %></p>
            <p class="text-lg font-medium text-gray-700">Verification Key: <%= verificationKey %></p>
        </div>

        <form action="ConfirmBooking" method="POST">

             <input type="hidden" name="show_id" value="<%= showId %>">
            <input type="hidden" name="Username" value="<%= username %>">
            <input type="hidden" name="movieTitle" value="<%= movieTitle %>">
            <input type="hidden" name="theaterName" value="<%= theaterName %>">
            <input type="hidden" name="showDate" value="<%= dateFormat.format(showDate) %>">

           <input type="hidden" name="showTime" value="<%= rsShow.getTime("show_time") %>">

            <input type="hidden" name="totalAmount" value="<%= totalAmount %>">
            <input type="hidden" name="selectedSeats" value="<%= selectedSeats %>">
            <input type="hidden" name="verificationKey" value="<%= verificationKey %>">

            <button type="submit" class="bg-green-600 text-white font-semibold py-2 px-6 rounded-lg hover:bg-green-700 transition duration-300">
                Confirm the booking
            </button>

        </form>
    </div>

</body>
</html>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Close resources
        if (rsMovie != null) rsMovie.close();
        if (movieStmt != null) movieStmt.close();
        if (rsShow != null) rsShow.close();
        if (showStmt != null) showStmt.close();
        if (rsTheater != null) rsTheater.close();
        if (theaterStmt != null) theaterStmt.close();
        if (conn != null) conn.close();
    }
%>
