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

        String movieId = request.getParameter("movie_id");

        String[] theaterIds = request.getParameterValues("theater_id");
        String[] showTimes = request.getParameterValues("show_time");
        String[] showDates = request.getParameterValues("show_date");
        String[] ticketPrices = request.getParameterValues("ticket_price");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseConnection.initializeDatabase();

            String sql = "INSERT INTO movie_shows (movie_id, theater_id, show_time, show_date, ticket_price) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);

            for (int i = 0; i < theaterIds.length; i++) {
                int theaterId = Integer.parseInt(theaterIds[i]);
                Time showTime = Time.valueOf(showTimes[i] + ":00");
                Date showDate = Date.valueOf(showDates[i]);
                double ticketPrice = Double.parseDouble(ticketPrices[i]);

                pstmt.setInt(1, Integer.parseInt(movieId));
                pstmt.setInt(2, theaterId);
                pstmt.setTime(3, showTime);
                pstmt.setDate(4, showDate);
                pstmt.setDouble(5, ticketPrice);

                pstmt.executeUpdate();
            }
            response.sendRedirect("index.jsp");

        } catch (SQLException | IllegalArgumentException e) {
            e.printStackTrace();
            response.getWriter().println("Error occurred while adding shows: " + e.getMessage());

        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
