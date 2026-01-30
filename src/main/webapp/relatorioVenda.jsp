<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Relatório de Venda</title>

<style>
html, body {
    margin: 0;
    padding: 0;
    height: 100%;
}

/* 🔥 Barra superior fixa */
.topbar {
    height: 50px;
    background: #2e7d32;
    display: flex;
    align-items: center;
    padding: 0 15px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.3);
}

.btn-voltar {
    background: white;
    color: #2e7d32;
    border: none;
    padding: 8px 14px;
    border-radius: 6px;
    font-weight: bold;
    cursor: pointer;
}

/* iframe ocupa o resto da tela */
iframe {
    width: 100%;
    height: calc(100% - 50px);
    border: none;
}
</style>
</head>

<body>

<div class="topbar">
    <button class="btn-voltar" onclick="voltarVendas()">⬅ Voltar para Vendas</button>
</div>

<iframe src="exibirRelatorio"></iframe>

<script>
function voltarVendas() {
    window.location.replace("realizarVendas.jsp");
}
</script>

</body>
</html>
