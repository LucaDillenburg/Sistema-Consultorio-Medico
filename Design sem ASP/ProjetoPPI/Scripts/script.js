function showNav() {
    $(".leftnav").css("display", "block");    
    $(".leftnav").animate({ left: 0 }, 500);    
}

function hideNav() {
    if ($(window).width() > 500)
        $(".leftnav").animate({ left: "-30vw" }, 500);
    else
        $(".leftnav").animate({ left: "-90vw" }, 500);
}

$(window).ready(function () {   
    $(".btnOpen").click(function () {
        showNav();
    });

    $(".btnClose").click(function () {
        hideNav();
    })

    responsive();
});

$(window).resize(function () {
    responsive();
});

function responsive() {
    if ($(window).width() < 992 && $(window).width() > 500) {
        //alert("meio");
        $(".leftnav").css("display", "none");
        $(".leftnav").css("left", "-30vw");
        $(".leftnav").css("width", "30vw");
        $(".content").css("width", "100vw");
        $(".content").css("left", "0");
        $(".btnOpen").css("display", "block");
        $(".btnClose").css("display", "inline-block");
        $(".section").css("padding", "20px 40px");
        $(".content > p").css("text-indent", "100px");
        $(".content > p").css("font-size", "2em");
        $(".content > p").css("width", "80%");
        $(".content > p").css("text-align", "justify");
        $(".content-title").css("font-size", "3em");
    }
    else if ($(window).width() <= 500) {
       // alert("menor");
        $(".leftnav").css("display", "none");
        $(".leftnav").css("left", "-90vw");
        $(".leftnav").css("width", "90vw");
        $(".content").css("width", "100vw");
        $(".content").css("left", "0");
        $(".btnOpen").css("display", "block");
        $(".btnClose").css("display", "inline-block");
        $(".section").css("padding", "5px 10px");
        $(".content > p").css("text-indent", "0");
        $(".content > p").css("font-size", "1.5em");
        $(".content > p").css("width", "90%");
        $(".content > p").css("text-align", "left");
        $(".content > h1").css("font-size", "3em");
    }
    else {
        //alert("maior");
        $('.leftnav').css("display", "block");
        $(".leftnav").css("left", "0");
        $(".leftnav").css("width", "15vw");
        $(".content").css("width", "85vw");
        $(".content").css("left", "15vw");
        $(".btnOpen").css("display", "none");
        $(".btnClose").css("display", "none");
        $(".section").css("padding", "20px 40px");
        $(".content > p").css("text-indent", "100px");
        $(".content > p").css("font-size", "2em");
        $(".content > p").css("width", "80%");
        $(".content > p").css("text-align", "justify");
        $(".content > h1").css("font-size", "3em");
    }
}