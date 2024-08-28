<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Ticket Booking</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">
    <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-sm">
        <h1 class="text-2xl font-bold mb-4">Login</h1>
        <%
            String error = request.getParameter("error");
            if (error != null) {
        %>
        <p class="text-red-500 mb-4"><%= error %></p>
        <%
            }
        %>
        <form action="login" method="post">
            <div class="mb-4">
                <label for="usernameOrEmail" class="block text-gray-700">Username or Email</label>
                <input type="text" id="usernameOrEmail" name="usernameOrEmail" class="mt-1 block w-full border border-gray-300 rounded-lg p-2" required>
            </div>
            <div class="mb-4">
                <label for="password" class="block text-gray-700">Password</label>
                <input type="password" id="password" name="password" class="mt-1 block w-full border border-gray-300 rounded-lg p-2" required>
            </div>
            <button type="submit" class="w-full bg-blue-500 text-white py-2 px-4 rounded">Login</button>
        </form>
        <p class="mt-4 text-gray-600">
            Don't have an account?
            <a href="sign-up" class="text-blue-500 hover:text-blue-700 font-semibold">Register here</a>
        </p>
    </div>
</body>
</html>
