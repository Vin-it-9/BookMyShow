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
        PreparedStatement movieStmt = null;
        ResultSet rsUser = null;
        ResultSet rsMovie = null;

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

                    String movieQuery = "SELECT poster_url FROM movies WHERE title = ?";
                    movieStmt = conn.prepareStatement(movieQuery);
                    movieStmt.setString(1, movieTitle);
                    rsMovie = movieStmt.executeQuery();

                    if (rsMovie.next()) {
                        String posterUrl = rsMovie.getString("poster_url");
                        sendEmail(userEmail, username, movieTitle, theaterName, showDate, showTime, selectedSeats, totalAmount, verificationKey, posterUrl);
                    }
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
                if (rsMovie != null) rsMovie.close();
                if (userStmt != null) userStmt.close();
                if (movieStmt != null) movieStmt.close();
                if (updateSeatsStmt != null) updateSeatsStmt.close();
                if (bookingStmt != null) bookingStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private void sendEmail(String recipientEmail, String username, String movieTitle, String theaterName, String showDate, String showTime, String selectedSeats, String totalAmount, String verificationKey, String posterUrl) throws MessagingException {
        final String senderEmail = "springboot2559@gmail.com";
        final String password = "reds ccxo nfnb phgm";

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

        String emailContent = "<html><body style='margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f0f0f0;'>"
                + "<div style='background-color: #f0f0f0; padding: 20px;'>"
                + "<div style='max-width: 500px; margin: auto; background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);'>"
                + "<div style='background-color: #242424; text-align: center; padding: 35px 25px;'>"
                + "<img src='" + posterUrl + "' alt='Movie Poster' style='width: 100%; max-width: 320px; height: auto; border-radius: 10px; margin-bottom: 10px;'>"
                + "</div>"
                + "<div style='padding: 20px 30px;'>"
                + "<h2 style='color: #333333; font-size: 28px; font-weight: semibold; text-align: center; margin-bottom: 25px;'>Your Booking is Confirmed!</h2>"
                + "<p style='color: #555555; font-size: 16px; line-height: 1.6;'>Dear <strong>" + username + "</strong>,</p>"
                + "<p style='color: #666666; font-size: 16px; '>You have successfully booked tickets for <strong>" + movieTitle + "</strong> at <strong>" + theaterName + "</strong>.</p>"
                + "<div style='margin: 20px 0; padding: 20px; background-color: #f9f9f9; border-radius: 10px; border: 1px solid #e0e0e0;'>"
                + "<p style='color: #333333; font-size: 16px; margin: 0 0 10px 0;'><strong>Show Date:</strong> " + showDate + "</p>"
                + "<p style='color: #333333; font-size: 16px; margin: 0 0 10px 0;'><strong>Show Time:</strong> " + showTime + "</p>"
                + "<p style='color: #333333; font-size: 16px; margin: 0 0 10px 0;'><strong>Selected Seats:</strong> " + selectedSeats + "</p>"
                + "<p style='color: #333333; font-size: 16px; margin: 0 0 10px 0;'><strong>Total Amount:</strong> Rs. " + totalAmount + "</p>"
                + "<p style='color: #333333; font-size: 16px; margin: 0 0 10px 0;'><strong>Verification Key:</strong> " + verificationKey + "</p>"
                + "</div>"
                + "<p style='color: #777777; font-size: 14px; text-align: center;'>Thank you for booking with us! We hope you enjoy the movie.</p>"
                + "</div>"
                + "<div style='background-color: #242424; padding: 20px; text-align: center;'>"
                + "<p style='color: #cccccc; font-size: 12px; line-height: 1.6;'>For any assistance, contact us at <a href='mailto:springboot2559@gmail.com' style='color: #f39c12; text-decoration: none;'>springboot2559@gmail.com</a>.</p>"
                + "<p style='color: #cccccc; font-size: 12px;'>© 2024 Movie Booking Service</p>"
                + "</div>"
                + "</div>"
                + "</div>"
                + "</body></html>";

        message.setContent(emailContent, "text/html");

        Transport.send(message);
    }




}
