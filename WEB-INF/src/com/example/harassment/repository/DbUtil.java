package com.example.harassment.repository;

import javax.naming.InitialContext;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DbUtil {
    private static final String PROPS_NAME = "db.properties";
    private static final String JNDI_PREFIX = "java:comp/env/";
    private static final Properties PROPS = loadProps();

    private DbUtil() {}

    public static Connection getConnection() throws Exception {
        String url = readProp("db.url", "");
        String user = readProp("db.user", "");
        String pass = readJndi("db.password", readProp("db.password", ""));
        if (url.isEmpty() || user.isEmpty()) {
            throw new IllegalStateException("db.properties の db.url / db.user を設定してください。");
        }
        return DriverManager.getConnection(url, user, pass);
    }

    private static Properties loadProps() {
        Properties p = new Properties();
        try (InputStream in = DbUtil.class.getClassLoader().getResourceAsStream(PROPS_NAME)) {
            if (in != null) {
                p.load(in);
            }
        } catch (Exception ignored) {
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
