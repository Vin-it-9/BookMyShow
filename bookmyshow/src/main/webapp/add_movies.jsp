<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Movie</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>

<body class="p-10">
    <h1 class="text-3xl font-bold mb-5">Add New Movie</h1>
    <form action="AddMovieServlet" method="post">
        <div class="mb-4">
            <label class="block text-gray-700">Title:</label>
            <input type="text" name="title" class="mt-1 block w-full border border-gray-300 rounded-md p-2">
        </div>
        <div class="mb-4">
            <label class="block text-gray-700">Genre:</label>
            <input type="text" name="genre" class="mt-1 block w-full border border-gray-300 rounded-md p-2">
        </div>
        <div class="mb-4">
            <label class="block text-gray-700">Duration (minutes):</label>
            <input type="number" name="duration" class="mt-1 block w-full border border-gray-300 rounded-md p-2">
        </div>
        <div class="mb-4">
            <label class="block text-gray-700">Rating:</label>
            <input type="text" name="rating" class="mt-1 block w-full border border-gray-300 rounded-md p-2">
        </div>
        <div class="mb-4">
            <label class="block text-gray-700">Language:</label>
            <input type="text" name="language" class="mt-1 block w-full border border-gray-300 rounded-md p-2">
        </div>
        <div class="mb-4">
            <label class="block text-gray-700">Release Date:</label>
            <input type="date" name="release_date" class="mt-1 block w-full border border-gray-300 rounded-md p-2">
        </div>
        <div class="mb-4">
            <label class="block text-gray-700">Description:</label>
            <textarea name="description" class="mt-1 block w-full border border-gray-300 rounded-md p-2"></textarea>
        </div>
        <div class="mb-4">
            <label class="block text-gray-700">Poster URL:</label>
            <input type="text" name="poster_url" class="mt-1 block w-full border border-gray-300 rounded-md p-2">
        </div>
         <div class="mb-4">
            <label class="block text-gray-700">Image URL:</label>
            <input type="text" name="image_url" class="mt-1 block w-full border border-gray-300 rounded-md p-2">
         </div>
        <div class="mb-4">
            <label class="block text-gray-700">Trailer URL:</label>
            <input type="text" name="trailer_url" class="mt-1 block w-full border border-gray-300 rounded-md p-2">
        </div>
        <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded-md">Add Movie</button>
    </form>
</body>
</html>