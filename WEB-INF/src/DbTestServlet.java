import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.naming.InitialContext;

public class DbTestServlet extends HttpServlet {

    private static final String PROPS_NAME = "db.properties";
    private static final String JNDI_PREFIX = "java:comp/env/";

    private static final Properties PROPS = loadProps();
    private static final String URL = readProp("db.url", "");
    private static final String USER = readProp("db.user", "");
    private static final String PASS = readJndi("db.password", readProp("db.password", ""));

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/plain; charset=UTF-8");

        if (URL.isEmpty() || USER.isEmpty()) {
            throw new ServletException("db.properties の db.url / db.user を設定してください。");
        }

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

    private static Properties loadProps() {
        Properties p = new Properties();
        try (InputStream in = DbTestServlet.class.getClassLoader().getResourceAsStream(PROPS_NAME)) {
            if (in != null) {
                p.load(in);
            }
        } catch (Exception ignored) {
            // 読み込み失敗時は空のまま
        }
        return p;
    }

    private static String readProp(String key, String def) {
        String v = PROPS.getProperty(key);
        if (v == null) return def;
        v = v.trim();
        return v.isEmpty() ? def : v;
    }

    private static String readJndi(String key, String def) {
        try {
            Object v = new InitialContext().lookup(JNDI_PREFIX + key);
            if (v != null) {
                String s = v.toString().trim();
                if (!s.isEmpty()) return s;
            }
        } catch (Exception ignored) {
        }
        return def;
    }
}
