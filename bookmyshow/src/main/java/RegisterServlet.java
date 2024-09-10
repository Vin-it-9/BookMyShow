import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/book", "root", "root");

            String checkQuery = "SELECT * FROM users WHERE username = ? OR email = ?";
            pst = conn.prepareStatement(checkQuery);
            pst.setString(1, username);
            pst.setString(2, email);

            rs = pst.executeQuery();

            if (rs.next()) {
                response.sendRedirect("register.jsp?error=Username or Email already exists. Please register again.");
            } else {
                String insertQuery = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
                pst = conn.prepareStatement(insertQuery);
                pst.setString(1, username);
                pst.setString(2, email);
                pst.setString(3, password);

                int rowsAffected = pst.executeUpdate();

                if (rowsAffected > 0) {
                    sendEmail(email, username);
                    response.sendRedirect("login.jsp?message=Registration successful. Please log in.");
                } else {
                    response.sendRedirect("register.jsp?error=Registration failed. Please try again.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=An error occurred. Please try again.");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) { /* Ignored */ }
            try { if (pst != null) pst.close(); } catch (Exception e) { /* Ignored */ }
            try { if (conn != null) conn.close(); } catch (Exception e) { /* Ignored */ }
        }
    }

    private void sendEmail(String recipientEmail, String username) {
        final String senderEmail = "springboot2559@gmail.com";
        final String senderPassword = "reds ccxo nfnb phgm";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Registration Successful - BookMyShow");

            String htmlContent = "<html><body style='margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;'>"
                    + "<div style='background-color: #f4f4f4; padding: 20px;'>"
                    + "<div style='max-width: 600px; margin: auto; background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);'>"
                    + "<div style='background-color: #242424; text-align: center; padding: 30px;'>"
                    + "<h1 style='color: #ffffff; font-size: 28px; margin: 0;'>Welcome to BookMyShow, " + username + "!</h1>"
                    + "</div>"
                    + "<div style='padding: 30px;'>"
                    + "<p style='color: #555555; font-size: 16px; line-height: 1.8;'>Your registration was successful, and we are thrilled to have you as part of the BookMyShow community!</p>"
                    + "<p style='color: #555555; font-size: 16px; line-height: 1.8;'>Click the button below to start exploring and booking your favorite shows:</p>"
                    + "<div style='text-align: center; margin: 30px 0;'>"
                    + "<a href='http://www.bookmyshow.com' style='display: inline-block; background-color: #1abc9c; color: #ffffff; padding: 12px 25px; font-size: 16px; font-weight: bold; text-decoration: none; border-radius: 5px;'>Visit BookMyShow</a>"
                    + "</div>"
                    + "<p style='color: #555555; font-size: 16px; line-height: 1.8;'>We can't wait for you to experience the best in entertainment!</p>"
                    + "<p style='margin-top: 20px; color: #333333;'>Best Regards,<br>"
                    + "<span style='color: #2c3e50; font-weight: bold;'>The BookMyShow Team</span></p>"
                    + "</div>"
                    + "<div style='background-color: #242424; padding: 20px; text-align: center;'>"
                    + "<p style='color: #cccccc; font-size: 12px; line-height: 1.6;'>For support, reach us at <a href='mailto:support@bookmyshow.com' style='color: #1abc9c; text-decoration: none;'>support@bookmyshow.com</a>.</p>"
                    + "<p style='color: #cccccc; font-size: 12px;'>© 2024 BookMyShow. All rights reserved.</p>"
                    + "</div>"
                    + "</div>"
                    + "</div>"
                    + "</body></html>";

            message.setContent(htmlContent, "text/html");
            Transport.send(message);

            System.out.println("Registration email sent successfully.");

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

}
