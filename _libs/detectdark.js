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
function check_scheme() {
    if (targetNode.getAttribute(darkreader_field) == 'dark') {
        console.log("darkreader dark mode detected");
        var julialogo = "logo-dark.svg";
    } else {
        console.log("darkreader non-dark mode detected");
        var julialogo = "logo.svg";
    }
    var imgElements = document.getElementsByClassName('julialogo');
    for (var i = 0; i < imgElements.length; i++) {
        imgElements[i].src = changeFilePath(imgElements[i].src, julialogo);
    }
}

// Callback function to execute when mutations are observed
var callback = function (mutationsList, observer) {
    for (var mutation of mutationsList) {
        if (mutation.type === 'attributes' && mutation.attributeName === darkreader_field) {
            check_scheme();
        }
    }
};

document.addEventListener("DOMContentLoaded", function () {
    check_scheme();
    var observer = new MutationObserver(callback);
    observer.observe(targetNode, config);
});
