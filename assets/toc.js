// Table of contents for long-form Writing posts.
// - Builds anchor IDs for section headings (h2/h3) inside <article>.
// - Renders a "Contents" list at the top of the article, after the title.
// No-op unless we're on an individual /Writing/ post with enough sections.
document.addEventListener('DOMContentLoaded', function () {
    const path = window.location.pathname;
    const isWritingPost = path.includes('/Writing/') && !/\/Writing\/(index\.html)?$/.test(path);
    if (!isWritingPost) return;

    const article = document.querySelector('article');
    if (!article) return;

    // Collect section headings (skip the post title h1).
    const headings = Array.from(article.querySelectorAll('h2, h3'));
    if (headings.length < 3) return;

    const slugify = (text) =>
        text.toLowerCase().trim()
            .replace(/[^\w\s-]/g, '')
            .replace(/\s+/g, '-')
            .replace(/-+/g, '-');

    const used = new Set();
    headings.forEach((h) => {
        if (!h.id) {
            let base = slugify(h.textContent) || 'section';
            let id = base, n = 2;
            while (used.has(id) || document.getElementById(id)) { id = base + '-' + n++; }
            h.id = id;
        }
        used.add(h.id);
        h.style.scrollMarginTop = '1.5rem';
    });

    // Build the nav.
    const nav = document.createElement('nav');
    nav.className = 'toc';
    nav.setAttribute('aria-label', 'Table of contents');

    const title = document.createElement('div');
    title.className = 'toc-title';
    title.textContent = 'Contents';
    nav.appendChild(title);

    const ul = document.createElement('ul');
    headings.forEach((h) => {
        const li = document.createElement('li');
        li.className = 'toc-' + h.tagName.toLowerCase();
        const a = document.createElement('a');
        a.href = '#' + h.id;
        a.textContent = h.textContent;
        a.addEventListener('click', (e) => {
            e.preventDefault();
            h.scrollIntoView({ behavior: 'smooth', block: 'start' });
            history.replaceState(null, '', '#' + h.id);
        });
        li.appendChild(a);
        ul.appendChild(li);
    });
    nav.appendChild(ul);

    // Insert at the top of the article, right after the title (h1).
    const titleEl = article.querySelector('h1');
    if (titleEl && titleEl.nextSibling) {
        titleEl.parentNode.insertBefore(nav, titleEl.nextSibling);
    } else if (titleEl) {
        titleEl.parentNode.appendChild(nav);
    } else {
        article.insertBefore(nav, article.firstChild);
    }
});
