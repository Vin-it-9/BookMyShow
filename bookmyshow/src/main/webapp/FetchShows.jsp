<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*, java.text.SimpleDateFormat" %>
<%
    String movieId = request.getParameter("movie_id");
    String selectedDate = request.getParameter("show_date");

    Connection conn = null;
    PreparedStatement showStmt = null;
    ResultSet rsShows = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/book", "root", "root");

        if (selectedDate != null && !selectedDate.isEmpty()) {
            String showQuery = "SELECT t.name AS theater_name, ms.show_time, ms.show_id " +
                               "FROM theaters t " +
                               "JOIN movie_shows ms ON t.theater_id = ms.theater_id " +
                               "WHERE ms.movie_id = ? AND ms.show_date = ? " +
                               "ORDER BY t.name, ms.show_time";
            showStmt = conn.prepareStatement(showQuery);
            showStmt.setInt(1, Integer.parseInt(movieId));
            showStmt.setString(2, selectedDate);
            rsShows = showStmt.executeQuery();
        }

        SimpleDateFormat time24HourFormat = new SimpleDateFormat("HH:mm:ss");
        SimpleDateFormat time12HourFormat = new SimpleDateFormat("hh:mm a");
%>

<div class="overflow-x-auto">
    <table class="min-w-full bg-white shadow-md rounded-lg">
        <thead>
            <tr class="bg-blue-600 text-white">
                <th class="py-3 px-6 text-left">Theater Name</th>
                <th class="py-3 px-6 text-left">Show Times</th>
            </tr>
        </thead>
        <tbody>
            <%
                String currentTheater = "";
                int showCount = 0;
                while (rsShows != null && rsShows.next()) {
                    String theaterName = rsShows.getString("theater_name");
                    String showTime24 = rsShows.getString("show_time");
                    String showTime12 = time12HourFormat.format(time24HourFormat.parse(showTime24));
                    int showId = rsShows.getInt("show_id");

                    if (!theaterName.equals(currentTheater)) {
                        if (showCount > 0) {
            %>
                        </div></td></tr>
            <%
                        }
                        currentTheater = theaterName;
                        showCount = 0;
            %>
            <tr class="bg-gray-100 hover:bg-gray-200 transition duration-300">
                <td class="py-3 px-6 font-bold text-blue-900"><%= theaterName %></td>
                <td class="py-3 px-6">
                    <div class="flex flex-wrap gap-3">
            <%
                    }
                    if (showCount > 0 && showCount % 5 == 0) {
            %>
                    </div><div class="flex flex-wrap gap-3">
            <%
                    }
            %>
                    <form action="selectseat.jsp" method="GET" class="inline">
                        <input type="hidden" name="show_id" value="<%= showId %>">
                        <input type="hidden" name="movie_id" value="<%= movieId %>">
                        <input type="hidden" name="theater_name" value="<%= theaterName %>">
                        <button type="submit" class="bg-green-600 text-white font-semibold py-2 px-4 rounded-lg hover:bg-green-700 transition duration-300">
                            <%= showTime12 %>
                        </button>
                    </form>
            <%
                    showCount++;
                }

                if (showCount > 0) {
            %>
                    </div></td></tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>

<%
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    } finally {
        if (rsShows != null) rsShows.close();
        if (showStmt != null) showStmt.close();
        if (conn != null) conn.close();
    }
%>
