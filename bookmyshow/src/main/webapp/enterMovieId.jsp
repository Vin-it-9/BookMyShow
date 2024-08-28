<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Enter Movie ID</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 flex items-center justify-center h-screen">

<div class="bg-white p-6 rounded-lg shadow-md w-1/3">
    <h2 class="text-2xl font-bold mb-4 text-center">Edit Movie</h2>
    <form action="EditMovieServlet" method="get" class="space-y-4">
        <div>
            <label for="movie_id" class="block text-gray-700 text-sm font-bold mb-2">Enter Movie ID</label>
            <input type="text" name="movie_id" id="movie_id" required
                   class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
        </div>
        <div class="flex justify-center">
            <button type="submit" class="bg-blue-500 text-white hover:bg-blue-700 px-4 py-2 rounded">
                Fetch Movie Details
            </button>
        </div>
    </form>
</div>

</body>
</html>
