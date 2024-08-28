import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddMovieServlet")
public class AddMovieServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        String genre = request.getParameter("genre");
        int duration = Integer.parseInt(request.getParameter("duration"));
        float rating = Float.parseFloat(request.getParameter("rating"));
        String language = request.getParameter("language");
        String releaseDate = request.getParameter("release_date");
        String description = request.getParameter("description");
        String posterUrl = request.getParameter("poster_url");
        String trailerUrl = request.getParameter("trailer_url");
        String imageurl = request.getParameter("image_url");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/book", "root", "root");

            String sql = "INSERT INTO movies (title, genre, duration, rating, language, release_date, description, poster_url, trailer_url , image_url) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, title);
            stmt.setString(2, genre);
            stmt.setInt(3, duration);
            stmt.setFloat(4, rating);
            stmt.setString(5, language);
            stmt.setDate(6, java.sql.Date.valueOf(releaseDate));
            stmt.setString(7, description);
            stmt.setString(8, posterUrl);
            stmt.setString(9, trailerUrl);
            stmt.setString(10, imageurl);

            stmt.executeUpdate();
            conn.close();

            response.sendRedirect(request.getContextPath() + "/");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}