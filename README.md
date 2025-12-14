# JSP E-Commerce Project

A JSP/Servlet e-commerce prototype packaged as a Maven WAR. It ships with product catalog browsing, detailed product pages, promotions, cart handling, and admin CRUD screens powered by a MySQL database.

## Table of Contents
- [At a Glance](#at-a-glance)
- [Tech Stack](#tech-stack)
- [Project Layout](#project-layout)
- [Key Flows](#key-flows)
- [Setup & Run](#setup--run)
- [Database](#database)
- [Seeded Credentials](#seeded-credentials)
- [Handy Commands](#handy-commands)

## At a Glance
- **Frontend:** JSP views under `src/main/webapp`, with admin pages inside `WEB-INF/admin`.
- **Controllers:** Servlets in `org.example.controller` route requests, call services, and forward to JSPs.
- **Services:** `org.example.service` wraps business logic like promotion calculations, catalog lookup, and auth helpers.
- **Repositories:** `org.example.repository` handles JDBC CRUD via a shared MySQL connection helper.
- **Filters:** Navigation data preloading and admin auth live in `org.example.filter` and `org.example.security.filter`.

## Tech Stack
- Java 17+, Maven, Jakarta Servlet/JSP 6, JSTL
- MySQL with JDBC driver
- BCrypt for password hashing readiness

## Project Layout
```
src/main/java/org/example
├── controller/        # Servlets: home, products, categories, promotions, cart, auth, dashboards
├── filter/            # Navigation data preload for requests
├── model/             # POJOs for products, categories, promotions, users, orders, cart items
├── repository/        # JDBC repositories sharing DBConnection
├── security/filter/   # Admin auth filter
├── service/           # Business logic (catalog, promotions, orders, users, storage)
└── servlet/           # File streaming (e.g., product images)

src/main/webapp
├── WEB-INF/admin/     # Admin JSPs for catalog and promotions
├── assets/            # Static assets (expected)
└── *.jsp              # Storefront JSPs (home, detail, cart, auth, etc.)
```

## Key Flows
- **Storefront:** `HomeController` lists featured products, `ProductController` serves product detail pages with promotion-aware pricing, and cart endpoints manage session cart state.
- **Admin:** CRUD flows for products, categories, sub-categories, and promotions, plus dashboard views.
- **Promotions:** `PromotionService` fetches active promotions while `PromotionDiscountCalculator` applies percentage or fixed discounts to products, selecting the best offer.
- **Security:** `AuthFilter` guards `/admin/*` routes; `NavigationDataFilter` injects navigation data (categories, promotions, cart count, current user) into requests.

## Setup & Run
1. **Install dependencies:** JDK 17+, Maven, and a running MySQL instance.
2. **Prepare the database:** Run `sql/init.sql` to create and seed the `ecommerce_db` schema.
3. **Build:** `mvn clean package` produces `target/ecommerce.war`.
4. **Deploy:** Drop the WAR into a Jakarta Servlet 6+ container (e.g., Tomcat 10.1+).
5. **Visit:** `/home` for the storefront or `/admin/products` after logging in as an admin user.

## Database
- Connection details are configured in `org.example.repository.DBConnection` for the `ecommerce_db` schema.
- Schema and seed data live in `sql/init.sql` (products, categories, promotions, users, and sample orders).

## Seeded Credentials
- **Admin:** `admin@ecommerce.com` / `admin123`
- **User:** `john.doe@example.com` / `password`

## Handy Commands
- Build: `mvn clean package`
- Run unit tests: `mvn test`
- Format (if configured): `mvn fmt:format`
