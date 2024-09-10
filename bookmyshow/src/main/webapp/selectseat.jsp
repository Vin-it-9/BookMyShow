<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*, java.text.SimpleDateFormat" %>
<%@ page import="java.util.HashMap, java.util.Map" %>
<%
    String showId = request.getParameter("show_id");
    String movieId = request.getParameter("movie_id");
    String movieTitle = (String) session.getAttribute("movie_title");
    String theaterName = "";
    String showTime = "";
    int theaterId = 0;
    double seatPrice = 0.0;

    Connection conn = null;
    PreparedStatement showStmt = null;
    PreparedStatement seatsStmt = null;
    ResultSet rsShow = null;
    ResultSet rsSeats = null;

    SimpleDateFormat time24HourFormat = new SimpleDateFormat("HH:mm:ss");
    SimpleDateFormat time12HourFormat = new SimpleDateFormat("hh:mm a");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/book", "root", "root");

        String showQuery = "SELECT t.theater_id, t.name AS theater_name, ms.show_time, ms.ticket_price " +
                           "FROM movie_shows ms " +
                           "JOIN theaters t ON ms.theater_id = t.theater_id " +
                           "WHERE ms.show_id = ?";
        showStmt = conn.prepareStatement(showQuery);
        showStmt.setInt(1, Integer.parseInt(showId));
        rsShow = showStmt.executeQuery();

        if (rsShow.next()) {
            theaterId = rsShow.getInt("theater_id");
            theaterName = rsShow.getString("theater_name");
            showTime = rsShow.getString("show_time");
            seatPrice = rsShow.getDouble("ticket_price");
            java.util.Date date = time24HourFormat.parse(showTime);
            showTime = time12HourFormat.format(date);
        } else {
            out.println("No show information found for the given ID.");
            return;
        }
        String seatsQuery = "SELECT `row`, seat_number, seat_no, is_available " +
                            "FROM seats " +
                            "WHERE show_id = ?";
        seatsStmt = conn.prepareStatement(seatsQuery);
        seatsStmt.setInt(1, Integer.parseInt(showId));
        rsSeats = seatsStmt.executeQuery();
        Map<String, Map<Integer, Boolean>> seatMap = new HashMap<>();
        Map<String, String> seatNoMap = new HashMap<>();
        while (rsSeats.next()) {
            String seatRow = rsSeats.getString("row");
            int seatNumber = rsSeats.getInt("seat_number");
            String seatNo = rsSeats.getString("seat_no");
            boolean isAvailable = rsSeats.getBoolean("is_available");
            seatNoMap.put(seatRow + "_" + seatNumber, seatNo);
            Map<Integer, Boolean> seats = seatMap.get(seatRow);
            if (seats == null) {
                seats = new HashMap<>();
                seatMap.put(seatRow, seats);
            }
            seats.put(seatNumber, isAvailable);
        }

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Seats for <%= movieTitle %></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .seat-button {
            width: 40px;
            height: 40px;
            border-radius: 4px;
            border: 2px solid #333;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background-color 0.3s, border-color 0.3s;
        }
        .available-seat {
            border-color: #388E3C;
            color: #388E3C;
        }
        .unavailable-seat {
            background-color: #d9dbde;
            border:none;
            color: #fff;
          cursor:default;
        }
        .selected-seat {
            background-color: #388E3C;
            color:white ;
             border-color: #388E3C;
        }
    </style>
    <script>
        $(document).ready(function() {
            const seatPrice = parseFloat($('#seatPrice').val());

            function updateTotalAmount() {
                let selectedSeats = $('.selected-seat').length;
                let totalAmount = selectedSeats * seatPrice;
                $('#totalAmount').text(`Pay: ${totalAmount.toFixed(2)} Rs`);
            }

            $('.seat-button').click(function() {
                if ($(this).hasClass('available-seat') && !$(this).hasClass('disabled')) {
                    $(this).toggleClass('selected-seat');
                    updateTotalAmount();
                }
            });

            $('form').on('submit', function(event) {
                if ($('.selected-seat').length === 0) {
                    alert('Please select at least one seat.');
                    event.preventDefault();
                }
            });
        });
    </script>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col">
    <div class="bg-white text-gray-700  py-4 px-6 border-b w-full ">
        <div class="container mx-auto flex justify-between items-center">
         <div class="text-lg">
            <h1 class="text-m font-semibold"><%= movieTitle %></h1>
                <p class="text-xs" ><span ></span> <%= theaterName %> | <span>Show Time:</span> <%= showTime %></p>
            </div>
        </div>
    </div>

