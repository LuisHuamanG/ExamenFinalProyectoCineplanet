<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:useBean id="hoy" class="java.util.Date"/>
<fmt:setLocale value="es_PE"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel del cajero | Cineplanet</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: 'Poppins', Arial, sans-serif;
            background: #f5f8fc;
            color: #12294f;
        }

        a {
            text-decoration: none;
        }

        /* ============ BARRA SUPERIOR ============ */
        .barra {
            position: relative;
            background: linear-gradient(90deg, #0f2550, #153466);
            border-top: 2px solid #1c2b45;
            box-shadow: 0 2px 10px rgba(15, 37, 80, 0.2);
        }

        .barra::after {
            content: "";
            position: absolute;
            left: 0;
            right: 0;
            bottom: 0;
            height: 3px;
            background: linear-gradient(90deg, #e31837, #f08c2d, #f2c230, #8bbd4b, #35aaa0, #2f7fd0, #c2336f);
        }

        .barra-in {
            max-width: 886px;
            margin: 0 auto;
            height: 52px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 7px;
            color: #ffffff;
            font-size: 17px;
            font-weight: 600;
            letter-spacing: -0.3px;
        }

        .logo svg {
            width: 30px;
            height: 30px;
        }

        .menu {
            display: flex;
            align-items: center;
            gap: 4px;
            margin-right: auto;
            margin-left: 4px;
        }

        .menu a {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 8px 11px;
            font-size: 11.5px;
            font-weight: 500;
            color: #d6e0f2;
            border-radius: 7px;
            transition: background 0.2s;
        }

        .menu a:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        .menu a.activo {
            background: #ffffff;
            color: #12294f;
            font-weight: 600;
        }

        .menu svg,
        .btn-salir svg {
            width: 14px;
            height: 14px;
            fill: none;
            stroke: currentColor;
            stroke-width: 1.8;
            stroke-linecap: round;
            stroke-linejoin: round;
            flex-shrink: 0;
        }

        .menu a.activo svg {
            stroke: #ee9a38;
        }

        .usuario {
            display: flex;
            align-items: center;
            gap: 9px;
        }

        .avatar {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 700;
            color: #ffffff;
            background: linear-gradient(135deg, #ee9a38, #d63a5c);
        }

        .usuario-datos {
            line-height: 1.25;
            color: #ffffff;
        }

        .usuario-datos strong {
            display: block;
            font-size: 11.5px;
            font-weight: 600;
        }

        .usuario-datos small {
            font-size: 9.5px;
            color: #aebbd3;
        }

        .btn-salir {
            display: flex;
            align-items: center;
            gap: 6px;
            width: auto;
            margin: 0;
            padding: 7px 11px;
            font-family: inherit;
            font-size: 11.5px;
            font-weight: 600;
            color: #ffffff;
            background: transparent;
            border: 1px solid rgba(255, 255, 255, 0.35);
            border-radius: 7px;
            cursor: pointer;
            transition: background 0.2s;
        }

        .btn-salir:hover {
            background: rgba(255, 255, 255, 0.12);
        }

        /* ============ CONTENIDO ============ */
        .contenido {
            max-width: 886px;
            margin: 22px auto 40px;
        }

        .bienvenida {
            position: relative;
            overflow: hidden;
            min-height: 167px;
            padding: 28px 32px;
            border-radius: 16px;
            color: #ffffff;
            background:
                radial-gradient(ellipse at 90% 40%, rgba(47, 127, 208, 0.75), transparent 55%),
                linear-gradient(100deg, #0d2250 0%, #12326a 55%, #1b559e 100%);
            box-shadow: 0 8px 22px rgba(15, 37, 80, 0.22);
        }

        .fecha {
            display: inline-block;
            padding: 5px 11px;
            font-size: 9.5px;
            font-weight: 600;
            background: rgba(255, 255, 255, 0.12);
            border-radius: 20px;
        }

        .bienvenida h1 {
            margin: 18px 0 8px;
            font-size: 22px;
            font-weight: 700;
            letter-spacing: -0.3px;
        }

        .bienvenida p {
            margin: 0;
            max-width: 400px;
            font-size: 11.5px;
            line-height: 1.55;
            color: #d6e0f2;
        }

        .teclas {
            position: absolute;
            top: 36px;
            right: 38px;
            width: 160px;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 7px;
            transform: rotate(-8deg);
        }

        .teclas span {
            height: 19px;
            border-radius: 6px;
        }

        .teclas span:nth-child(odd)  { transform: translateY(2px); }
        .c1 { background: #ee9a38; }
        .c2 { background: #f2cb3d; }
        .c3 { background: #8cc152; }
        .c4 { background: #3aa59d; }
        .c5 { background: #de3d5a; }
        .c6 { background: #c9306b; }

        /* ============ TARJETAS ============ */
        .modulos {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-top: 20px;
        }

        .modulo {
            display: block;
            padding: 18px 18px 20px;
            background: #ffffff;
            border-top: 4px solid #cccccc;
            border-radius: 10px;
            box-shadow: 0 6px 18px rgba(30, 60, 110, 0.08);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .modulo:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 22px rgba(30, 60, 110, 0.14);
        }

        .modulo .ico {
            width: 39px;
            height: 39px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #cccccc;
        }

        .modulo .ico svg {
            width: 19px;
            height: 19px;
            fill: none;
            stroke: #ffffff;
            stroke-width: 1.8;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .modulo h2 {
            margin: 22px 0 6px;
            font-size: 14px;
            font-weight: 700;
            color: #12294f;
        }

        .modulo p {
            margin: 0 0 18px;
            min-height: 34px;
            font-size: 11px;
            line-height: 1.5;
            color: #7a8699;
        }

        .modulo .ir {
            font-size: 11px;
            font-weight: 600;
        }

        .m-clientes  { border-top-color: #ee9a38; }
        .m-clientes .ico { background: #ee9a38; }
        .m-clientes .ir  { color: #ee9a38; }

        .m-peliculas { border-top-color: #7ba43e; }
        .m-peliculas .ico { background: #7ba43e; }
        .m-peliculas .ir  { color: #7ba43e; }

        .m-funciones { border-top-color: #3aa59d; }
        .m-funciones .ico { background: #3aa59d; }
        .m-funciones .ir  { color: #3aa59d; }

        .m-entradas  { border-top-color: #c9306b; }
        .m-entradas .ico { background: #c9306b; }
        .m-entradas .ir  { color: #c9306b; }

        /* ============ RESPONSIVE ============ */
        @media (max-width: 960px) {
            .barra-in { padding: 0 16px; flex-wrap: wrap; height: auto; padding-top: 8px; padding-bottom: 8px; }
            .menu { order: 3; width: 100%; overflow-x: auto; margin: 0; }
            .contenido { margin-left: 16px; margin-right: 16px; }
            .modulos { grid-template-columns: repeat(2, 1fr); }
            .teclas { display: none; }
        }

        @media (max-width: 520px) {
            .modulos { grid-template-columns: 1fr; }
            .usuario-datos { display: none; }
        }
    </style>
</head>

<body>

    <!-- ============ BARRA SUPERIOR ============ -->
    <header class="barra">
        <div class="barra-in">

            <a class="logo" href="${pageContext.request.contextPath}/cajero.jsp">
                <svg viewBox="0 0 52 52" aria-hidden="true">
                    <defs>
                        <clipPath id="circ"><circle cx="26" cy="26" r="22"/></clipPath>
                    </defs>
                    <circle cx="26" cy="26" r="22" fill="#2a6cc4"/>
                    <g clip-path="url(#circ)">
                        <rect x="12" y="14" width="9" height="7" rx="2" fill="#e8943a"/>
                        <rect x="23" y="12" width="9" height="7" rx="2" fill="#ecc73c"/>
                        <rect x="34" y="14" width="9" height="7" rx="2" fill="#3aa59d"/>
                        <rect x="9"  y="23" width="9" height="7" rx="2" fill="#c9306b"/>
                        <rect x="20" y="22" width="9" height="7" rx="2" fill="#8cc152"/>
                        <rect x="31" y="23" width="9" height="7" rx="2" fill="#e8943a"/>
                        <rect x="14" y="32" width="9" height="7" rx="2" fill="#de3d5a"/>
                        <rect x="25" y="32" width="9" height="7" rx="2" fill="#ecc73c"/>
                    </g>
                    <rect x="2" y="40" width="6" height="4" rx="1.5" fill="#de3d5a"/>
                    <rect x="9" y="45" width="5" height="3" rx="1.5" fill="#c9306b"/>
                </svg>
                cineplanet
            </a>

            <!-- Ajusta estas rutas a las de tus servlets/JSP -->
            <nav class="menu" aria-label="Principal">
                <a class="activo" href="${pageContext.request.contextPath}/cajero.jsp">
                    <svg viewBox="0 0 24 24"><path d="M3 11l9-8 9 8"/><path d="M5 10v10h14V10"/></svg>
                    Inicio
                </a>
                <a href="${pageContext.request.contextPath}/ClienteServlet">
                    <svg viewBox="0 0 24 24"><circle cx="9" cy="8" r="3.5"/><path d="M2.5 20v-1.5a5 5 0 0 1 5-5h3a5 5 0 0 1 5 5V20"/><path d="M16 4.5a3.5 3.5 0 0 1 0 7"/><path d="M18.5 14a5 5 0 0 1 3 4.5V20"/></svg>
                    Clientes
                </a>
                <a href="${pageContext.request.contextPath}/PeliculaServlet">
                    <svg viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><path d="M7 3v18M17 3v18M3 8h4M3 16h4M17 8h4M17 16h4M3 12h18"/></svg>
                    Películas
                </a>
                <a href="${pageContext.request.contextPath}/FuncionServlet">
                    <svg viewBox="0 0 24 24"><rect x="3.5" y="5" width="17" height="16" rx="2"/><path d="M8 3v4M16 3v4M3.5 10h17"/></svg>
                    Funciones
                </a>
                <a href="${pageContext.request.contextPath}/EntradaServlet">
                    <svg viewBox="0 0 24 24"><path d="M3 8a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v2a2 2 0 0 0 0 4v2a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-2a2 2 0 0 0 0-4z"/><path d="M12 6v12"/></svg>
                    Entradas
                </a>
            </nav>

            <div class="usuario">
                <div class="avatar" aria-hidden="true">
                    <c:out value="${fn:toUpperCase(fn:substring(sessionScope.nombre, 0, 1))}"/>
                </div>
                <div class="usuario-datos"
                     title="Usuario: ${fn:escapeXml(sessionScope.identificador)} · Rol: ${fn:escapeXml(sessionScope.rol)}">
                    <strong><c:out value="${sessionScope.nombre}"/></strong>
                    <small>Sesión activa</small>
                </div>

                <form action="${pageContext.request.contextPath}/LogoutServlet"
                      method="post">

                    <input type="hidden" name="tokenCSRF"
                           value="<%= util.ProteccionCSRF.obtenerToken(request) %>">

                    <button type="submit" class="btn-salir">
                        <svg viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><path d="M16 17l5-5-5-5"/><path d="M21 12H9"/></svg>
                        Salir
                    </button>
                </form>
            </div>

        </div>
    </header>

    <!-- ============ CONTENIDO ============ -->
    <main class="contenido">

        <section class="bienvenida">
            <span class="fecha">
                <fmt:formatDate value="${hoy}" pattern="EEEE d 'de' MMMM 'de' yyyy"/>
            </span>

            <h1>¡Hola, <c:out value="${sessionScope.nombre}"/>!</h1>

            <p>
                Bienvenido al sistema de venta de entradas.
                Elige un módulo para empezar a atender.
            </p>

            <div class="teclas" aria-hidden="true">
                <span class="c1"></span><span class="c2"></span><span class="c3"></span><span class="c4"></span>
                <span class="c5"></span><span class="c1"></span><span class="c2"></span><span class="c3"></span>
                <span class="c6"></span><span class="c5"></span><span class="c1"></span><span class="c2"></span>
                <span class="c5"></span><span class="c6"></span><span class="c1"></span><span class="c3"></span>
            </div>
        </section>

        <section class="modulos">

            <a class="modulo m-clientes" href="${pageContext.request.contextPath}/ClienteServlet">
                <div class="ico">
                    <svg viewBox="0 0 24 24"><circle cx="9" cy="8" r="3.5"/><path d="M2.5 20v-1.5a5 5 0 0 1 5-5h3a5 5 0 0 1 5 5V20"/><path d="M16 4.5a3.5 3.5 0 0 1 0 7"/><path d="M18.5 14a5 5 0 0 1 3 4.5V20"/></svg>
                </div>
                <h2>Clientes</h2>
                <p>Registrar, buscar, editar y eliminar clientes.</p>
                <span class="ir">Ir a clientes →</span>
            </a>

            <a class="modulo m-peliculas" href="${pageContext.request.contextPath}/PeliculaServlet">
                <div class="ico">
                    <svg viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><path d="M7 3v18M17 3v18M3 8h4M3 16h4M17 8h4M17 16h4M3 12h18"/></svg>
                </div>
                <h2>Películas</h2>
                <p>Administrar la cartelera y los próximos estrenos.</p>
                <span class="ir">Ir a películas →</span>
            </a>

            <a class="modulo m-funciones" href="${pageContext.request.contextPath}/FuncionServlet">
                <div class="ico">
                    <svg viewBox="0 0 24 24"><rect x="3.5" y="5" width="17" height="16" rx="2"/><path d="M8 3v4M16 3v4M3.5 10h17"/><path d="M8 14h2M14 14h2M8 17.5h2"/></svg>
                </div>
                <h2>Funciones</h2>
                <p>Programar funciones por sala, horario y precio.</p>
                <span class="ir">Ir a funciones →</span>
            </a>

            <a class="modulo m-entradas" href="${pageContext.request.contextPath}/EntradaServlet">
                <div class="ico">
                    <svg viewBox="0 0 24 24"><path d="M3 8a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v2a2 2 0 0 0 0 4v2a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-2a2 2 0 0 0 0-4z"/><path d="M12 6v12"/></svg>
                </div>
                <h2>Entradas</h2>
                <p>Vender entradas, anular y ver lo recaudado.</p>
                <span class="ir">Ir a entradas →</span>
            </a>

        </section>
    </main>

</body>
</html>
