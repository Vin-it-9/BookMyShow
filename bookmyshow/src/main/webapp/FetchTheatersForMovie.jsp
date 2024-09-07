<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Map, java.util.HashMap" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page contentType="application/json" %>

<%
    String movieId = request.getParameter("movie_id");
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<Map<String, String>> theaters = new ArrayList<>();

    try {
        if (movieId != null && !movieId.isEmpty()) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/book", "root", "root");

            String theaterQuery = "SELECT DISTINCT t.theater_id, t.name " +
                                  "FROM theaters t " +
                                  "JOIN movie_shows ms ON t.theater_id = ms.theater_id " +
                                  "WHERE ms.movie_id = ?";

            pstmt = conn.prepareStatement(theaterQuery);
            pstmt.setInt(1, Integer.parseInt(movieId));
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Map<String, String> theater = new HashMap<>();
                theater.put("theater_id", String.valueOf(rs.getInt("theater_id")));
                theater.put("name", rs.getString("name"));
                theaters.add(theater);
            }
            response.setContentType("application/json");
            out.print(new Gson().toJson(theaters));
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
