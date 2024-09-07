<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Seats for Shows</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 p-10">
    <div class="max-w-xl mx-auto bg-white shadow-lg rounded-lg p-8">
        <h1 class="text-4xl font-bold mb-6 text-center text-blue-600">Add Seats for Shows</h1>
        <form action="AddSeatsServlet" method="post" class="space-y-6">
            <div>
                <label for="movie_id" class="block text-gray-700 font-semibold mb-2">Select Movie:</label>
                <select id="movie_id" name="movie_id" required class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <option value="" disabled selected>Select Movie</option>
                    <%
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/book", "root", "root");

                            String movieQuery = "SELECT movie_id, title FROM movies ORDER BY title ASC";
                            pstmt = conn.prepareStatement(movieQuery);
                            rs = pstmt.executeQuery();

                            while (rs.next()) {
                                int movieId = rs.getInt("movie_id");
                                String movieTitle = rs.getString("title");
                    %>
                    <option value="<%=movieId%>"><%=movieTitle%></option>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                            if (conn != null) conn.close();
                        }
                    %>
                </select>
            </div>
            <div>
                <label for="theater_id" class="block text-gray-700 font-semibold mb-2">Select Theater:</label>
                <select id="theater_id" name="theater_id" required class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <option value="" disabled selected>Select Theater</option>
                </select>
            </div>
            <div>
                <label for="show_id" class="block text-gray-700 font-semibold mb-2">Select Show:</label>
                <select id="show_id" name="show_id" required class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <option value="" disabled selected>Select Show</option>
                </select>
            </div>
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label for="row" class="block text-gray-700 font-semibold mb-2">Seat Row (A-Z):</label>
                    <input type="text" id="row" name="row" maxlength="1" required pattern="[A-Z]" placeholder="Enter end row" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label for="end_seat" class="block text-gray-700 font-semibold mb-2">Total Seats :</label>
                    <input type="number" id="end_seat" name="end_seat" min="1" max="12" required placeholder="Enter seat numbers" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
            </div>

            <button type="submit" class="w-full bg-blue-600 text-white font-bold py-3 rounded-lg hover:bg-blue-700 transition duration-300">
                Submit
            </button>
        </form>

        <script>
            document.getElementById('movie_id').addEventListener('change', function() {
                var movieId = this.value;
                var theaterSelect = document.getElementById('theater_id');
                theaterSelect.innerHTML = '<option value="" disabled selected>Select Theater</option>';

                fetch('FetchTheatersForMovie.jsp?movie_id=' + movieId)
                    .then(response => response.json())
                    .then(data => {
                        data.forEach(theater => {
                            var option = document.createElement('option');
                            option.value = theater.theater_id;
                            option.text = theater.name;
                            theaterSelect.add(option);
                        });
                    });
            });

            document.getElementById('theater_id').addEventListener('change', function() {
                var theaterId = this.value;
                var movieId = document.getElementById('movie_id').value;
                var showSelect = document.getElementById('show_id');
                showSelect.innerHTML = '<option value="" disabled selected>Select Show</option>';

                fetch('FetchShowsForTheater.jsp?theater_id=' + theaterId + '&movie_id=' + movieId)
                    .then(response => response.json())
                    .then(data => {
                        data.forEach(show => {
                            var option = document.createElement('option');
                            option.value = show.show_id;
                            option.text = `Show on ${show.show_date} at ${show.show_time}`;
                            showSelect.add(option);
                        });
                    });
            });
        </script>
    </div>
</body>
</html>
