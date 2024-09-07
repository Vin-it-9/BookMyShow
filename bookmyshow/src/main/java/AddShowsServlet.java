import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

@WebServlet("/AddShowsServlet")
public class AddShowsServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get movie ID
        String movieId = request.getParameter("movie_id");

        // Get all the theater, show time, and price values submitted
        String[] theaterIds = request.getParameterValues("theater_id");
        String[] showTimes = request.getParameterValues("show_time");
        String[] showDates = request.getParameterValues("show_date");
        String[] ticketPrices = request.getParameterValues("ticket_price");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Establish the connection
            conn = DatabaseConnection.initializeDatabase();

            // Prepare SQL Insert statement
            String sql = "INSERT INTO movie_shows (movie_id, theater_id, show_time, show_date, ticket_price) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);

            // Iterate over the arrays and insert multiple shows
            for (int i = 0; i < theaterIds.length; i++) {
                int theaterId = Integer.parseInt(theaterIds[i]);
                // Parse the time format
                Time showTime = Time.valueOf(showTimes[i] + ":00"); // Append ":00" to ensure HH:mm format
                // Parse the date format
                Date showDate = Date.valueOf(showDates[i]);
                // Parse the price
                double ticketPrice = Double.parseDouble(ticketPrices[i]);

                // Set values in the prepared statement
                pstmt.setInt(1, Integer.parseInt(movieId));
                pstmt.setInt(2, theaterId);
                pstmt.setTime(3, showTime);
                pstmt.setDate(4, showDate);
                pstmt.setDouble(5, ticketPrice);

                // Execute update for each entry
                pstmt.executeUpdate();
            }

            // Redirect to the index page on success
            response.sendRedirect("index.jsp");

        } catch (SQLException | IllegalArgumentException e) {
            // Handle the exceptions and send error message to the client
            e.printStackTrace();
            response.getWriter().println("Error occurred while adding shows: " + e.getMessage());

        } finally {
            // Clean up resources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
