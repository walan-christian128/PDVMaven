<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Criar um modal sem JS</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>
      <a href="#modal_1" class="btn">Abrir modal</a>
    <div id="modal_1" class="modal">
        <div class="modal__content">
            <h2 class="modal__title">Meu primeiro modal</h2>
            <div class="table">
               <div id="table" class="table" name="table">
                <table class="table" name>
                  <thead>
                        <tr>
                        <th>Decrição</th>
                        <th>Preço</th>
                        <th>Subtotal</th>

                        </tr>


                  </thead> 

                     <tbody>
                          <tr>
                            <td>BRAHMA 600ML</td>
                            <td>R$150,00</td>
                            <td>R$250,00</td>
                          </tr>

                     </tbody>


                </table>


               </div>
            </div>
            <a href="#" class="modal__link">OK</a>
        </div>
    </div>
    <div id="modal_2" class="modal modal--2">
        <div class="modal__content">
            <h2 class="modal__title">Meu primeiro modal</h2>
            <p class="modal__description">
                Lorem ipsum dolor sit amet consectetur adipisicing elit. Perferendis id error accusamus pariatur quasi
                est amet maiores tempore, eum beatae expedita fugiat modi, ipsum commodi laborum voluptatem, assumenda
                et quod?
            </p>
            <a href="#" class="modal__link">OK</a>
        </div>
    </div>
</body>

</html>