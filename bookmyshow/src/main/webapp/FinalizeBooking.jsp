<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*, java.text.SimpleDateFormat" %>
<%
    Connection conn = null;
    PreparedStatement seatUpdateStmt = null;
    PreparedStatement bookingInsertStmt = null;
    boolean success = false;

    String dbURL = "jdbc:mysql://localhost:3306/book";
    String dbUser = "root";
    String dbPassword = "root";

    try {
        // Load the database driver and establish a connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Set auto-commit to false to start the transaction
        conn.setAutoCommit(false);

        // Retrieve booking details from session
        String showId = (String) session.getAttribute("showId");
        String selectedSeats = (String) session.getAttribute("selectedSeats");
        String username = (String) session.getAttribute("username");
        String movieTitle = (String) session.getAttribute("movieTitle");
        String theaterName = (String) session.getAttribute("theaterName");
        java.sql.Date showDate = (java.sql.Date) session.getAttribute("showDate");
        String showTime = (String) session.getAttribute("showTime");
        double totalAmount = (Double) session.getAttribute("totalAmount");
        String verificationKey = (String) session.getAttribute("verificationKey");

        // Ensure that the parameters are not null
        if (showId == null || selectedSeats == null || username == null || movieTitle == null ||
            theaterName == null || showDate == null || showTime == null || totalAmount == 0) {
            out.println("<p class='text-red-600'>Invalid request parameters. Please try again.</p>");
            return;
        }

        // Convert showTime from String to java.sql.Time
        java.sql.Time sqlShowTime = null;
        try {
            // Append ":00" to the showTime if it only contains HH:MM
            if (showTime.length() == 5) {
                showTime += ":00";  // Convert HH:MM to HH:MM:SS
            }
            sqlShowTime = java.sql.Time.valueOf(showTime); // Ensuring correct format
        } catch (IllegalArgumentException e) {
            out.println("<p class='text-red-600'>Invalid time format for show time. Please ensure it's in HH:MM format.</p>");
            return;
        }

        // Insert booking information into the bookings table
        String bookingInsertQuery = "INSERT INTO bookings (show_id, username, movie_title, theater_name, show_date, show_time, total_amount, selected_seats, verification_key) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        bookingInsertStmt = conn.prepareStatement(bookingInsertQuery);
        bookingInsertStmt.setInt(1, Integer.parseInt(showId));
        bookingInsertStmt.setString(2, username);
        bookingInsertStmt.setString(3, movieTitle);
        bookingInsertStmt.setString(4, theaterName);
        bookingInsertStmt.setDate(5, showDate);
        bookingInsertStmt.setTime(6, sqlShowTime);
        bookingInsertStmt.setBigDecimal(7, new java.math.BigDecimal(totalAmount));
        bookingInsertStmt.setString(8, selectedSeats);
        bookingInsertStmt.setString(9, verificationKey);
        bookingInsertStmt.executeUpdate();

        // Process selected seats
        String[] seats = selectedSeats.split(",");
        for (String seat : seats) {
            seat = seat.trim(); // Clean up any extra spaces

            // Update the seat availability in the `seats` table
            String seatUpdateQuery = "UPDATE seats SET is_available = 0 WHERE show_id = ? AND seat_no = ?";
            seatUpdateStmt = conn.prepareStatement(seatUpdateQuery);
            seatUpdateStmt.setInt(1, Integer.parseInt(showId));
            seatUpdateStmt.setString(2, seat);
            int rowsAffected = seatUpdateStmt.executeUpdate();

            if (rowsAffected == 0) {
                out.println("<p class='text-red-600'>No matching seat found for seat number: " + seat + "</p>");
                conn.rollback(); // Rollback transaction if seat update fails
                return;
            }
        }

        // Commit the transaction if everything is successful
        conn.commit();
        success = true;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmed</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col justify-center items-center">

    <div class="bg-white shadow-md rounded-lg p-8 w-96">
        <h1 class="text-2xl font-bold text-blue-600 mb-4">Booking Confirmed</h1>

        <%
            if (success) {
        %>
        <p class="text-lg font-medium text-gray-700">Thank you! Your booking has been successfully confirmed.</p>
        <p class="text-lg font-medium text-gray-700">Please keep your verification key safe for future reference.</p>
        <p class="text-lg font-medium text-gray-700">Verification Key: <%= verificationKey %></p>
        <%
            } else {
        %>
        <p class="text-red-600">There was an error confirming your booking. Please try again.</p>
        <%
            }
        %>
    </div>

</body>
</html>

<%
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
        out.println("<p class='text-red-600'>An error occurred: " + e.getMessage() + "</p>");
        if (conn != null) {
            try {
                conn.rollback(); // Rollback transaction on error
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
        }
    } finally {
        // Close resources
        try { if (seatUpdateStmt != null) seatUpdateStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (bookingInsertStmt != null) bookingInsertStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
