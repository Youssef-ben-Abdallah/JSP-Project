<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Create account</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body class="login-screen">
<div class="container" style="max-width: 520px;">
    <div class="card shadow-sm p-4">
        <div class="text-center mb-3">
            <span class="badge bg-primary-subtle text-primary fw-semibold">Welcome</span>
            <h3 class="mt-3">Create your MyShop account</h3>
            <p class="text-muted mb-0">Register to keep your cart and view your orders.</p>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/register" class="mb-3">
            <div class="mb-3">
                <label class="form-label">Username</label>
                <input class="form-control" type="text" name="username" required />
            </div>
            <div class="mb-3">
                <label class="form-label">Password</label>
                <input class="form-control" type="password" name="password" required />
            </div>
            <button class="btn btn-primary w-100" type="submit">Create account</button>
        </form>
        <p class="text-center mb-0">Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a></p>
        <%
            Object error = request.getAttribute("error");
            if (error != null) {
        %>
        <div class="alert alert-danger text-center mt-3"><%= error %></div>
        <%
            }
        %>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>
