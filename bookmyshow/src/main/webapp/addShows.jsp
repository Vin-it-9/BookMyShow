<%@ page import="java.util.ArrayList, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Movie Shows</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">

    <script>
        function addShowInput() {
            var showDiv = document.createElement("div");
            showDiv.className = "show-field mt-4 p-4 bg-gray-100 rounded-lg";
            showDiv.innerHTML = `
                <div class="mb-4">
                    <label for="theater_id" class="block text-gray-700 font-semibold">Theater ID:</label>
                    <input type="number" name="theater_id" required class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Enter theater ID">
                </div>

                <div class="mb-4">
                    <label for="show_time" class="block text-gray-700 font-semibold">Show Time:</label>
                    <input type="time" name="show_time" required class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div class="mb-4">
                    <label for="show_date" class="block text-gray-700 font-semibold">Show Date:</label>
                    <input type="date" name="show_date" required class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div class="mb-4">
                    <label for="ticket_price" class="block text-gray-700 font-semibold">Ticket Price:</label>
                    <input type="number" step="0.01" name="ticket_price" required class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Enter ticket price">
                </div>

            document.getElementById("showsContainer").appendChild(showDiv);

        }
    </script>

</head>
<body class="bg-gray-100 p-10">
    <div class="max-w-2xl mx-auto bg-white shadow-lg rounded-lg p-8">
        <h1 class="text-4xl font-bold mb-6 text-center text-blue-600">Add Movie Shows</h1>

        <form action="AddShowsServlet" method="post" class="space-y-6">
            <div class="mb-4">
                <label for="movie_id" class="block text-gray-700 font-semibold">Movie ID:</label>
                <input type="number" name="movie_id" required class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Enter movie ID">
            </div>

            <div id="showsContainer">
                <div class="show-field p-4 bg-gray-100 rounded-lg">
                    <div class="mb-4">
                        <label for="theater_id" class="block text-gray-700 font-semibold">Theater ID:</label>
                        <input type="number" name="theater_id" required class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Enter theater ID">
                    </div>

                    <div class="mb-4">
                        <label for="show_time" class="block text-gray-700 font-semibold">Show Time:</label>
                        <input type="time" name="show_time" required class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>

                    <div class="mb-4">
                        <label for="show_date" class="block text-gray-700 font-semibold">Show Date:</label>
                        <input type="date" name="show_date" required class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>

                    <div class="mb-4">
                        <label for="ticket_price" class="block text-gray-700 font-semibold">Ticket Price:</label>
                        <input type="number" step="0.01" name="ticket_price" required class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Enter ticket price">
                    </div>
                </div>
            </div>
            <button type="button" onclick="addShowInput()" class="w-full bg-gray-500 text-white font-bold py-3 rounded-lg hover:bg-gray-700 transition duration-300">
                Add More Shows
            </button>

            <button type="submit" class="w-full bg-blue-600 text-white font-bold py-3 rounded-lg hover:bg-blue-700 transition duration-300">
                Submit Shows
            </button>
        </form>
    </div>
</body>
</html>
