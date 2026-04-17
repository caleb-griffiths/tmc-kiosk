document.addEventListener("click", function (event) {
    const link = event.target.closest("a");
    if (!link) return;

    const href = link.href || "";
    if (href.startsWith("https://4635302.app.netsuite.com/core/media/media.nl?id=")) {
        event.preventDefault();
        event.stopPropagation();
        window.location.href = "http://127.0.0.1:8080/pdf-blocked.html";
    }
}, true);
