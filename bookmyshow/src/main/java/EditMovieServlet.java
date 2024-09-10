import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/EditMovieServlet")
public class EditMovieServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String movieIdStr = request.getParameter("movie_id");
        int movieId = Integer.parseInt(movieIdStr);

        try (Connection conn = DatabaseConnection.initializeDatabase()) {
            String query = "SELECT * FROM movies WHERE movie_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, movieId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("movieId", movieId);
                request.setAttribute("title", rs.getString("title"));
                request.setAttribute("genre", rs.getString("genre"));
                request.setAttribute("duration", rs.getInt("duration"));
                request.setAttribute("rating", rs.getBigDecimal("rating"));
                request.setAttribute("language", rs.getString("language"));
                request.setAttribute("release_date", rs.getDate("release_date"));
                request.setAttribute("description", rs.getString("description"));
                request.setAttribute("poster_url", rs.getString("poster_url"));
                request.setAttribute("trailer_url", rs.getString("trailer_url"));
                request.setAttribute("image_url", rs.getString("image_url"));

                RequestDispatcher dispatcher = request.getRequestDispatcher("editMovie.jsp");
                dispatcher.forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Movie not found!");
                RequestDispatcher dispatcher = request.getRequestDispatcher("enterMovieId.jsp");
                dispatcher.forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String movieIdStr = request.getParameter("movie_id");
        String title = request.getParameter("title");
        String genre = request.getParameter("genre");
        int duration = Integer.parseInt(request.getParameter("duration"));
        BigDecimal rating = new BigDecimal(request.getParameter("rating"));
        String language = request.getParameter("language");
        Date releaseDate = Date.valueOf(request.getParameter("release_date"));
        String description = request.getParameter("description");
        String posterUrl = request.getParameter("poster_url");
        String trailerUrl = request.getParameter("trailer_url");
        String imageUrl = request.getParameter("image_url");

        try (Connection conn = DatabaseConnection.initializeDatabase()) {
            String query = "UPDATE movies SET title = ?, genre = ?, duration = ?, rating = ?, language = ?, release_date = ?, description = ?, poster_url = ?, trailer_url = ?, image_url = ? WHERE movie_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, title);
            stmt.setString(2, genre);
            stmt.setInt(3, duration);
            stmt.setBigDecimal(4, rating);
            stmt.setString(5, language);
            stmt.setDate(6, releaseDate);
            stmt.setString(7, description);
            stmt.setString(8, posterUrl);
            stmt.setString(9, trailerUrl);
            stmt.setString(10, imageUrl);
            stmt.setInt(11, Integer.parseInt(movieIdStr));
            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect(request.getContextPath() + "/");
            } else {
                response.sendRedirect("enterMovieId.jsp?error=true");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
