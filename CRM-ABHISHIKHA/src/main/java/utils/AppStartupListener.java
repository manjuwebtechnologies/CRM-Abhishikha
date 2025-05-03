package utils;

import java.io.File;
import java.io.IOException;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppStartupListener implements ServletContextListener {

    private Process rasaProcess;
    private Process actionProcess;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            File workingDir = new File("C:\\Users\\bobya\\rasa_env");

            // Start Rasa HTTP server directly via Python executable
            ProcessBuilder rasaPb = new ProcessBuilder(
                "C:\\Users\\bobya\\rasa_env\\Scripts\\python.exe",
                "-m", "rasa", "run", "--enable-api", "--cors", "*"
            );
            rasaPb.directory(workingDir);
            rasaPb.redirectErrorStream(true);
            rasaProcess = rasaPb.start();

            // Start Rasa action server
            ProcessBuilder actionPb = new ProcessBuilder(
                "C:\\Users\\bobya\\rasa_env\\Scripts\\python.exe",
                "-m", "rasa_sdk", "--actions", "actions"
            );
            actionPb.directory(workingDir);
            actionPb.redirectErrorStream(true);
            actionProcess = actionPb.start();

            System.out.println("✅ Rasa servers started.");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            if (rasaProcess != null && rasaProcess.isAlive()) {
                rasaProcess.destroy();
                System.out.println("🛑 Rasa HTTP server stopped.");
            }
            if (actionProcess != null && actionProcess.isAlive()) {
                actionProcess.destroy();
                System.out.println("🛑 Rasa action server stopped.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
