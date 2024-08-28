import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    public static Connection initializeDatabase() throws SQLException {
        String url = "jdbc:mysql://localhost:3306/book";
        String user = "root";
        String password = "root";
        return DriverManager.getConnection(url, user, password);
    }
}
