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
<div class="overflow-x-auto  ">
    <table class="min-w-full  bg-white shadow-lg rounded-lg ">
        <thead>
            <tr class="bg-gradient-to-r from-blue-800 to-blue-600 text-white">
                <th class="py-4 px-6 text-center text-lg font-semibold w-1/4 ">Theater Name</th>
                <th class="py-4 px-6 text-left text-lg font-semibold">Show Times</th>
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
                        <!-- Close previous theater showtimes div -->
                        </div></td></tr>
            <%
                        }
                        currentTheater = theaterName;
                        showCount = 0;
            %>
            <tr class="bg-gray-50 hover:bg-gray-100 transition duration-300 ease-in-out border-b border-gray-200">
                <td class="py-4 px-6 font-bold text-gray-800 w-1/4 align-top"><%= theaterName %></td>
                <td class="py-4 px-6">
                    <div class="flex flex-wrap gap-3">
            <%
                    }
                    if (showCount > 0 && showCount % 7 == 0) {
            %>
                    </div><div class="flex flex-wrap gap-3 mt-4">
            <%
                    }
            %>
                    <form action="selectseat.jsp" method="GET" class="inline">
                        <input type="hidden" name="show_id" value="<%= showId %>">
                        <input type="hidden" name="movie_id" value="<%= movieId %>">
                        <input type="hidden" name="theater_name" value="<%= theaterName %>">
                        <button type="submit" class=" text-green-500 border border-gray-400 font-semibold py-2 px-4 rounded-sm hover:bg-green-600 hover:text-white transition duration-200 ease-in-out ">
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