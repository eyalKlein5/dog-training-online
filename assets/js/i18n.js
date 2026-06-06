const I18N = {
  currentLang: localStorage.getItem('lang') || 'he',
  
  translations: {},
  
  async load(lang) {
    try {
      const res = await fetch(`assets/i18n/${lang}.json`);
      this.translations = await res.json();
      this.currentLang = lang;
      localStorage.setItem('lang', lang);
      this.apply();
    } catch(e) {
      console.error('i18n load failed:', e);
    }
  },
  
  apply() {
    document.documentElement.lang = this.currentLang;
    document.documentElement.dir = this.currentLang === 'he' ? 'rtl' : 'ltr';
    
    document.querySelectorAll('[data-i18n]').forEach(el => {
      const key = el.getAttribute('data-i18n');
      if (this.translations[key]) {
        if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') {
          el.placeholder = this.translations[key];
        } else {
          el.textContent = this.translations[key];
        }
      }
    });
    
    document.querySelectorAll('[data-i18n-html]').forEach(el => {
      const key = el.getAttribute('data-i18n-html');
      if (this.translations[key]) el.innerHTML = this.translations[key];
    });
  },
  
  init() {
    const select = document.getElementById('lang-select');
    if (select) {
      select.value = this.currentLang;
      select.addEventListener('change', (e) => this.load(e.target.value));
    }
    this.load(this.currentLang);
  }
};

document.addEventListener('DOMContentLoaded', () => I18N.init());
