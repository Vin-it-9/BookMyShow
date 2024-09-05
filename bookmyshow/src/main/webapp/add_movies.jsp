<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Movie</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>

<body class="bg-gray-100 p-10">
    <div class="max-w-2xl mx-auto bg-white shadow-lg rounded-lg p-8">
        <h1 class="text-4xl font-bold mb-6 text-center text-blue-600">Add New Movie</h1>
        <form action="AddMovieServlet" method="post" class="space-y-6">
            <div>
                <label class="block text-gray-700 font-semibold mb-2">Title:</label>
                <input type="text" name="title" placeholder="Enter movie title" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <div>
                <label class="block text-gray-700 font-semibold mb-2">Genre:</label>
                <input type="text" name="genre" placeholder="Enter movie genre" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-gray-700 font-semibold mb-2">Duration (minutes):</label>
                    <input type="number" name="duration" placeholder="e.g., 120" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div>
                    <label class="block text-gray-700 font-semibold mb-2">Rating:</label>
                    <input type="text" name="rating" placeholder="e.g., PG-13" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
            </div>
            <div>
                <label class="block text-gray-700 font-semibold mb-2">Language:</label>
                <input type="text" name="language" placeholder="e.g., English" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <div>
                <label class="block text-gray-700 font-semibold mb-2">Release Date:</label>
                <input type="date" name="release_date" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <div>
                <label class="block text-gray-700 font-semibold mb-2">Description:</label>
                <textarea name="description" placeholder="Enter movie description" rows="4" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-gray-700 font-semibold mb-2">Poster URL:</label>
                    <input type="text" name="poster_url" placeholder="e.g., https://example.com/poster.jpg" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div>
                    <label class="block text-gray-700 font-semibold mb-2">Image URL:</label>
                    <input type="text" name="image_url" placeholder="e.g., https://example.com/image.jpg" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
            </div>
            <div>
                <label class="block text-gray-700 font-semibold mb-2">Trailer URL:</label>
                <input type="text" name="trailer_url" placeholder="e.g., https://youtube.com/trailer" class="w-full border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <button type="submit" class="w-full bg-blue-600 text-white font-bold py-3 rounded-lg hover:bg-blue-700 transition duration-300">Add Movie</button>
        </form>
    </div>
</body>
</html>
