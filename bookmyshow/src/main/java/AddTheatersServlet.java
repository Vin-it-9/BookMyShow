import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddTheatersServlet")
public class AddTheatersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String city = request.getParameter("city");
        String[] theaterNames = request.getParameterValues("theater_name");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/book", "root", "root");
            pstmt = conn.prepareStatement("INSERT INTO theaters (name, location) VALUES (?, ?)");

            for (String theaterName : theaterNames) {
                pstmt.setString(1, theaterName);
                pstmt.setString(2, city);
                pstmt.addBatch();
            }
            pstmt.executeBatch();
            response.sendRedirect(request.getContextPath() + "/");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
