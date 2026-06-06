const Theme = {
  current: localStorage.getItem('theme') || 'dark',

  init() {
    this.apply(this.current);
    const toggle = document.getElementById('theme-toggle');
    if (toggle) {
      toggle.textContent = this.current === 'dark' ? '☀️' : '🌙';
      toggle.addEventListener('click', () => this.toggle());
    }
  },

  toggle() {
    this.current = this.current === 'dark' ? 'light' : 'dark';
    this.apply(this.current);
    localStorage.setItem('theme', this.current);
    const toggle = document.getElementById('theme-toggle');
    if (toggle) {
      toggle.textContent = this.current === 'dark' ? '☀️' : '🌙';
    }
  },

  apply(theme) {
    document.documentElement.setAttribute('data-theme', theme);
  }
};

document.addEventListener('DOMContentLoaded', () => Theme.init());
