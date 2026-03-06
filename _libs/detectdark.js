var targetNode = document.documentElement;
var config = { attributes: true, childList: false, subtree: false };
var darkreader_field = 'data-darkreader-scheme';
function changeFilePath(originalPath, newFileName) {
    const pathArray = originalPath.split('/');
    const fileNameIndex = pathArray.length - 1;
    pathArray[fileNameIndex] = newFileName;
    const modifiedPath = pathArray.join('/');
    return modifiedPath;
}
function updateLogo(isDark) {
    var julialogo = isDark ? "logo-dark.svg" : "logo.svg";
    var imgElements = document.getElementsByClassName('navbarjulialogo');
    for (var i = 0; i < imgElements.length; i++) {
        imgElements[i].src = changeFilePath(imgElements[i].src, julialogo);
    }
}
function check_scheme() {
    // Check DarkReader extension first
    if (targetNode.getAttribute(darkreader_field) == 'dark') {
        updateLogo(true);
        return;
    }
    // Check native OS dark mode preference
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
        updateLogo(true);
        return;
    }
    updateLogo(false);
}

// Callback function to execute when mutations are observed (DarkReader)
var callback = function (mutationsList, observer) {
    for (var mutation of mutationsList) {
        if (mutation.type === 'attributes' && mutation.attributeName === darkreader_field) {
            check_scheme();
        }
    }
};

document.addEventListener("DOMContentLoaded", function () {
    check_scheme();
    // Watch for DarkReader changes
    var observer = new MutationObserver(callback);
    observer.observe(targetNode, config);
    // Watch for native OS dark mode changes
    if (window.matchMedia) {
        window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', check_scheme);
    }
});
