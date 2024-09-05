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

@WebServlet("/AddTrailersServlet")
public class AddTrailersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String movieId = request.getParameter("movie_id");
        String[] trailerUrls = request.getParameterValues("trailer_url");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/book", "root", "root");

            String sql = "INSERT INTO trailers (movie_id, trailer_url) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);

            for (String trailerUrl : trailerUrls) {
                // Convert YouTube URL to embed format if necessary
                if (trailerUrl.contains("youtube.com/watch?v=")) {
                    String videoId = trailerUrl.substring(trailerUrl.indexOf("v=") + 2);
                    trailerUrl = "https://www.youtube.com/embed/" + videoId;
                }

                pstmt.setInt(1, Integer.parseInt(movieId));
                pstmt.setString(2, trailerUrl);
                pstmt.addBatch();
            }

            pstmt.executeBatch();
            response.sendRedirect(request.getContextPath() + "/");

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error adding trailers. Please try again.");
            request.getRequestDispatcher("error.jsp").forward(request, response);

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
