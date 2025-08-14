// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import "adminlte"
import "fontawesome"
import "fontawesome_solid"

// Отслеживаем клики по навигационным ссылкам
document.addEventListener('click', function(event) {
    const link = event.target.closest('a[data-turbo-stream="true"]');
    if (link) {
        // console.log('Clicked on turbo-stream link:', link.href);
        // Сохраняем URL для последующего обновления адресной строки
        window.pendingNavigationUrl = link.href;
    }
});

// Обновляем URL после успешного рендеринга Turbo Stream
document.addEventListener('turbo:before-stream-render', function(event) {
    console.log('turbo:before-stream-render triggered', window.pendingNavigationUrl);

    if (window.pendingNavigationUrl) {
        // console.log('Updating URL to:', window.pendingNavigationUrl);
        // Обновляем адресную строку браузера
        window.history.pushState({}, '', window.pendingNavigationUrl);
        window.pendingNavigationUrl = null;
    }
});
