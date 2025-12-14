# JSP E-Commerce Project

## Overview
This project is a JSP/Servlet-based e-commerce prototype packaged as a Maven WAR. It provides catalog browsing, product detail pages, promotions, basic cart handling, and administrative CRUD screens for products, categories, and promotions backed by a MySQL database initialized via `sql/init.sql`. Core dependencies include Jakarta Servlet/JSP APIs, JSTL, the MySQL JDBC driver, and BCrypt for password hashing readiness. 【F:pom.xml†L1-L49】【F:sql/init.sql†L1-L39】

## Application Structure
The Java code under `src/main/java` follows a layered layout:

- **Models (`org.example.model`)** define simple POJOs for domain concepts such as products, categories, sub-categories, promotions, orders, and users. Each class exposes fields with getters/setters (and in some cases convenience properties) to carry data between the database, services, and JSP views. 【F:src/main/java/org/example/model/Product.java†L1-L53】
- **Repositories (`org.example.repository`)** encapsulate JDBC access. They retrieve a connection from `DBConnection` (configured for `ecommerce_db`) and expose CRUD helpers per entity (e.g., `CategoryRepository`, `ProductRepository`, `PromotionRepository`, `UserRepository`). 【F:src/main/java/org/example/repository/DBConnection.java†L1-L13】【F:src/main/java/org/example/repository/CategoryRepository.java†L1-L63】
- **Services (`org.example.service`)** orchestrate repository calls and business rules. Examples include `ProductService` for catalog operations, `PromotionService` plus `PromotionDiscountCalculator` for pricing logic, `CategoryService`/`SubCategoryService` for navigation trees, `OrderService` for checkout data, `ImageStorageService` for upload paths, and `UserService` for authentication/authorization helpers. 【F:src/main/java/org/example/service/ProductService.java†L1-L36】【F:src/main/java/org/example/service/PromotionDiscountCalculator.java†L1-L44】
- **Web layer (`org.example.controller`)** contains servlets handling incoming requests, populating data from services, and dispatching to JSPs. `HomeController` renders the storefront home page, `ProductController` drives catalog/detail/admin product flows, while dedicated controllers manage categories, sub-categories, promotions, authentication (login/register), dashboards, user dashboards, carts, and image download responses. 【F:src/main/java/org/example/controller/HomeController.java†L1-L31】【F:src/main/java/org/example/controller/ProductController.java†L1-L162】
- **Filters (`org.example.filter`, `org.example.security.filter`)** add cross-cutting behavior. `NavigationDataFilter` preloads categories, promotions, cart counts, and session user info for all requests, skipping static assets. `AuthFilter` guards `/admin/*` routes by redirecting unauthenticated or non-admin users. 【F:src/main/java/org/example/filter/NavigationDataFilter.java†L1-L61】【F:src/main/java/org/example/security/filter/AuthFilter.java†L1-L33】

JSP views live in `src/main/webapp` (with admin pages under `WEB-INF/admin`), and `web.xml` registers servlets/filters for servlet containers. Static assets are expected under `src/main/webapp/assets` (not included by default).

## Class Responsibilities (by package)
**Model classes**
- `Product`, `Category`, `SubCategory`: hold catalog metadata and, where helpful, resolved names from JOINs. 【F:src/main/java/org/example/model/Product.java†L1-L53】
- `Promotion`: describes discount windows, targeted categories/subcategories, and discount type/value.
- `DiscountedPrice`: wraps original vs. discounted amounts plus the promotion used, enabling JSP display of savings.
- `User`: stores credentials and role for login/admin checks.
- `CartItem`, `Order`, `OrderItem`: capture shopping cart and order state for checkout flows.

**Repository classes**
- `DBConnection`: centralizes MySQL connection creation for the `ecommerce_db` schema. 【F:src/main/java/org/example/repository/DBConnection.java†L1-L13】
- `CategoryRepository`, `SubCategoryRepository`, `ProductRepository`, `PromotionRepository`, `UserRepository`, `OrderRepository`: execute SQL for listing, retrieving by id, inserting, updating, and deleting their respective entities. Methods return model objects that propagate upward. 【F:src/main/java/org/example/repository/CategoryRepository.java†L1-L63】

**Service classes**
- `ProductService`: wraps catalog queries plus mutation helpers used by admin product forms. 【F:src/main/java/org/example/service/ProductService.java†L1-L36】
- `CategoryService` & `SubCategoryService`: supply navigation-ready collections and CRUD wiring for category hierarchies.
- `PromotionService`: fetches active promotions; `PromotionDiscountCalculator` applies percentage or fixed discounts to a product, choosing the best available offer. 【F:src/main/java/org/example/service/PromotionDiscountCalculator.java†L1-L44】
- `OrderService`: coordinates `OrderRepository` for cart checkout and retrieval.
- `UserService`: handles login checks, registration, and role inspection used by filters/controllers.
- `ImageStorageService`: resolves upload directories and file paths for product images.

**Controller classes**
- `HomeController`: loads featured products and forwards to `home.jsp`. 【F:src/main/java/org/example/controller/HomeController.java†L1-L31】
- `ProductController`: handles listing, detail display with promotion calculations, and admin CRUD (including image uploads). 【F:src/main/java/org/example/controller/ProductController.java†L1-L162】
- `CategoryController`, `SubCategoryController`, `PromotionController`: admin endpoints for managing taxonomy and promotions.
- `CartController`: manages cart session state and prepares checkout pages.
- `DashboardController` & `UserDashboardController`: render admin/user landing pages with relevant data.
- `LoginController` & `RegisterController`: manage authentication and account creation flows.
- `ProductImageServlet`: streams stored product images back to clients.

**Filters**
- `NavigationDataFilter`: loads navigation categories, active promotions, cart counts, and the current user into the request scope for all non-static requests. 【F:src/main/java/org/example/filter/NavigationDataFilter.java†L1-L61】
- `AuthFilter`: restricts `/admin/*` to authenticated admin users. 【F:src/main/java/org/example/security/filter/AuthFilter.java†L1-L33】

## Running the project
1. Ensure MySQL is running and execute `sql/init.sql` to create and seed `ecommerce_db`. 【F:sql/init.sql†L1-L39】
2. Build the WAR with `mvn clean package` (requires JDK 17+). 【F:pom.xml†L11-L48】
3. Deploy the generated `ecommerce.war` to a Jakarta Servlet 6–compatible container (e.g., Tomcat 10.1+).
4. Access the site at `/home` (storefront) or `/admin/products` (admin catalog) after logging in with seeded credentials.
