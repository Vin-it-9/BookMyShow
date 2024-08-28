import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
@WebFilter("/*")
public class URLRewriteFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();

        if (uri.endsWith("login") || uri.endsWith("register") || uri.endsWith("logout")) {
            chain.doFilter(request, response);
            return;
        }

        if (uri.endsWith("index")) {
            RequestDispatcher dispatcher = httpRequest.getRequestDispatcher("/index.jsp");
            dispatcher.forward(request, response);
        } else if (uri.endsWith("Add-Movie")) {
            RequestDispatcher dispatcher = httpRequest.getRequestDispatcher("/add_movies.jsp");
            dispatcher.forward(request, response);
        } else if (uri.endsWith("log-in")) {
            RequestDispatcher dispatcher = httpRequest.getRequestDispatcher("/login.jsp");
            dispatcher.forward(request, response);
        }
        else if (uri.endsWith("sign-up")) {
            RequestDispatcher dispatcher = httpRequest.getRequestDispatcher("/register.jsp");
            dispatcher.forward(request, response);
        }
        else if (uri.endsWith("Add-Cast")) {
            RequestDispatcher dispatcher = httpRequest.getRequestDispatcher("/addCast.jsp");
            dispatcher.forward(request, response);
        } else if (uri.endsWith("All-Users")) {
            RequestDispatcher dispatcher = httpRequest.getRequestDispatcher("/alluser.jsp");
            dispatcher.forward(request, response); }
        else if (uri.endsWith("Delete-movie")) {
                RequestDispatcher dispatcher = httpRequest.getRequestDispatcher("/deletemovie.jsp");
                dispatcher.forward(request, response);
        } else {
            // Continue with the filter chain if no match
            chain.doFilter(request, response);
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void destroy() {

    }
}
