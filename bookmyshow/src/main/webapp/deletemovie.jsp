<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delete Movie</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 text-gray-900">

<div class="container mx-auto mt-10">
    <div class="max-w-md mx-auto bg-white shadow-md rounded px-8 py-6">
        <h2 class="text-2xl font-bold text-center text-gray-800 mb-4">Delete Movie</h2>
        <p class="text-center text-gray-600 mb-6">Please enter the movie ID and your admin password to confirm deletion.</p>

        <!-- Display error message if credentials are invalid -->
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
            <p class="text-red-500 text-center mb-4"><%= errorMessage %></p>
        <% } %>

        <form action="DeleteMovieServlet" method="post" class="space-y-4">
            <!-- Movie ID Input -->
            <div>
                <label for="movie_id" class="block text-sm font-medium text-gray-700">Movie ID</label>
                <input type="text" name="movie_id" id="movie_id" required
                       class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500">
            </div>

            <!-- Password Input -->
            <div>
                <label for="password" class="block text-sm font-medium text-gray-700">Admin Password</label>
                <input type="password" name="password" id="password" required
                       class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500">
            </div>

            <div class="flex items-center justify-between">
                <a href="index.jsp" class="text-blue-500 hover:text-blue-700">Cancel</a>
                <button type="submit" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-700">Confirm Delete</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>
