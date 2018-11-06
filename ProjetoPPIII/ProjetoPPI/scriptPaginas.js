$(document).ready(function () {
    $("#btnPerfilPaciente").trigger("click");
    $("#btnPerfil").trigger("click");
});

$("#btnPerfilPaciente").on("click", function () {
    $(this).addClass("ativo")       
    $("#btnConsultasPaciente").removeClass("ativo");
    
    $(".consultas-paciente").fadeOut("fast", function () {
        $(".perfil").fadeIn();
    });
    
});

$("#btnConsultasPaciente").on("click", function () {
    $(this).addClass("ativo")
    $("#btnPerfilPaciente").removeClass("ativo");
    
    $(".perfil").fadeOut("fast", function () {
        $(".consultas-paciente").fadeIn();
    });
});

$("#btnConsultaAtual").on("click", function () {
    $(this).addClass("ativo");
    $("#btnAgenda").removeClass("ativo");
    $("#btnPerfil").removeClass("ativo");

    $(".consultas-paciente").fadeOut("fast");
    $(".perfil").fadeOut("fast", function () {
        $(".consulta-atual").fadeIn();
    });
});

$("#btnAgenda").on("click", function () {
    $(this).addClass("ativo");
    $("#btnConsultaAtual").removeClass("ativo");
    $("#btnPerfil").removeClass("ativo");

    $(".perfil").fadeOut("fast");
    $(".consulta-atual").fadeOut("fast", function () {
        $(".consultas-paciente").fadeIn();
    });
});

$("#btnPerfil").on("click", function () {
    $(this).addClass("ativo");
    $("#btnConsultaAtual").removeClass("ativo");
    $("#btnAgenda").removeClass("ativo");

    $(".consultas-paciente").fadeOut("fast");
    $(".consulta-atual").fadeOut("fast", function () {
        $(".perfil").fadeIn();
    });
});
