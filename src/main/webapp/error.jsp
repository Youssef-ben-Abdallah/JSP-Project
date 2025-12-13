<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Error</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body class="login-screen">
<div class="container" style="max-width: 520px;">
    <div class="card shadow-sm p-4 text-center">
        <span class="badge bg-danger-subtle text-danger fw-semibold">Route interrupted</span>
        <h2 class="mt-3">Oops 😬</h2>
        <p class="text-muted">An error slipped into the journey. Head back home to restart your visit.</p>
        <div class="image-placeholder mx-auto mb-4" style="max-width:160px; height:160px;" role="img" aria-label="Landing point - New York">
            <span class="placeholder-label">NEW YORK</span>
        </div>
        <a class="btn btn-primary w-100" href="${pageContext.request.contextPath}/home">Back to home</a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>
