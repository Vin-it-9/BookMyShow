<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Map, java.util.HashMap" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>
<%@ page contentType="application/json" %>

<%
    String theaterId = request.getParameter("theater_id");
    String movieId = request.getParameter("movie_id");
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<Map<String, String>> shows = new ArrayList<>();

    SimpleDateFormat dbDateFormat = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat displayDateFormat = new SimpleDateFormat("d MMM yyyy");
    SimpleDateFormat dbTimeFormat = new SimpleDateFormat("HH:mm:ss");
    SimpleDateFormat displayTimeFormat = new SimpleDateFormat("h:mm a");

    try {
        if (theaterId != null && !theaterId.isEmpty() && movieId != null && !movieId.isEmpty()) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/book", "root", "root");

            String showQuery = "SELECT ms.show_id, ms.show_time, ms.show_date " +
                               "FROM movie_shows ms " +
                               "LEFT JOIN seats s ON ms.show_id = s.show_id " +
                               "WHERE ms.theater_id = ? AND ms.movie_id = ? " +
                               "AND s.show_id IS NULL " +
                               "GROUP BY ms.show_id, ms.show_time, ms.show_date";

            pstmt = conn.prepareStatement(showQuery);
            pstmt.setInt(1, Integer.parseInt(theaterId));
            pstmt.setInt(2, Integer.parseInt(movieId));
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Map<String, String> show = new HashMap<>();

                String rawDate = rs.getString("show_date");
                String rawTime = rs.getString("show_time");

                Date date = dbDateFormat.parse(rawDate);
                Date time = dbTimeFormat.parse(rawTime);

                String formattedDate = displayDateFormat.format(date);
                String formattedTime = displayTimeFormat.format(time);

                show.put("show_id", String.valueOf(rs.getInt("show_id")));
                show.put("show_time", formattedTime);
                show.put("show_date", formattedDate);

                shows.add(show);
            }

            response.setContentType("application/json");
            out.print(new Gson().toJson(shows));
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
