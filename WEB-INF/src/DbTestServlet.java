import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/dbtest")
public class DbTestServlet extends HttpServlet {

    private static final String URL =
        "jdbc:mysql://localhost:3306/harassment_db"
      + "?serverTimezone=Asia/Tokyo"
      + "&useUnicode=true&characterEncoding=utf8"
      + "&useSSL=false"
      + "&allowPublicKeyRetrieval=true";

    private static final String USER = "appuser";
    private static final String PASS = "AppPass_123!";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/plain; charset=UTF-8");

        try (PrintWriter out = resp.getWriter();
             Connection con = DriverManager.getConnection(URL, USER, PASS);
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT DATABASE(), NOW()")) {

            rs.next();
            out.println("DB接続OK!");
            out.println("DATABASE() = " + rs.getString(1));
            out.println("NOW() = " + rs.getString(2));

        } catch (Exception e) {
            throw new ServletException("DB接続失敗: " + e.getMessage(), e);
        }
    }
}
