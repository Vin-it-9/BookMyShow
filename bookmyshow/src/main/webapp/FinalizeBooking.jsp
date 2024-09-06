<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%
    // Retrieve parameters from the form submission
    String movieTitle = request.getParameter("movieTitle");
    String theaterName = request.getParameter("theaterName");
    String showDate = request.getParameter("showDate");
    String showTime = request.getParameter("showTime");
    String selectedSeats = request.getParameter("selectedSeats");
    String totalAmount = request.getParameter("totalAmount");
    String verificationKey = request.getParameter("verificationKey");
    String showId = request.getParameter("show_id"); // Get show_id from hidden input

    Connection conn = null;
    PreparedStatement bookingStmt = null;
    PreparedStatement seatUpdateStmt = null;

    SimpleDateFormat time12HourFormat = new SimpleDateFormat("hh:mm a");
    SimpleDateFormat time24HourFormat = new SimpleDateFormat("HH:mm:ss");

    try {
        // Convert the 12-hour format showTime into a 24-hour format
        java.util.Date parsedTime = time12HourFormat.parse(showTime);
        String formattedShowTime = time24HourFormat.format(parsedTime);

        // Establish database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/book", "root", "root");

        // Insert booking into the database
        String bookingQuery = "INSERT INTO bookings (movie_title, theater_name, show_date, show_time, selected_seats, total_amount, verification_key) VALUES (?, ?, ?, ?, ?, ?, ?)";
        bookingStmt = conn.prepareStatement(bookingQuery);
        bookingStmt.setString(1, movieTitle);
        bookingStmt.setString(2, theaterName);
        bookingStmt.setString(3, showDate);  // Assuming the showDate is in a valid format
        bookingStmt.setString(4, formattedShowTime);  // Using 24-hour format for time
        bookingStmt.setString(5, selectedSeats);
        bookingStmt.setDouble(6, Double.parseDouble(totalAmount));
        bookingStmt.setString(7, verificationKey);

        int rowsAffected = bookingStmt.executeUpdate();

        if (rowsAffected > 0) {
            // Update seat availability
            String seatUpdateQuery = "UPDATE movie_shows SET available_seats = available_seats - ? WHERE show_id = ?";
            seatUpdateStmt = conn.prepareStatement(seatUpdateQuery);
            seatUpdateStmt.setInt(1, selectedSeats.split(",").length);
            seatUpdateStmt.setInt(2, Integer.parseInt(showId));

            int seatUpdateCount = seatUpdateStmt.executeUpdate();
            if (seatUpdateCount > 0) {
                out.println("<h2>Booking confirmed and seat availability updated!</h2>");
            } else {
                out.println("<h2>Booking confirmed, but seat availability update failed!</h2>");
            }
        } else {
            out.println("<h2>Booking failed!</h2>");
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (bookingStmt != null) bookingStmt.close();
        if (seatUpdateStmt != null) seatUpdateStmt.close();
        if (conn != null) conn.close();
    }
%>
