class Router {
    constructor() {
        this.routes = {};
        this.currentRoute = null;
        this.contentContainer = null;
    }

    init(contentContainer) {
        this.contentContainer = contentContainer;
        
        window.addEventListener('popstate', (e) => {
            if (e.state && e.state.route) {
                this.loadRoute(e.state.route, false);
            }
        });

        document.addEventListener('click', (e) => {
            const link = e.target.closest('a[data-route]');
            if (link) {
                e.preventDefault();
                const route = link.getAttribute('data-route');
                const params = link.getAttribute('data-params');
                this.navigate(route, params ? JSON.parse(params) : {});
            }
        });
    }

    register(name, config) {
        this.routes[name] = config;
    }

    async navigate(routeName, params = {}, addToHistory = true) {
        if (!this.routes[routeName]) {
            console.error(`Route ${routeName} not found`);
            return;
        }

        await this.loadRoute(routeName, addToHistory, params);
    }

    async loadRoute(routeName, addToHistory = true, params = {}) {
        console.log(`Loading route: ${routeName}`, params);
        
        const route = this.routes[routeName];
        
        if (!route) {
            console.error(`Route ${routeName} not found`);
            return;
        }

        if (route.requiresAdmin && !auth.isAdmin()) {
            console.log('Admin route but user is not admin, redirecting to dashboard');
            this.navigate('dashboard');
            return;
        }

        this.currentRoute = routeName;

        const navbar = document.getElementById('mainNavbar');
        if (navbar) {
            navbar.style.display = route.showNavbar ? 'flex' : 'none';
        }

        if (addToHistory) {
            const url = route.path || `/${routeName}`;
            history.pushState({ route: routeName, params }, '', url);
        }

        try {
            console.log('Generating template...');
            const html = await route.template(params);
            console.log('Template generated, HTML length:', html.length);
            
            if (!this.contentContainer) {
                console.error('Content container is null!');
                return;
            }
            
            this.contentContainer.innerHTML = html;
            console.log('Template inserted into DOM');
            
            if (route.onLoad) {
                console.log('Executing onLoad callback...');
                await route.onLoad(params);
                console.log('onLoad callback completed');
            }
        } catch (error) {
            console.error(`Error loading route ${routeName}:`, error);
            this.contentContainer.innerHTML = `
                <div class="container">
                    <div class="error-message" style="display: block;">
                        Errore nel caricamento della pagina: ${error.message}
                    </div>
                </div>
            `;
        }
    }

    getCurrentRoute() {
        return this.currentRoute;
    }
}

const router = new Router();