<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Cast</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 p-10">
    <div class="max-w-xl mx-auto bg-white shadow-lg rounded-lg p-8">
        <h1 class="text-4xl font-bold mb-6 text-center text-blue-600">Add Cast Member</h1>
        <form action="AddCastServlet" method="post" class="space-y-6">
            <div>
                <label for="movie_id" class="block text-gray-700 font-semibold mb-2">Movie ID:</label>
                <input type="number" id="movie_id" name="movie_id" required placeholder="Enter movie ID" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <div>
                <label for="name" class="block text-gray-700 font-semibold mb-2">Name:</label>
                <input type="text" id="name" name="name" required placeholder="Enter cast member name" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <div>
                <label for="role" class="block text-gray-700 font-semibold mb-2">Role:</label>
                <input type="text" id="role" name="role" required placeholder="Enter cast member role" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <div>
                <label for="profile_image_url" class="block text-gray-700 font-semibold mb-2">Profile Image URL:</label>
                <input type="text" id="profile_image_url" name="profile_image_url" required placeholder="e.g., https://example.com/profile.jpg" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <button type="submit" class="w-full bg-blue-600 text-white font-bold py-3 rounded-lg hover:bg-blue-700 transition duration-300">Add Cast</button>
        </form>
    </div>
</body>
</html>
