if (document.querySelectorAll("[toast-list]") || document.querySelectorAll("[data-choices]") || document.querySelectorAll("[data-provider]")) {
    document.writeln("<script type='text/javascript' src='/static/assets/js/pages/plugins/toastify.js'><\/script>");
    document.writeln(`<script type='text/javascript' src='${choicesScript}'><\/script>`);
    document.writeln(`<script type='text/javascript' src='${flatpickrScript}'><\/script>`);
}
