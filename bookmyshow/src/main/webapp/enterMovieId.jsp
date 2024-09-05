<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Enter Movie ID</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">

<div class="max-w-lg mx-auto bg-white shadow-lg rounded-lg p-8">
    <h2 class="text-3xl font-bold mb-6 text-center text-blue-600">Edit Movie</h2>
    <form action="EditMovieServlet" method="get" class="space-y-6">
        <div>
            <label for="movie_id" class="block text-gray-700 font-semibold mb-2">Enter Movie ID:</label>
            <input type="text" name="movie_id" id="movie_id" required
                   placeholder="Enter the movie ID"
                   class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
        </div>
        <div class="flex justify-center">
            <button type="submit" class="w-full bg-blue-600 text-white font-bold py-2 rounded-lg hover:bg-blue-700 transition duration-300">
                Fetch Movie Details
            </button>
        </div>
    </form>
</div>

</body>
</html>
