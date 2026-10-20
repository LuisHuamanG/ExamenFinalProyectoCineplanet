<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="util.ProteccionCSRF"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar sesión | Cineplanet</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        * {
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: 'Poppins', Arial, sans-serif;
            background: #f5f8fc;
            display: flex;
        }

        /* ============ PANEL IZQUIERDO ============ */
        .panel-izq {
            position: relative;
            flex: 0 0 52.3%;
            overflow: hidden;
            color: #ffffff;
            padding: 0 40px;
            display: flex;
            flex-direction: column;
            background:
                radial-gradient(ellipse at 30% 85%, rgba(38, 110, 190, 0.55), transparent 55%),
                radial-gradient(ellipse at 20% 15%, rgba(18, 52, 110, 0.9), transparent 60%),
                linear-gradient(160deg, #0d2250 0%, #1b4f94 45%, #0f2a58 100%);
        }

        /* línea de colores inferior */
        .panel-izq::after {
            content: "";
            position: absolute;
            left: 0;
            right: 0;
            bottom: 0;
            height: 4px;
            background: linear-gradient(90deg, #e31837, #f08c2d, #f2c230, #8bbd4b, #35aaa0, #2f7fd0, #c2336f);
        }

        /* bloques decorativos */
        .bloque {
            position: absolute;
            border-radius: 12px;
            opacity: 0.95;
        }

        .b1 { width: 58px; height: 40px; background: #e8943a; top: 55px; left: 655px; transform: rotate(-22deg); width: 56px; height: 42px; left: auto; right: 70px; top: 52px; }
        .b2 { width: 46px; height: 30px; background: #3aa59d; top: 26px; right: 14px; transform: rotate(-12deg); border-radius: 9px; }
        .b3 { width: 48px; height: 32px; background: #ecc73c; top: 97px; right: 155px; transform: rotate(-14deg); border-radius: 9px; }
        .b4 { width: 50px; height: 38px; background: #8cc152; top: 112px; right: 45px; transform: rotate(-16deg); }
        .b5 { width: 38px; height: 26px; background: #c9306b; top: 160px; right: 110px; transform: rotate(-18deg); border-radius: 8px; }
        .b6 { width: 28px; height: 20px; background: #de3d5a; top: 192px; right: 180px; transform: rotate(-14deg); border-radius: 7px; }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 150px;
        }

        .logo svg {
            width: 52px;
            height: 52px;
        }

        .logo span {
            font-size: 30px;
            font-weight: 600;
            letter-spacing: -0.5px;
        }

        .hero {
            margin-top: 120px;
        }

        .hero h2 {
            margin: 0;
            font-size: 34px;
            line-height: 1.15;
            font-weight: 700;
            letter-spacing: -0.5px;
        }

        .hero h2 .resaltado {
            color: #f2b431;
        }

        .hero p {
            margin: 16px 0 0;
            max-width: 330px;
            font-size: 13.5px;
            line-height: 1.55;
            color: #d4def0;
        }

        .beneficios {
            list-style: none;
            margin: 24px 0 0;
            padding: 0;
        }

        .beneficios li {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 11px;
            font-size: 12.5px;
            font-weight: 500;
            color: #eaf0fb;
        }

        .ico {
            width: 24px;
            height: 24px;
            border-radius: 7px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
        }

        .ico.naranja { background: #f39a35; }
        .ico.verde   { background: #8cc152; }
        .ico.turq    { background: #3aa59d; }

        .copy {
            margin-top: auto;
            padding-bottom: 38px;
            font-size: 11px;
            color: rgba(212, 222, 240, 0.55);
        }

        /* ============ PANEL DERECHO ============ */
        .panel-der {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 30px;
            background: #f5f8fc;
        }

        .contenedor {
            width: 100%;
            max-width: 312px;
            background: #ffffff;
            padding: 28px 28px 30px;
            border-radius: 18px;
            box-shadow: 0 14px 40px rgba(30, 60, 110, 0.10);
        }

        h1 {
            margin: 0 0 6px;
            font-size: 21px;
            font-weight: 700;
            color: #12294f;
        }

        .descripcion {
            margin: 0 0 22px;
            font-size: 11.5px;
            color: #7a8699;
        }

        label {
            display: block;
            margin: 14px 0 6px;
            font-size: 10.5px;
            font-weight: 600;
            color: #12294f;
        }

        .campo {
            position: relative;
        }

        .campo svg {
            position: absolute;
            left: 12px;
            top: 50%;
            width: 15px;
            height: 15px;
            transform: translateY(-50%);
            stroke: #8a96a8;
            fill: none;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
            pointer-events: none;
        }

        input {
            width: 100%;
            padding: 10px 12px 10px 38px;
            font-family: inherit;
            font-size: 11.5px;
            font-weight: 500;
            color: #12294f;
            background: #f6f8fb;
            border: 1px solid #e6ebf2;
            border-radius: 8px;
        }

        input::placeholder {
            color: #8a96a8;
        }

        input:focus {
            outline: none;
            background: #ffffff;
            border-color: #2f6fd0;
            box-shadow: 0 0 0 2px rgba(47, 111, 208, 0.25);
        }

        button {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            margin-top: 22px;
            padding: 12px;
            font-family: inherit;
            font-size: 12px;
            font-weight: 600;
            color: #ffffff;
            background: #ee9a38;
            border: none;
            border-radius: 8px;
            box-shadow: 0 6px 14px rgba(238, 154, 56, 0.35);
            cursor: pointer;
            transition: background 0.2s;
        }

        button:hover {
            background: #db8626;
        }

        button svg {
            width: 13px;
            height: 13px;
            stroke: #ffffff;
            fill: none;
            stroke-width: 2.4;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .error {
            padding: 10px 12px;
            margin: 0 0 12px;
            background: #fff0f0;
            color: #a20d25;
            border: 1px solid #f2b8c0;
            border-radius: 8px;
            font-size: 12px;
        }

        /* ============ RESPONSIVE ============ */
        @media (max-width: 900px) {
            body {
                flex-direction: column;
            }

            .panel-izq {
                flex: none;
                padding: 30px 24px;
            }

            .logo { margin-top: 0; }
            .hero { margin-top: 40px; }
            .bloque { display: none; }
            .copy { margin-top: 30px; padding-bottom: 0; }
            .panel-der { padding: 40px 20px; }
        }
    </style>
</head>

<body>

    <!-- ============ PANEL IZQUIERDO ============ -->
    <section class="panel-izq" aria-hidden="false">

        <span class="bloque b1"></span>
        <span class="bloque b2"></span>
        <span class="bloque b3"></span>
        <span class="bloque b4"></span>
        <span class="bloque b5"></span>
        <span class="bloque b6"></span>

        <div class="logo">
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
            <span>cineplanet</span>
        </div>

        <div class="hero">
            <h2>Vende entradas en<br><span class="resaltado">segundos</span>, sin papeles.</h2>
            <p>
                Sistema interno para cajeros: clientes, cartelera,
                funciones y venta de entradas en un solo lugar.
            </p>

            <ul class="beneficios">
                <li><span class="ico naranja">🎟️</span> Venta con control de butacas</li>
                <li><span class="ico verde">🎬</span> Cartelera y funciones por sala</li>
                <li><span class="ico turq">📊</span> Reporte de lo recaudado</li>
            </ul>
        </div>

        <div class="copy">© Cineplanet · Acceso para personal y clientes</div>
    </section>

    <!-- ============ PANEL DERECHO ============ -->
    <main class="panel-der">
        <div class="contenedor">

            <h1>Bienvenido</h1>

            <p class="descripcion">
                Personal: usa tu usuario. Clientes: usa tu DNI.
            </p>

            <c:if test="${not empty mensaje}">
                <div class="error" role="alert">
                    <c:out value="${mensaje}"/>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/LoginServlet"
                  method="post">

                <input type="hidden" name="tokenCSRF" value="<%= ProteccionCSRF.obtenerToken(request) %>">

                <label for="usuario">Usuario o DNI</label>
                <div class="campo">
                    <svg viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                    <input
                        type="text"
                        id="usuario"
                        name="usuario"
                        placeholder="Usuario o DNI"
                        maxlength="30"
                        autocomplete="username"
                        required>
                </div>

                <label for="clave">Clave</label>
                <div class="campo">
                    <svg viewBox="0 0 24 24" aria-hidden="true">
                        <rect x="4" y="11" width="16" height="10" rx="2"/>
                        <path d="M8 11V7a4 4 0 0 1 8 0v4"/>
                    </svg>
                    <input
                        type="password"
                        id="clave"
                        name="clave"
                        placeholder="••••••••"
                        maxlength="100"
                        autocomplete="current-password"
                        required>
                </div>

                <button type="submit">
                    Ingresar
                    <svg viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M5 12h14"/>
                        <path d="M13 6l6 6-6 6"/>
                    </svg>
                </button>
            </form>

        </div>
    </main>

</body>
</html>
