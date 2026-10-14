# Java Lab & Exam Portal

The project includes a **local-only portal** that runs on this PC. It stores users, exercises, submissions, and audit records in a SQLite file on disk; login and Java execution are handled by the local Node.js service. The local portal does not require Google Cloud, Google Sheets, Render, or an internet-facing server.

## Run locally on Windows

Requirements:

- Node.js 22.13 or newer
- Java 17 (the launcher selects an installed `jdk-17` under `C:\Program Files\Java`)

From PowerShell in the project folder:

```powershell
.\run-local.ps1
```

Open the URL printed by the script (default `http://127.0.0.1:3002`). Keep the PowerShell window open while using the portal. Press Ctrl+C to stop it.

On first start, the app creates `execution-service\data\portal.sqlite`, seeds a Java exercise, and creates a local administrator. The one-time admin password is printed in that first-run PowerShell window. Save it before closing the window. Students can sign up from the Student tab; faculty can self-register with a name, department, email, and password from the Faculty tab. Faculty accounts use bcrypt password hashes; existing student and administrator accounts keep their scrypt hashes. Student registration number is optional. Student and faculty accounts open separate dashboards after sign-in. Faculty and administrators can create, edit, schedule, publish, and archive labs/exams, monitor timed exam sessions, review submissions, scan for possible code similarity, and export a CSV report. Login sessions end when the service stops.

Exam opening/closing times and durations are enforced on the local server. Exam sessions resume with the same server-side timer and close on submission or timeout. Repeated focus/visibility changes (five events) lock that local exam session. This is a basic, transparent monitoring aid—not reliable identity verification or production-grade proctoring.

To choose the first administrator account yourself, set `LOCAL_ADMIN_EMAIL` and `LOCAL_ADMIN_PASSWORD` before first start. The password must be 8-128 characters. To use a different database file, set `LOCAL_DATABASE_PATH`. Keep the database file local and back it up if its records matter.

## Data and privacy

- The SQLite database is stored on this computer and excluded from Git.
- The local service binds to `127.0.0.1`, not the network.
- The local UI uses its own HTML, CSS, and JavaScript files without remote CDN assets.
- Public test output is shown to students; private test inputs and expected output stay server-side.
- Java execution is restricted with the JDK 17 Security Manager policy and resource/time limits. This is not equivalent to a production-grade isolated sandbox; do not expose it to untrusted network traffic.

The `apps-script/` and `src/gs/` folders are the previous Google Apps Script implementation and are not used by the local launcher.
