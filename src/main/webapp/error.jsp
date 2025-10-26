<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Erreur</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body>
<div class="login-wrapper">
    <div class="login-card text-center">
        <div class="tagline-chip">Itinéraire interrompu</div>
        <h2 class="mt-3">Oups 😬</h2>
        <p class="text-muted">Une erreur est survenue pendant la visite de nos showrooms numériques.</p>
        <div class="image-placeholder is-compact mx-auto mb-4" style="max-width:120px;" role="img" aria-label="Point de chute - Paris">
            <span class="placeholder-label">PARIS</span>
        </div>
        <a class="btn-soft justify-content-center w-100" href="home">Retour à l'accueil</a>
    </div>
</div>
</body>
</html>
