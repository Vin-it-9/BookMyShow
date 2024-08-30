<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.itextpdf.text.Document" %>
<%@ page import="com.itextpdf.text.DocumentException" %>
<%@ page import="com.itextpdf.text.Paragraph" %>
<%@ page import="com.itextpdf.text.Font" %>
<%@ page import="com.itextpdf.text.FontFactory" %>
<%@ page import="com.itextpdf.text.BaseColor" %>
<%@ page import="com.itextpdf.text.pdf.PdfWriter" %>
<%@ page import="com.itextpdf.text.pdf.PdfPTable" %>
<%@ page import="com.itextpdf.text.pdf.PdfPCell" %>

<%
    String jdbcURL = "jdbc:mysql://localhost:3306/book"; // replace with your database URL
    String jdbcUsername = "root";
    String jdbcPassword = "root";

    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    try {
        Class.forName("com.mysql.jdbc.Driver"); // Make sure to use the correct JDBC driver class
        connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        statement = connection.createStatement();
        resultSet = statement.executeQuery("SELECT * FROM movies");

        String pdfRequest = request.getParameter("download");
        if ("pdf".equalsIgnoreCase(pdfRequest)) {
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=all_movies.pdf");

            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
            document.add(new Paragraph("Movies Information", titleFont));
            document.add(new Paragraph(" ")); // Empty line

            PdfPTable table = new PdfPTable(7);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10f);
            table.setSpacingAfter(10f);

            PdfPCell header1 = new PdfPCell(new Paragraph("Movie ID"));
            PdfPCell header2 = new PdfPCell(new Paragraph("Title"));
            PdfPCell header3 = new PdfPCell(new Paragraph("Genre"));
            PdfPCell header4 = new PdfPCell(new Paragraph("Duration"));
            PdfPCell header5 = new PdfPCell(new Paragraph("Rating"));
            PdfPCell header6 = new PdfPCell(new Paragraph("Language"));
            PdfPCell header7 = new PdfPCell(new Paragraph("Release Date"));

            header1.setBackgroundColor(BaseColor.LIGHT_GRAY);
            header1.setPadding(8);
            header2.setBackgroundColor(BaseColor.LIGHT_GRAY);
            header2.setPadding(8);
            header3.setBackgroundColor(BaseColor.LIGHT_GRAY);
            header3.setPadding(8);
            header4.setBackgroundColor(BaseColor.LIGHT_GRAY);
            header4.setPadding(8);
            header5.setBackgroundColor(BaseColor.LIGHT_GRAY);
            header5.setPadding(8);
            header6.setBackgroundColor(BaseColor.LIGHT_GRAY);
            header6.setPadding(8);
            header7.setBackgroundColor(BaseColor.LIGHT_GRAY);
            header7.setPadding(8);

            table.addCell(header1);
            table.addCell(header2);
            table.addCell(header3);
            table.addCell(header4);
            table.addCell(header5);
            table.addCell(header6);
            table.addCell(header7);

            while (resultSet.next()) {
                table.addCell(resultSet.getString("movie_id"));
                table.addCell(resultSet.getString("title"));
                table.addCell(resultSet.getString("genre"));
                table.addCell(resultSet.getString("duration"));
                table.addCell(resultSet.getString("rating"));
                table.addCell(resultSet.getString("language"));
                table.addCell(resultSet.getString("release_date").toString());
            }

            document.add(table);
            document.close();
            return;
        }

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (resultSet != null) try { resultSet.close(); } catch (SQLException e) {}
        if (statement != null) try { statement.close(); } catch (SQLException e) {}
        if (connection != null) try { connection.close(); } catch (SQLException e) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Movies</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-50">
    <div class="container mx-auto px-4 py-8 pl-32 pr-32 mt-5">
        <h1 class="text-3xl font-bold text-start text-gray-800 mb-8">All Movies</h1>

        <div class="flex justify-start mb-6">
            <a href="allmovie.jsp?download=pdf" class="inline-block bg-blue-600 text-white py-2 px-5 rounded-lg shadow hover:bg-blue-700 transition duration-200">
                Download PDF
            </a>
        </div>

        <div class="bg-white shadow-md rounded-lg overflow-hidden">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-blue-600">
                    <tr>
                        <th class="py-4 px-6 text-left text-sm font-semibold text-white uppercase tracking-wider">Movie ID</th>
                        <th class="py-4 px-6 text-left text-sm font-semibold text-white uppercase tracking-wider">Title</th>
                        <th class="py-4 px-6 text-left text-sm font-semibold text-white uppercase tracking-wider">Genre</th>
                        <th class="py-4 px-6 text-left text-sm font-semibold text-white uppercase tracking-wider">Duration</th>
                        <th class="py-4 px-6 text-left text-sm font-semibold text-white uppercase tracking-wider">Rating</th>
                        <th class="py-4 px-6 text-left text-sm font-semibold text-white uppercase tracking-wider">Language</th>
                        <th class="py-4 px-6 text-left text-sm font-semibold text-white uppercase tracking-wider">Release Date</th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    <%
                        try {
                            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
                            statement = connection.createStatement();
                            resultSet = statement.executeQuery("SELECT * FROM movies");

                            while (resultSet.next()) {
                    %>
                    <tr class="hover:bg-gray-100 transition duration-150">
                        <td class="py-4 px-6 text-sm font-medium text-gray-900"><%= resultSet.getString("movie_id") %></td>
                        <td class="py-4 px-6 text-sm font-medium text-gray-900"><%= resultSet.getString("title") %></td>
                        <td class="py-4 px-6 text-sm font-medium text-gray-900"><%= resultSet.getString("genre") %></td>
                        <td class="py-4 px-6 text-sm font-medium text-gray-900"><%= resultSet.getString("duration") %></td>
                        <td class="py-4 px-6 text-sm font-medium text-gray-900"><%= resultSet.getString("rating") %></td>
                        <td class="py-4 px-6 text-sm font-medium text-gray-900"><%= resultSet.getString("language") %></td>
                        <td class="py-4 px-6 text-sm font-medium text-gray-900"><%= resultSet.getString("release_date") %></td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("Error: " + e.getMessage());
                        } finally {
                            if (resultSet != null) try { resultSet.close(); } catch (SQLException e) {}
                            if (statement != null) try { statement.close(); } catch (SQLException e) {}
                            if (connection != null) try { connection.close(); } catch (SQLException e) {}
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
