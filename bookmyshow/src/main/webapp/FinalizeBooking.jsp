<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Finalize Booking</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css">
</head>
<body class="bg-gray-100 min-h-screen flex flex-col justify-center items-center">
    <div class="bg-white shadow-md rounded-lg p-8 w-96">
        <h1 class="text-2xl font-bold text-blue-600 mb-4">Booking Confirmation</h1>

        <%
            Connection conn = null;
            PreparedStatement theaterIdStmt = null;
            PreparedStatement seatUpdateStmt = null;
            ResultSet rsTheaterId = null;

            String dbURL = "jdbc:mysql://localhost:3306/book";
            String dbUser = "root";
            String dbPassword = "root";

            try {
                // Load the database driver and establish a connection
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Get user inputs from the request
                String showId = request.getParameter("show_id");
                String selectedSeats = request.getParameter("selected_seats");
                String username = request.getParameter("username");
                String movieTitle = request.getParameter("movie_title");
                String theaterName = request.getParameter("theater_name");
                String showDate = request.getParameter("show_date");
                String showTime = request.getParameter("show_time");
                String totalAmount = request.getParameter("total_amount");
                String verificationKey = request.getParameter("verification_key");

                // Ensure that the parameters are not null
                if (showId == null || selectedSeats == null || username == null || movieTitle == null ||
                    theaterName == null || showDate == null || showTime == null || totalAmount == null) {
                    out.println("Invalid request parameters.");
                    return;
                }

                // Process selected seats
                String[] seats = selectedSeats.split(",");
                for (String seat : seats) {
                    seat = seat.trim(); // Clean up any extra spaces
                    String[] seatInfo = seat.split("_"); // Split using '_'

                    if (seatInfo.length == 2) { // Ensure we have both row and seat number
                        String row = seatInfo[0];
                        int seatNumber;
                        try {
                            seatNumber = Integer.parseInt(seatInfo[1]);

                            // Get the theater ID for the given show
                            String theaterIdQuery = "SELECT theater_id FROM movie_shows WHERE show_id = ?";
                            theaterIdStmt = conn.prepareStatement(theaterIdQuery);
                            theaterIdStmt.setInt(1, Integer.parseInt(showId));
                            rsTheaterId = theaterIdStmt.executeQuery();

                            if (rsTheaterId.next()) {
                                int theaterId = rsTheaterId.getInt("theater_id");

                                // Update the seat availability in the `seats` table
                                String seatUpdateQuery = "UPDATE seats SET is_available = 0 WHERE theater_id = ? AND row = ? AND seat_number = ?";
                                seatUpdateStmt = conn.prepareStatement(seatUpdateQuery);
                                seatUpdateStmt.setInt(1, theaterId);
                                seatUpdateStmt.setString(2, row);
                                seatUpdateStmt.setInt(3, seatNumber);
                                seatUpdateStmt.executeUpdate();
                            } else {
                                out.println("Theater ID not found for the given show ID.");
                            }
                        } catch (NumberFormatException e) {
                            // Handle invalid seat number format
                            out.println("Invalid seat number format: " + seatInfo[1]);
                        }
                    } else {
                        // Handle invalid seat format
                        out.println("Invalid seat format: " + seat);
                    }
                }
        %>

        <!-- Booking Details Section -->
        <h2 class="text-xl font-semibold mb-2">Booking Details</h2>
        <p>Username: <%= username %></p>
        <p>Movie Title: <%= movieTitle %></p>
        <p>Theater Name: <%= theaterName %></p>
        <p>Show Date: <%= showDate %></p>
        <p>Show Time: <%= showTime %></p>
        <p>Total Amount: <%= totalAmount %> Rs</p>
        <p>Selected Seats: <%= selectedSeats %></p>
        <p>Verification Key: <%= verificationKey %></p>

        <p class="mt-4 text-green-600 font-bold">Thank you! Your booking has been successfully confirmed.</p>
        <p class="text-gray-700">Please keep your verification key safe for future reference.</p>

        <%
            } catch (Exception e) {
                e.printStackTrace();
                out.println("An error occurred: " + e.getMessage());
            } finally {
                // Close resources
                try { if (rsTheaterId != null) rsTheaterId.close(); } catch (SQLException e) { e.printStackTrace(); }
                try { if (theaterIdStmt != null) theaterIdStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                try { if (seatUpdateStmt != null) seatUpdateStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
    </div>
</body>
</html>
