import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

@WebServlet("/ConfirmBooking")
public class ConfirmBookingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String showId = request.getParameter("show_id");
        String movieTitle = request.getParameter("movieTitle");
        String theaterName = request.getParameter("theaterName");
        String showDate = request.getParameter("showDate");
        String showTime = request.getParameter("showTime");
        String totalAmount = request.getParameter("totalAmount");
        String selectedSeats = request.getParameter("selectedSeats");
        String verificationKey = request.getParameter("verificationKey");
        String username = request.getParameter("Username");

        Connection conn = null;
        PreparedStatement bookingStmt = null;
        PreparedStatement updateSeatsStmt = null;
        PreparedStatement userStmt = null;
        ResultSet rsUser = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/book", "root", "root");

            String bookingQuery = "INSERT INTO bookings (show_id, username, movie_title, theater_name, show_date, show_time, total_amount, selected_seats, verification_key) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            bookingStmt = conn.prepareStatement(bookingQuery);
            bookingStmt.setInt(1, Integer.parseInt(showId));
            bookingStmt.setString(2, username);
            bookingStmt.setString(3, movieTitle);
            bookingStmt.setString(4, theaterName);
            bookingStmt.setDate(5, Date.valueOf(showDate));
            bookingStmt.setTime(6, Time.valueOf(showTime));
            bookingStmt.setBigDecimal(7, new java.math.BigDecimal(totalAmount));
            bookingStmt.setString(8, selectedSeats);
            bookingStmt.setString(9, verificationKey);

            int bookingResult = bookingStmt.executeUpdate();

            if (bookingResult > 0) {
                String[] seatNumbers = selectedSeats.split(",");
                String updateSeatsQuery = "UPDATE seats SET is_available = 0 WHERE seat_no = ? AND show_id = ?";
                updateSeatsStmt = conn.prepareStatement(updateSeatsQuery);

                for (String seat : seatNumbers) {
                    updateSeatsStmt.setString(1, seat.trim());
                    updateSeatsStmt.setInt(2, Integer.parseInt(showId));
                    updateSeatsStmt.addBatch();
                }

                updateSeatsStmt.executeBatch();

                String userQuery = "SELECT email FROM users WHERE username = ?";
                userStmt = conn.prepareStatement(userQuery);
                userStmt.setString(1, username);
                rsUser = userStmt.executeQuery();

                if (rsUser.next()) {
                    String userEmail = rsUser.getString("email");
                    sendEmail(userEmail, username, movieTitle, theaterName, showDate, showTime, selectedSeats, totalAmount, verificationKey);
                }

                response.sendRedirect("index.jsp?message=Booking Successful");
            } else {
                response.sendRedirect("index.jsp?message=Booking Failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rsUser != null) rsUser.close();
                if (userStmt != null) userStmt.close();
                if (updateSeatsStmt != null) updateSeatsStmt.close();
                if (bookingStmt != null) bookingStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private void sendEmail(String recipientEmail, String username, String movieTitle, String theaterName, String showDate, String showTime, String selectedSeats, String totalAmount, String verificationKey) throws MessagingException {
        final String senderEmail = "springboot2559@gmail.com";
        final String password = "reds ccxo nfnb phgm";

        // Setup email properties
        Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, password);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(senderEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
        message.setSubject("Booking Confirmation");
        message.setText("Dear " + username + ",\n\nYour booking for the movie '" + movieTitle + "' at '" + theaterName + "' has been confirmed." +
                "\n\nShow Date: " + showDate +
                "\nShow Time: " + showTime +
                "\nSelected Seats: " + selectedSeats +
                "\nTotal Amount: Rs. " + totalAmount +
                "\nVerification Key: " + verificationKey +
                "\n\nThank you for choosing our service.");
        Transport.send(message);

    }
}
