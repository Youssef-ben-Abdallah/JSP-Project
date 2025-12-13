<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Connexion Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body class="login-screen">
<div class="container" style="max-width: 520px;">
    <div class="card shadow-sm p-4">
        <div class="text-center mb-3">
            <span class="badge bg-primary-subtle text-primary fw-semibold">Espace sécurisé</span>
            <h3 class="mt-3">Administration MyShop</h3>
            <p class="text-muted mb-0">Connectez-vous pour gérer vos catégories, promotions et collections.</p>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/login" class="mb-3">
            <div class="mb-3">
                <label class="form-label">Nom d'utilisateur</label>
                <input class="form-control" type="text" name="username" required />
            </div>
            <div class="mb-3">
                <label class="form-label">Mot de passe</label>
                <input class="form-control" type="password" name="password" required />
            </div>
            <button class="btn btn-primary w-100" type="submit">Se connecter</button>
        </form>
        <%
            Object error = request.getAttribute("error");
            if (error != null) {
        %>
        <div class="alert alert-danger text-center"><%= error %></div>
        <%
            }
        %>
        <div class="placeholder-tile mt-3">Accès réservé à l'équipe merchandising</div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>
