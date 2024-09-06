<%@ page import="java.util.ArrayList, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Theaters</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <script>
        function addTheaterInput() {
            var theaterDiv = document.createElement("div");
            theaterDiv.className = "theater-field mt-4";
            theaterDiv.innerHTML = `
                <label for="theater_name" class="block text-gray-700 font-semibold mb-2">Theater Name:</label>
                <input type="text" name="theater_name" required placeholder="Enter theater name" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
            `;
            document.getElementById("theatersContainer").appendChild(theaterDiv);
        }
    </script>
</head>
<body class="bg-gray-100 p-10">
    <div class="max-w-xl mx-auto bg-white shadow-lg rounded-lg p-8">
        <h1 class="text-4xl font-bold mb-6 text-center text-blue-600">Add Theaters</h1>

        <!-- Form for adding theaters -->
        <form action="AddTheatersServlet" method="post" class="space-y-6">
            <div>
                <label for="city" class="block text-gray-700 font-semibold mb-2">City:</label>
                <input type="text" id="city" name="city" required placeholder="Enter city name" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>

            <div id="theatersContainer">
                <!-- First theater name input -->
                <div class="theater-field">
                    <label for="theater_name" class="block text-gray-700 font-semibold mb-2">Theater Name:</label>
                    <input type="text" name="theater_name" required placeholder="Enter theater name" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
            </div>

            <!-- Button to add more theater input fields -->
            <button type="button" onclick="addTheaterInput()" class="w-full bg-gray-500 text-white font-bold py-3 rounded-lg hover:bg-gray-700 transition duration-300">
                Add More Theaters
            </button>

            <!-- Submit Button -->
            <button type="submit" class="w-full bg-blue-600 text-white font-bold py-3 rounded-lg hover:bg-blue-700 transition duration-300">
                Submit Theaters
            </button>
        </form>
    </div>
</body>
</html>
