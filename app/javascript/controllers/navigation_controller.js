import { Controller } from "@hotwired/stimulus"

// Подключается через data-controller="navigation"
export default class extends Controller {
  static targets = ["menu"]

  // Отладочная переменная - установите false для отключения логов
  debug = false

  connect() {
    if (this.debug) console.log("🎯 Navigation controller connected");

    // Слушаем клики на turbo-stream ссылки
    this.clickHandler = this.handleClick.bind(this);
    document.addEventListener('click', this.clickHandler);

    // Слушаем Turbo события
    this.turboHandler = this.handleTurboStreamRender.bind(this);
    document.addEventListener('turbo:before-stream-render', this.turboHandler);
    document.addEventListener('turbo:load', this.updateMenuActiveState.bind(this));
  }

  disconnect() {
    if (this.debug) console.log("🔌 Navigation controller disconnected");
    document.removeEventListener('click', this.clickHandler);
    document.removeEventListener('turbo:before-stream-render', this.turboHandler);
    document.removeEventListener('turbo:load', this.updateMenuActiveState.bind(this));
  }

  // Проверка мобильного устройства
  isMobileDevice() {
    return window.innerWidth < 992;
  }

  // Метод для сворачивания sidebar на мобильных устройствах
  collapseSidebarOnMobile() {
    if (this.isMobileDevice()) {
      if (this.debug) console.log("📱 Mobile device detected, collapsing sidebar");

      // Находим кнопку сворачивания sidebar
      const sidebarToggle = document.querySelector('[data-lte-toggle="sidebar"]');
      if (sidebarToggle) {
        // Симулируем клик по кнопке сворачивания
        sidebarToggle.click();
        if (this.debug) console.log("🔄 Sidebar collapsed for mobile");
      }
    }
  }

  // Обновление активного состояния меню
  updateMenuActiveState() {
    const currentUrl = window.location.pathname;
    if (this.debug) console.log('🔍 Current URL:', currentUrl);

    // 1. Убираем ВСЕ активные состояния и открытые меню
    this.menuTarget.querySelectorAll('.nav-link.active').forEach(link => {
      if (this.debug) console.log('❌ Removing active from:', link.href);
      link.classList.remove('active');
    });

    this.menuTarget.querySelectorAll('.nav-item.menu-open').forEach(item => {
      if (this.debug) console.log('❌ Removing menu-open from nav-item');
      item.classList.remove('menu-open');

      // Принудительно закрываем подменю через стили
      const treeview = item.querySelector('.nav-treeview');
      if (treeview) {
        if (this.debug) console.log('🔒 Force closing submenu');
        treeview.style.display = 'none';
      }
    });

    // 2. Ищем совпадения URL среди всех ссылок
    const allMenuLinks = this.menuTarget.querySelectorAll('.nav-link[href]:not([href="#"])');
    let foundActiveLink = false;
    let bestMatch = null;
    let bestMatchScore = 0;

    allMenuLinks.forEach(link => {
      try {
        const linkPath = new URL(link.href, window.location.origin).pathname;
        if (this.debug) console.log('🔗 Checking link:', linkPath, 'vs current:', currentUrl);

        // Точное совпадение имеет наивысший приоритет
        if (linkPath === currentUrl) {
          if (this.debug) console.log('✅ Found exact match:', linkPath);
          bestMatch = link;
          bestMatchScore = 1000; // Максимальный приоритет
        }
        // Частичное совпадение (текущий URL начинается с пути ссылки)
        else if (currentUrl.startsWith(linkPath) && linkPath.length > 1) {
          const matchScore = linkPath.length; // Чем длиннее совпадение, тем лучше
          if (this.debug) console.log('🎯 Found partial match:', linkPath, 'score:', matchScore);

          if (matchScore > bestMatchScore) {
            bestMatch = link;
            bestMatchScore = matchScore;
          }
        }
      } catch (error) {
        if (this.debug) console.warn('⚠️ Invalid URL:', link.href, error);
      }
    });

    // 3. Активируем лучшее совпадение
    if (bestMatch) {
      if (this.debug) console.log('🏆 Activating best match:', bestMatch.href, 'score:', bestMatchScore);
      foundActiveLink = true;

      // Активируем найденную ссылку
      bestMatch.classList.add('active');

      // Если это ссылка в подменю - открываем родительское меню
      const parentTreeview = bestMatch.closest('.nav-treeview');
      if (parentTreeview) {
        const parentNavItem = parentTreeview.closest('.nav-item');
        if (parentNavItem) {
          if (this.debug) console.log('📂 Opening parent submenu for:', bestMatch.href);
          parentNavItem.classList.add('menu-open');

          // Принудительно показываем подменю через стили
          if (this.debug) console.log('🔓 Force opening submenu');
          parentTreeview.style.display = 'block';
        }
      } else {
        if (this.debug) console.log('📄 This is a main menu item:', bestMatch.href);
      }
    }

    if (!foundActiveLink) {
      if (this.debug) console.log('❓ No matching link found for URL:', currentUrl);
    }
  }

  // Обработчик кликов на turbo-stream ссылки
  handleClick(event) {
    const link = event.target.closest('a[data-turbo-stream="true"]');
    if (link && link.href) {
      if (this.debug) console.log('🖱️ Clicked turbo-stream link:', link.href);
      window.pendingNavigationUrl = link.href;

      // Сворачиваем sidebar при клике на ссылку в меню на мобильном устройстве
      const isMenuLink = link.closest('.sidebar-menu');
      if (isMenuLink && this.isMobileDevice()) {
        if (this.debug) console.log('📱 Collapsing sidebar on menu click for mobile');
        // Добавляем небольшую задержку чтобы клик успел обработаться
        setTimeout(() => {
          this.collapseSidebarOnMobile();
        }, 50);
      }
    }
  }

  // Обработчик Turbo Stream рендеринга
  handleTurboStreamRender(event) {
    if (window.pendingNavigationUrl) {
      if (this.debug) console.log('🚀 Updating URL to:', window.pendingNavigationUrl);
      // Обновляем адресную строку
      window.history.pushState({}, '', window.pendingNavigationUrl);
      window.pendingNavigationUrl = null;

      // Обновляем состояние меню
      setTimeout(() => this.updateMenuActiveState(), 10);
    }
  }
}
