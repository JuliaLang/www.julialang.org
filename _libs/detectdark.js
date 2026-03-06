(function () {
    var targetNode = document.documentElement;
    var darkreaderField = 'data-darkreader-scheme';

    function changeFilePath(originalPath, newFileName) {
        var pathArray = originalPath.split('/');
        pathArray[pathArray.length - 1] = newFileName;
        return pathArray.join('/');
    }

    function updateLogo(isDark) {
        var julialogo = isDark ? 'logo-dark.svg' : 'logo.svg';
        var imgElements = document.getElementsByClassName('navbarjulialogo');
        for (var i = 0; i < imgElements.length; i++) {
            imgElements[i].src = changeFilePath(imgElements[i].src, julialogo);
        }
    }

    function checkScheme() {
        // Only swap logo when DarkReader is actively injecting a dark theme.
        // OS prefers-color-scheme alone should not change the logo since
        // the site handles its own dark mode separately via data-theme.
        var isDark = targetNode.getAttribute(darkreaderField) === 'dark';
        updateLogo(isDark);
    }

    document.addEventListener('DOMContentLoaded', function () {
        checkScheme();

        // Watch for DarkReader attribute changes
        var observer = new MutationObserver(function (mutationsList) {
            for (var i = 0; i < mutationsList.length; i++) {
                if (mutationsList[i].type === 'attributes' &&
                    mutationsList[i].attributeName === darkreaderField) {
                    checkScheme();
                }
            }
        });
        observer.observe(targetNode, { attributes: true, childList: false, subtree: false });

    });
})();
