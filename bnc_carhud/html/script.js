$(function () {

    function display(bool) {
        if (bool) {
            $('body').show();
        } else {
            $('body').hide();
        }
    }
    display(false)



    window.addEventListener('message', function(event) {
        if (event.data.type === "ui") {
            display(event.data.status)
        }
        else if (event.data.type === "update") {
            document.getElementById("speed").innerHTML = event.data.speed + " KM/H";
            document.getElementById("rpm").innerHTML = event.data.rpm + " RPM";
            document.getElementById("gear").innerHTML = event.data.gear + " GEAR";
        }
})
})
        