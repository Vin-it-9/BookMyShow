<%@ page import="java.util.ArrayList, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Trailers</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <script>
        function addTrailerInput() {
            var trailerDiv = document.createElement("div");
            trailerDiv.className = "trailer-field mt-4";
            trailerDiv.innerHTML = `
                <label for="trailer_url" class="block text-gray-700 font-semibold mb-2">Trailer URL:</label>
                <input type="text" name="trailer_url" required placeholder="Enter trailer URL" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
            `;
            document.getElementById("trailersContainer").appendChild(trailerDiv);
        }
    </script>
</head>
<body class="bg-gray-100 p-10">
    <div class="max-w-xl mx-auto bg-white shadow-lg rounded-lg p-8">
        <h1 class="text-4xl font-bold mb-6 text-center text-blue-600">Add Trailers</h1>

        <!-- Form for adding trailers -->
        <form action="AddTrailersServlet" method="post" class="space-y-6">
            <div>
                <label for="movie_id" class="block text-gray-700 font-semibold mb-2">Movie ID:</label>
                <input type="number" id="movie_id" name="movie_id" required placeholder="Enter movie ID" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>

            <div id="trailersContainer">
                <!-- First trailer URL input -->
                <div class="trailer-field">
                    <label for="trailer_url" class="block text-gray-700 font-semibold mb-2">Trailer URL:</label>
                    <input type="text" name="trailer_url" required placeholder="Enter trailer URL" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
            </div>

            <!-- Button to add more trailer input fields -->
            <button type="button" onclick="addTrailerInput()" class="w-full bg-gray-500 text-white font-bold py-3 rounded-lg hover:bg-gray-700 transition duration-300">
                Add More Trailers
            </button>

            <!-- Submit Button -->
            <button type="submit" class="w-full bg-blue-600 text-white font-bold py-3 rounded-lg hover:bg-blue-700 transition duration-300">
                Submit Trailers
            </button>
        </form>
    </div>
</body>
</html>
