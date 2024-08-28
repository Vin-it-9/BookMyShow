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

        // Email properties
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

            // Construct the email body with inline CSS
            String htmlContent = "<div style='font-family: Arial, sans-serif; color: #333; line-height: 1.6;'>"
                    + "<h1 style='color: #2c3e50;'>Welcome to BookMyShow, " + username + "!</h1>"
                    + "<p style='font-size: 16px;'>Your registration was successful. We are excited to have you as a part of our community!</p>"
                    + "<p style='font-size: 16px;'>Click the link below to start exploring:</p>"
                    + "<a href='http://www.bookmyshow.com' style='display: inline-block; background-color: #1abc9c; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-size: 16px;'>Visit BookMyShow</a>"
                    + "<p style='margin-top: 20px;'>Best Regards,<br><span style='color: #2c3e50; font-weight: bold;'>BookMyShow Team</span></p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html");
            Transport.send(message);

            System.out.println("Registration email sent successfully.");

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

}
