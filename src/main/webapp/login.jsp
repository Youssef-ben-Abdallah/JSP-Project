<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Connexion Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap-lite.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body>
<div class="login-wrapper">
    <div class="login-card">
        <div class="text-center mb-4">
            <div class="tagline-chip">Espace sécurisé</div>
            <h3 class="mt-3">Administration MyShop</h3>
            <p class="text-muted">Retrouvez vos vitrines virtuelles réparties entre nos studios de Paris, Lille et Bordeaux.</p>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/login" class="mb-3">
            <div class="mb-3">
                <label class="form-label">Username</label>
                <input class="form-control" type="text" name="username" required />
            </div>
            <div class="mb-3">
                <label class="form-label">Password</label>
                <input class="form-control" type="password" name="password" required />
            </div>
            <button class="btn-soft w-100 justify-content-center" type="submit">Se connecter</button>
        </form>
        <%
            Object error = request.getAttribute("error");
            if (error != null) {
        %>
        <div class="alert-soft text-center"><%= error %></div>
        <%
            }
        %>
        <div class="placeholder-banner mt-4" role="img" aria-label="Studios créatifs - Paris, Lille, Bordeaux">
            Accès réservé aux curateurs de nos studios : Paris, Lille &amp; Bordeaux.
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap-lite.js"></script>
</body>
</html>
