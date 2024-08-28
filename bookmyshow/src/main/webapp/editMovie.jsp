<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Movie</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 flex items-center justify-center p-20">

<div class="bg-white p-6 rounded-lg shadow-md w-1/2">
    <h2 class="text-2xl font-bold mb-4 text-center">Edit Movie Details</h2>

    <form action="EditMovieServlet" method="post" class="space-y-4">
        <!-- Hidden input to pass the movie_id -->
        <input type="hidden" name="movie_id" value="<%= request.getAttribute("movieId") %>">

        <div>
            <label for="title" class="block text-gray-700 text-sm font-bold mb-2">Title</label>
            <input type="text" name="title" value="<%= request.getAttribute("title") %>" required
                   class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
        </div>

        <div>
            <label for="genre" class="block text-gray-700 text-sm font-bold mb-2">Genre</label>
            <input type="text" name="genre" value="<%= request.getAttribute("genre") %>"
                   class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
        </div>

        <div>
            <label for="duration" class="block text-gray-700 text-sm font-bold mb-2">Duration (minutes)</label>
            <input type="number" name="duration" value="<%= request.getAttribute("duration") %>"
                   class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
        </div>

        <div>
            <label for="rating" class="block text-gray-700 text-sm font-bold mb-2">Rating</label>
            <input type="text" name="rating" value="<%= request.getAttribute("rating") %>"
                   class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
        </div>

        <div>
            <label for="language" class="block text-gray-700 text-sm font-bold mb-2">Language</label>
            <input type="text" name="language" value="<%= request.getAttribute("language") %>"
                   class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
        </div>

        <div>
            <label for="release_date" class="block text-gray-700 text-sm font-bold mb-2">Release Date</label>
            <input type="date" name="release_date" value="<%= request.getAttribute("release_date") %>"
                   class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
        </div>

        <div>
            <label for="description" class="block text-gray-700 text-sm font-bold mb-2">Description</label>
            <textarea name="description" rows="4" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"><%= request.getAttribute("description") %></textarea>
        </div>

        <div>
            <label for="poster_url" class="block text-gray-700 text-sm font-bold mb-2">Poster URL</label>
            <input type="text" name="poster_url" value="<%= request.getAttribute("poster_url") %>"
                   class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
        </div>

        <div>
            <label for="trailer_url" class="block text-gray-700 text-sm font-bold mb-2">Trailer URL</label>
            <input type="text" name="trailer_url" value="<%= request.getAttribute("trailer_url") %>"
                   class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
        </div>

        <div>
            <label for="image_url" class="block text-gray-700 text-sm font-bold mb-2">Image URL</label>
            <input type="text" name="image_url" value="<%= request.getAttribute("image_url") %>"
                   class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
        </div>

        <div class="flex justify-center">
            <button type="submit" class="bg-green-500 text-white hover:bg-green-700 px-4 py-2 rounded">
                Update Movie
            </button>
        </div>
    </form>
</div>

</body>
</html>
