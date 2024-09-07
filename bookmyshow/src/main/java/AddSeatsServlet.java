import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddSeatsServlet")
public class AddSeatsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String theaterId = request.getParameter("theater_id");
        String showId = request.getParameter("show_id");
        String endRow = request.getParameter("row");
        int totalSeats = Integer.parseInt(request.getParameter("end_seat"));

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/book", "root", "root");

            String checkSeatsQuery = "SELECT COUNT(*) FROM seats WHERE show_id = ? AND theater_id = ?";
            pstmt = conn.prepareStatement(checkSeatsQuery);
            pstmt.setInt(1, Integer.parseInt(showId));
            pstmt.setInt(2, Integer.parseInt(theaterId));
            rs = pstmt.executeQuery();

            rs.next();
            int seatCount = rs.getInt(1);

            if (seatCount > 0) {
                response.sendRedirect("addSeats.jsp?success=false&message=Seats already exist for this show.");
                return;
            }

            String insertSeatQuery = "INSERT INTO seats (`row`, seat_number, seat_no, show_id, is_available, theater_id) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertSeatQuery);

            for (char row = 'A'; row <= endRow.charAt(0); row++) {
                for (int seatNumber = 1; seatNumber <= totalSeats; seatNumber++) {
                    String seatNo = row + String.valueOf(seatNumber);

                    pstmt.setString(1, String.valueOf(row));
                    pstmt.setInt(2, seatNumber);
                    pstmt.setString(3, seatNo);
                    pstmt.setInt(4, Integer.parseInt(showId));
                    pstmt.setInt(5, 1);
                    pstmt.setInt(6, Integer.parseInt(theaterId));

                    pstmt.addBatch();
                }
            }
            pstmt.executeBatch();

            response.sendRedirect("addSeats.jsp?success=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addSeats.jsp?success=false");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
