$(document).ready(function () {
    $("#btnPerfilPaciente").trigger("click");
    $("#btnConsultaAtual").trigger("click");
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

    $(".agenda").fadeOut("fast");
    $(".perfil").fadeOut("fast", function () {
        $(".consultas-paciente").fadeIn();
    });
});

$("#btnAgenda").on("click", function () {
    $(this).addClass("ativo");
    $("#btnConsultaAtual").removeClass("ativo");
    $("#btnPerfil").removeClass("ativo");

    $(".perfil").fadeOut("fast");
    $(".consultas-paciente").fadeOut("fast", function () {
        $(".agenda").fadeIn();
    });
});

$("#btnPerfil").on("click", function () {
    $(this).addClass("ativo");
    $("#btnConsultaAtual").removeClass("ativo");
    $("#btnAgenda").removeClass("ativo");

    $(".agenda").fadeOut("fast");
    $(".consultas-paciente").fadeOut("fast", function () {
        $(".perfil").fadeIn();
    });
});
