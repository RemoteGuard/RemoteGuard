

function alterarSidebar(){
    var burguer = document.getElementById('burguer');
    var sidebar = document.getElementById('sidebar');
    sidebar = sidebar ?? document.querySelector('.headerBarResp');
    console.log(sidebar)

    burguer.classList.toggle('ativo')
    sidebar.classList.toggle('ativoSide')
}