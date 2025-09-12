$("#cep").on("keypress", function(e) {
    if (e.which == 13) {  // Verifica se a tecla pressionada é Enter
        var numCep = $("#cep").val();
        var url = "https://viacep.com.br/ws/" + numCep + "/json";

        $.ajax({
            url: url,
            type: "get",
            dataType: "json",

            success: function(dados) {
                console.log(dados);
                $("#estado").val(dados.uf);
                $("#cidade").val(dados.localidade);
                $("#endereco").val(dados.logradouro);
                $("#bairro").val(dados.bairro);
            }
        });
    }
});
