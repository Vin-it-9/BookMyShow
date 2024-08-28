<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Ticket Booking</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100">
    <!-- Navbar -->
    <nav class="bg-blue-600 p-4">
        <div class="container mx-auto flex justify-between items-center">
            <a href="index.jsp" class="text-white text-2xl font-bold">Ticket Booking</a>
            <div>
                <a href="new.jsp" class="text-white hover:text-gray-200 mx-2">Movies</a>
                <%
                    if (session != null && session.getAttribute("role") != null) {
                        String role = (String) session.getAttribute("role");
                        if ("admin".equals(role)) {
                %>
                <!-- Admin-specific links -->
                <a href="add_movies.jsp" class="text-white hover:text-gray-200 mx-2">Add Movies</a>
                <a href="addCast.jsp" class="text-white hover:text-gray-200 mx-2">Add Cast</a>
                <a href="admin_dashboard.jsp" class="text-white hover:text-gray-200 mx-2">Admin Dashboard</a>
                <%
                        }
                %>
                <!-- Logout Form -->
                <form action="logout" method="post" style="display:inline;">
                    <button type="submit" class="bg-red-500 text-white hover:bg-red-700 px-4 py-2 rounded">Logout</button>
                </form>
                <%
                    } else {
                %>
                <a href="login.jsp" class="bg-blue-500 text-white hover:bg-blue-700 px-4 py-2 rounded">Login</a>
                <%
                    }
                %>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container mx-auto px-4 py-6">
        <div class="flex-grow">
            <h3 class="text-lg font-semibold text-gray-800 text-2xl font-bold">
                <%
                    if (session != null && session.getAttribute("username") != null) {
                        String username = (String) session.getAttribute("username");
                %>
                Welcome, <%= username %>
                <%
                    } else {
                %>
                Welcome, Guest
                <%
                    }
                %>
            </h3>

            <!-- Admin Dashboard Section -->
            <%
                if (session != null && session.getAttribute("role") != null) {
                    String role = (String) session.getAttribute("role");
                    if ("admin".equals(role)) {
            %>
            <div class="mt-6 bg-white shadow-md rounded p-6">
                <h2 class="text-2xl font-bold text-gray-800">Admin Dashboard</h2>
                <div class="mt-4">
                    <p class="text-gray-600">Manage movies, cast, and other admin-related tasks from here.</p>
                    <div class="mt-4">
                        <a href="add_movies.jsp" class="bg-blue-500 text-white hover:bg-blue-700 px-4 py-2 rounded">Add Movies</a>
                        <a href="addCast.jsp" class="bg-blue-500 text-white hover:bg-blue-700 px-4 py-2 rounded ml-2">Add Cast</a>
                    </div>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>
</body>
</html>
