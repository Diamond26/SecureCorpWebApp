class AuthManager {
    constructor() {
        this.accessToken = sessionStorage.getItem('accessToken');
        this.refreshToken = sessionStorage.getItem('refreshToken');
        this.user = JSON.parse(sessionStorage.getItem('user') || '{}');
    }

    isAuthenticated() {
        return !!(this.accessToken && this.user.id);
    }

    getUser() {
        return this.user;
    }

    getToken() {
        return this.accessToken;
    }

    setTokens(accessToken, refreshToken) {
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
        sessionStorage.setItem('accessToken', accessToken);
        sessionStorage.setItem('refreshToken', refreshToken);
    }

    setUser(user) {
        this.user = user;
        sessionStorage.setItem('user', JSON.stringify(user));
    }

    async refresh() {
        if (!this.refreshToken) return false;
        
        try {
            const response = await fetch('/api/auth/refresh', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ refreshToken: this.refreshToken })
            });

            if (response.ok) {
                const data = await response.json();
                this.setTokens(data.accessToken, this.refreshToken);
                return true;
            }
        } catch (error) {
            console.error('Token refresh failed:', error);
        }
        
        return false;
    }

    async logout() {
        try {
            await fetch('/api/auth/logout', {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${this.accessToken}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ refreshToken: this.refreshToken })
            });
        } catch (error) {
            console.error('Logout error:', error);
        }

        sessionStorage.clear();
        window.location.href = '/login.html';
    }

    isAdmin() {
        return this.user.user_type === 'ADMIN';
    }
}

const auth = new AuthManager();