<div class = "flex items-center justify-center w-full ">
    <div class="flex  items-center justify-center  mb-10">
        <div class="container w-full bg-white shadow-lg rounded-lg p-8 mt-4">
        <div>
            <h3 class="text-xl font-semibold text-gray-800 mb-4">Select Your Seats:</h3>
            <form action="ConfirmBooking.jsp" method="POST">

                <input type="hidden" name="show_id" value="<%= showId %>">
                <input type="hidden" name="movie_id" value="<%= movieId %>">
                <input type="hidden" name="movie_title" value="<%= movieTitle %>">
                <input type="hidden" id="selectedSeats" name="selected_seats">
                <input type="hidden" id="seatPrice" value="<%= seatPrice %>">

                <div class="space-y-3">
                    <% for (Map.Entry<String, Map<Integer, Boolean>> rowEntry : seatMap.entrySet()) {
                        String row = rowEntry.getKey();
                        Map<Integer, Boolean> seats = rowEntry.getValue();
                    %>
                    <div class="flex items-center mb-4">
                        <span class="mr-6 text-lg font-medium text-gray-700"><%= row %></span>
                        <div class="grid grid-cols-12 gap-2">
                            <% for (int i = 1; i <= seats.size(); i++) {
                                boolean isAvailable = seats.getOrDefault(i, false);
                                String seatId = row + "_" + i;
                                String seatNo = seatNoMap.get(seatId);
                            %>
                            <button type="button" class="seat-button
                                    <% if (isAvailable) { %> available-seat <% } else { %> unavailable-seat disabled <% } %>" data-seat-id="<%= seatNo %>">
                                <%= i %>
                            </button>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                    </div>
                </div>

        <div class="flex justify-center mt-6 ">
            <svg width="260" height="100" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 260 100">
              <!-- Screen Base -->
              <rect x="10" y="20" width="240" height="60" fill="rgba(255, 255, 255, 0.8)" stroke="black" stroke-width="2" />
              <!-- Stand -->
              <rect x="115" y="80" width="30" height="10" fill="black" />
              <!-- Base -->
              <rect x="90" y="90" width="80" height="5" fill="black" />
            </svg>
        </div>

         <div class="flex justify-center  ">
                   <p>All eyes this way please!</P>
          </div>
                <div class="text-xl font-semibold text-gray-800 mb-2 mt-4" id="totalAmount">Pay: 0.00 Rs</div>
                <button type="submit" class="bg-green-600 mt-5 text-white font-semibold py-2 px-6 rounded-lg hover:bg-green-700 transition duration-300">
                    Confirm Booking
                </button>
            </form>
        </div>
    </div> </div>

    <script>
        document.querySelector('form').addEventListener('submit', function() {
            let selectedSeats = [];
            document.querySelectorAll('.selected-seat').forEach(function(button) {
                selectedSeats.push(button.getAttribute('data-seat-id'));
            });
            document.getElementById('selectedSeats').value = selectedSeats.join(',');
        });
    </script>
</body>
</html>

<%
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    } finally {
        if (rsSeats != null) try { rsSeats.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (seatsStmt != null) try { seatsStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (rsShow != null) try { rsShow.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (showStmt != null) try { showStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
