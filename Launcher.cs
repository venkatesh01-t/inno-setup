using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;

[assembly: AssemblyTitle("Clinic Manager Launcher")]
[assembly: AssemblyDescription("Clinic Manager Startup and Auto-Update Orchestrator")]
[assembly: AssemblyCompany("My Company, Inc.")]
[assembly: AssemblyProduct("Clinic Manager")]
[assembly: AssemblyCopyright("Copyright © 2026 My Company, Inc.")]
[assembly: AssemblyFileVersion("1.0.0.0")]
[assembly: AssemblyVersion("1.0.0.0")]

namespace ClinicManager
{
    internal static class Program
    {
        [STAThread]
        private static void Main(string[] args)
        {
            string appDir = AppDomain.CurrentDomain.BaseDirectory;
            string updaterPath = Path.Combine(appDir, "updater.exe");
            string appPath = Path.Combine(appDir, "app.exe");

            // 1. Run updater.exe silently in hidden mode if present
            if (File.Exists(updaterPath))
            {
                try
                {
                    var updaterPsi = new ProcessStartInfo
                    {
                        FileName = updaterPath,
                        WorkingDirectory = appDir,
                        CreateNoWindow = true,
                        UseShellExecute = true,
                        WindowStyle = ProcessWindowStyle.Hidden
                    };

                    using (var updaterProc = Process.Start(updaterPsi))
                    {
                        if (updaterProc != null)
                        {
                            updaterProc.WaitForExit(60000); // 60s watchdog
                        }
                    }
                }
                catch
                {
                    // Continue to app launch even if updater fails or is offline
                }
            }

            // 2. Launch main app.exe as a singleton (only if not already running)
            if (File.Exists(appPath))
            {
                if (!IsProcessRunning("app"))
                {
                    try
                    {
                        var appPsi = new ProcessStartInfo
                        {
                            FileName = appPath,
                            WorkingDirectory = appDir,
                            UseShellExecute = true,
                            WindowStyle = ProcessWindowStyle.Normal
                        };
                        Process.Start(appPsi);
                    }
                    catch
                    {
                        // Handle launch error
                    }
                }
            }
        }

        private static bool IsProcessRunning(string processName)
        {
            try
            {
                var processes = Process.GetProcessesByName(processName);
                return processes != null && processes.Length > 0;
            }
            catch
            {
                return false;
            }
        }
    }
}
