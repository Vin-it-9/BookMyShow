import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/DeleteMovieServlet")
public class DeleteMovieServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String movieIdStr = request.getParameter("movie_id");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();

        if (movieIdStr == null || movieIdStr.isEmpty()) {
            request.setAttribute("errorMessage", "Movie ID is required.");
            request.getRequestDispatcher("deleteMovie.jsp").forward(request, response);
            return;
        }

        int movieId = Integer.parseInt(movieIdStr);

        String dbURL = "jdbc:mysql://localhost:3306/book";
        String dbUser = "root";
        String dbPassword = "root";

        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND role = 'admin'";
            statement = connection.prepareStatement(sql);
            statement.setString(1, (String) session.getAttribute("username"));
            statement.setString(2, password);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                connection.setAutoCommit(false);

                sql = "DELETE FROM movie_cast WHERE movie_id = ?";
                statement = connection.prepareStatement(sql);
                statement.setInt(1, movieId);
                statement.executeUpdate();

                sql = "DELETE FROM trailers WHERE movie_id = ?";
                statement = connection.prepareStatement(sql);
                statement.setInt(1, movieId);
                statement.executeUpdate();

                sql = "DELETE FROM movies WHERE movie_id = ?";
                statement = connection.prepareStatement(sql);
                statement.setInt(1, movieId);

                int rowsAffected = statement.executeUpdate();

                if (rowsAffected > 0) {
                    connection.commit();
                    response.sendRedirect(request.getContextPath() + "/?message=Movie deleted successfully.");
                } else {
                    connection.rollback();
                    request.setAttribute("errorMessage", "Failed to delete movie. Movie ID may not exist.");
                    request.getRequestDispatcher("deletemovie.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Invalid admin credentials. Please try again.");
                request.getRequestDispatcher("deletemovie.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (connection != null) {
                    connection.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            request.setAttribute("errorMessage", "An error occurred. Please try again later.");
            request.getRequestDispatcher("deletemovie.jsp").forward(request, response);
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
