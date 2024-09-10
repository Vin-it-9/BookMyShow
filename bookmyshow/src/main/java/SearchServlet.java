import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.google.gson.Gson;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/book";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String searchTerm = request.getParameter("term");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        List<Movie> movies = new ArrayList<>();
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String query = "SELECT movie_id, title FROM movies WHERE title LIKE ?";
            try (PreparedStatement stmt = connection.prepareStatement(query)) {
                stmt.setString(1, "%" + searchTerm + "%");
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Movie movie = new Movie();
                        movie.setMovieId(rs.getInt("movie_id"));
                        movie.setTitle(rs.getString("title"));
                        movies.add(movie);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        Gson gson = new Gson();
        String json = gson.toJson(movies);

        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }

    private class Movie {
        private int movie_id;
        private String title;

        public int getMovieId() {
            return movie_id;
        }

        public void setMovieId(int movie_id) {
            this.movie_id = movie_id;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }
    }
}
